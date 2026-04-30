import 'package:dio/dio.dart';
import '../api_service.dart';

class UserRepository {
  final ApiService _api;
  UserRepository(this._api);

  Future<Response> fetchUserAds() =>
      _api.get('/user/ads?t=${DateTime.now().millisecondsSinceEpoch}');

  Future<Response> deleteAccount() => _api.delete('/user/account');

  Future<Response> getNotificationPreferences() =>
      _api.get('/user/notification-preferences');

  Future<Response> updateNotificationPreferences(Map<String, dynamic> prefs) =>
      _api.put('/user/notification-preferences', data: prefs);
}
