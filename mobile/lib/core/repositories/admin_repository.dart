import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart';

class AdminRepository {
  final ApiService _api;
  AdminRepository(this._api);

  /// Returns admin dashboard stats and the pending-ads queue.
  /// [period] can be '7d' or '30d'.
  Future<Response> getStats({String period = '7d'}) =>
      _api.get('/admin/stats', queryParameters: {'period': period});

  /// Approve or reject a pending ad.
  Future<Response> approveAd({
    required String adId,
    required String status,
    String? reason,
  }) =>
      _api.post('/admin/approve-ad', data: {
        'adId': adId,
        'status': status,
        'reason': reason ?? 'Aprobado por el administrador',
      });

  // ── Banners ──────────────────────────────────────────────────────────────

  Future<Response> getBanners() => _api.get('/admin/banners');

  Future<Response> createBanner(Map<String, dynamic> data) =>
      _api.post('/admin/banners', data: data);

  Future<Response> updateBanner(Map<String, dynamic> data) =>
      _api.put('/admin/banners', data: data);

  Future<Response> deleteBanner(int id) =>
      _api.delete('/admin/banners', queryParameters: {'id': id});

  Future<Response> uploadBannerImage(XFile image) =>
      _api.uploadFile('/admin/upload', image, extraData: {'type': 'marketing'});

  // ── Interstitial ─────────────────────────────────────────────────────────

  Future<Response> getInterstitial() => _api.get('/interstitial');

  Future<Response> createInterstitial(String imageUrl, {String? ctaLink}) =>
      _api.post('/admin/banners', data: {
        'title': '',
        'image_url': imageUrl,
        'cta_link': ctaLink,
        'is_active': true,
        'type': 'interstitial',
      });

  Future<Response> updateInterstitial(int id, {String? imageUrl, String? ctaLink, bool? isActive}) =>
      _api.put('/admin/banners', data: {
        'id': id,
        if (imageUrl != null) 'image_url': imageUrl,
        if (ctaLink != null) 'cta_link': ctaLink,
        if (isActive != null) 'is_active': isActive,
      });

  // ── Push Notifications ───────────────────────────────────────────────────

  Future<Response> searchUsers(String query) =>
      _api.get('/admin/users/search', queryParameters: {'q': query});

  Future<Response> broadcast(Map<String, dynamic> payload) =>
      _api.post('/admin/broadcast', data: payload);
}
