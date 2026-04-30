import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class ProfileProvider with ChangeNotifier {
  final ApiService _apiService;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  ProfileProvider(this._apiService);

  /// Updates the user profile. On success, calls [onUserUpdated] with the
  /// fresh profile data so AuthProvider can sync its _currentUser.
  Future<bool> updateProfile(
    Map<String, dynamic> data, {
    required void Function(Map<String, dynamic>) onUserUpdated,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.put('/user/profile', data: data);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final profileRes = await _apiService.get('/user/profile');
        if (profileRes.statusCode == 200) {
          final profileData = Map<String, dynamic>.from(profileRes.data['profile']);
          if (profileData['name'] == null && profileData['full_name'] != null) {
            profileData['name'] = profileData['full_name'];
          }
          await _apiService.saveUserData(profileData);
          onUserUpdated(profileData);
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
