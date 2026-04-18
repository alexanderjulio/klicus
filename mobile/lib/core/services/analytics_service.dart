import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';

class AnalyticsService {
  final ApiService _apiService;

  AnalyticsService(this._apiService);

  /// Initialize and track core app events (Install & Session)
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Track App Install (Only once per device/install)
      bool hasTrackedInstall = prefs.getBool('analytics_install_tracked') ?? false;
      if (!hasTrackedInstall) {
        await trackEvent(eventType: 'install');
        await prefs.setBool('analytics_install_tracked', true);
        debugPrint('📈 [Analytics] First Install Tracked');
      }

      // 2. Track Session (Every launch)
      await trackEvent(eventType: 'session');
      debugPrint('📈 [Analytics] Session Tracked');
      
    } catch (e) {
      debugPrint('❌ [Analytics] Error during init: $e');
    }
  }

  /// Send event to KLICUS Metrics API
  Future<void> trackEvent({
    String? adId,
    required String eventType,
  }) async {
    try {
      await _apiService.post('/metrics/track', data: {
        'adId': adId,
        'eventType': eventType,
      });
    } catch (e) {
      // Silently fail to not affect UI
      debugPrint('⚠️ [Analytics] Failed to track $eventType: $e');
    }
  }

  /// Get statistics for a specific ad
  Future<dynamic> getAdStats(String adId, {String range = '30'}) async {
    return await _apiService.get('/user/analytics/$adId?range=$range');
  }
}
