import 'package:dio/dio.dart';
import '../api_service.dart';

class AdRepository {
  final ApiService _api;
  AdRepository(this._api);

  Future<Response> fetchAds({
    required String category,
    required String city,
    required String query,
    required int page,
    required int limit,
  }) =>
      _api.get('/pautas', queryParameters: {
        'category': category,
        'city': city,
        'q': query,
        'page': page,
        'limit': limit,
      });

  Future<Response> fetchSuggestions(String query, {int limit = 8}) =>
      _api.get('/search', queryParameters: {
        'q': query,
        'type': 'suggestions',
        'limit': limit,
      });

  Future<Response> fetchBanners() => _api.get('/banners');

  Future<Response> updateAd(String adId, dynamic formData) =>
      _api.put('/anuncio/$adId', data: formData);
}
