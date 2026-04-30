import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/services/push_service.dart';
import '../../core/services/stats_provider.dart';
import '../profile/profile_provider.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final StatsProvider _statsProvider;
  final ProfileProvider _profileProvider;

  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;

  // Delegating getters — all existing screens continue to compile unchanged
  String? get error => _error ?? _profileProvider.error;
  Map<String, dynamic>? get dashboardStats => _statsProvider.dashboardStats;
  Future<void> fetchDashboardStats() => _statsProvider.fetchDashboardStats();

  AuthProvider({
    required ApiService apiService,
    required StatsProvider statsProvider,
    required ProfileProvider profileProvider,
  })  : _apiService = apiService,
        _statsProvider = statsProvider,
        _profileProvider = profileProvider;

  // Called by ProfileProvider.updateProfile callback to sync currentUser
  void updateCurrentUser(Map<String, dynamic> user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Delegates profile update to ProfileProvider
  Future<bool> updateProfile(Map<String, dynamic> data) =>
      _profileProvider.updateProfile(data, onUserUpdated: updateCurrentUser);

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

        await _apiService.saveToken(token);
        if (_currentUser != null) {
          await _apiService.saveUserData(_currentUser!);
        }

        await PushNotificationService.registerToken();
        await _statsProvider.fetchDashboardStats();

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
    _currentUser = null;
    _statsProvider.clearStats();
    notifyListeners();
  }

  /// Check initial auth state and restore session
  Future<void> checkAuth() async {
    try {
      final cachedToken = await _apiService.getStoredToken();
      final cachedUser = await _apiService.getUserData();

      if (cachedToken != null && cachedUser != null) {
        _currentUser = cachedUser;
        _isAuthenticated = true;
        notifyListeners();

        // Wire session-expired callback so any 401 triggers a clean logout
        _apiService.onSessionExpired = () async {
          await logout();
        };

        PushNotificationService.registerToken();

        try {
          final response = await _apiService.get('/auth/me');
          if (response.statusCode == 200) {
            _currentUser = response.data['user'];
            await _apiService.saveUserData(_currentUser!);
            await _statsProvider.fetchDashboardStats();
          } else {
            await logout();
          }
        } on Exception catch (e) {
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
}
