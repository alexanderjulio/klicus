import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/services/push_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? _dashboardStats;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  Map<String, dynamic>? get dashboardStats => _dashboardStats;

  /// Fetch user dashboard statistics
  Future<void> fetchDashboardStats() async {
    try {
      final response = await _apiService.get('/user/dashboard-stats');
      if (response.data['success'] == true) {
        _dashboardStats = response.data['stats'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching dashboard stats: $e');
    }
  }

  /// Login attempt
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        _currentUser = response.data['user'];
        _isAuthenticated = true;

        // Persist session locally
        await _apiService.saveToken(token);
        if (_currentUser != null) {
          await _apiService.saveUserData(_currentUser!);
        }
        
        // Register Push Token
        await PushNotificationService.registerToken();
        
        // Fetch stats immediately after login
        await fetchDashboardStats();
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Credenciales inválidas o error de conexión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register attempt
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Error en el registro. Es posible que el correo ya exista.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _apiService.logout();
    _isAuthenticated = false;
    _dashboardStats = null;
    _currentUser = null;
    notifyListeners();
  }

  /// Check initial auth state and restore session
  Future<void> checkAuth() async {
    try {
      // 1. Load cached data for instant UI display
      final cachedToken = await _apiService.getStoredToken();
      final cachedUser = await _apiService.getUserData();

      if (cachedToken != null && cachedUser != null) {
        _currentUser = cachedUser;
        _isAuthenticated = true;
        notifyListeners(); // Immediate update with cached data

        try {
          // 2. Validate session & update profile in background
          final response = await _apiService.get('/auth/me');
          if (response.statusCode == 200) {
            _currentUser = response.data['user'];
            await _apiService.saveUserData(_currentUser!);
            await fetchDashboardStats();
          } else {
            // Token expired or invalid
            await logout();
          }
        } on Exception catch (e) {
          // Check if it's a 401 error via direct comparison or status code
          if (e.toString().contains('401')) {
            await logout();
          }
          debugPrint('Session validation error: $e');
        }
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      debugPrint('CheckAuth overall error: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.put('/user/profile', data: data);
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Refetch complete profile to ensure local state is perfect
        final profileRes = await _apiService.get('/user/profile');
        if (profileRes.statusCode == 200) {
          final profileData = profileRes.data['profile'];
          // Ensure consistency: map full_name to name if missing
          if (profileData['name'] == null && profileData['full_name'] != null) {
            profileData['name'] = profileData['full_name'];
          }
          _currentUser = profileData;
          await _apiService.saveUserData(_currentUser!);
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response.data['error'] ?? 'Error al actualizar perfil';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Error de conexión al actualizar perfil';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
