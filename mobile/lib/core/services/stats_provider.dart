import 'package:flutter/material.dart';
import '../api_service.dart';

class StatsProvider with ChangeNotifier {
  final ApiService _apiService;

  Map<String, dynamic>? _dashboardStats;
  Map<String, dynamic>? get dashboardStats => _dashboardStats;

  StatsProvider(this._apiService);

  void clearStats() {
    _dashboardStats = null;
    notifyListeners();
  }

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
}
