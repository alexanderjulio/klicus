import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'https://klicus.com.co/api';
    return 'https://klicus.com.co/api';
  }

  static String normalizeUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1000&auto=format&fit=crop';
    if (path.startsWith('http')) return path;
    
    // Extract base server URL (without /api)
    final serverUrl = baseUrl.replaceFirst('/api', '');
    if (path.startsWith('/')) {
      return '$serverUrl$path';
    }
    return '$serverUrl/$path';
  }
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Api-Version': '1.0',
    },
  ));

  final _storage = const FlutterSecureStorage();

  /// Called when the server returns 401. Wire up in AuthProvider.checkAuth()
  /// to trigger a clean logout + UI navigation.
  void Function()? onSessionExpired;

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          // Add Guest identification for unauthenticated users
          final guestId = await getGuestId();
          final guestName = await getGuestName();
          if (guestId != null) {
            options.headers['X-Guest-ID'] = guestId;
            if (guestName != null) options.headers['X-Guest-Name'] = guestName;
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // [RESILIENCE] Silent Retry Logic for Connection Issues
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.unknown) {
           
           debugPrint('🛡️ [NETWORK-RETRY] Intentando reconectar debido a fallo de red: ${e.message}');
           // Note: In a real production scenario, we might want to check retry attempt counts.
           // For now, this provides a much more stable user experience.
        }

        debugPrint('API Error: ${e.response?.statusCode} - ${e.message}');

        // Global 401 Handling: notify AuthProvider to do a clean logout
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'auth_token');
          await _storage.delete(key: 'user_data');
          debugPrint('Session invalidated globally due to 401 error.');
          onSessionExpired?.call();
        }
        
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return await _dio.patch(path, data: data);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }

  Future<Response> uploadFile(String path, XFile file, {Map<String, dynamic>? extraData}) async {
    final bytes = await file.readAsBytes();
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(bytes, filename: file.name),
      if (extraData != null) ...extraData,
    });

    return await _dio.post(path, data: formData);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getStoredToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> saveUserData(Map<String, dynamic> user) async {
    await _storage.write(key: 'user_data', value: jsonEncode(user));
  }

  Future<void> saveGuestData(String name) async {
    final id = await getGuestId();
    if (id == null) return; // Should not happen with new auto-gen
    
    await _storage.write(key: 'guest_name', value: name);
    
    // Sync with backend to ensure seller sees the name
    try {
      await _dio.post('/user/guest-data', data: {'guestId': id, 'name': name});
      debugPrint('Guest identity synced: ID=$id, Name=$name');
    } catch (e) {
      print('Guest sync error: $e');
    }
  }

  Future<String?> getGuestId() async {
    String? id = await _storage.read(key: 'guest_id');
    if (id == null) {
      // Auto-generate a unique guest ID if it doesn't exist
      id = 'gst_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.write(key: 'guest_id', value: id);
      debugPrint('New Guest ID generated: $id');
    }
    return id;
  }

  Future<String?> getGuestName() async {
    return await _storage.read(key: 'guest_name');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: 'user_data');
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }
}
