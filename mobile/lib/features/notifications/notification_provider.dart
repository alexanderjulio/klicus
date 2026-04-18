import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<dynamic> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;
  Timer? _pollingTimer;

  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  /// Start periodic sync for notifications
  void startPolling() {
    _pollingTimer?.cancel();
    fetchNotifications(silent: true);
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) => fetchNotifications(silent: true));
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Fetch user notifications from server
  Future<void> fetchNotifications({bool silent = false}) async {
    // 1. Safety check: Don't poll if we don't even have a token
    final token = await _apiService.getStoredToken();
    if (token == null) {
      if (_pollingTimer != null) stopPolling();
      return;
    }

    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final response = await _apiService.get('/user/notifications');
      if (response.data['success'] == true) {
        _notifications = response.data['notifications'];
        _calculateUnread();
      }
    } catch (e) {
      // If we get a 401, it means session expired or invalid - stop the noise
      if (e.toString().contains('401')) {
        debugPrint('Notification sync stopped: Unauthorized');
        stopPolling();
      } else {
        debugPrint('Error fetching notifications: $e');
      }
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      } else {
        notifyListeners(); // Update unreadCount badge
      }
    }
  }

  /// Mark a single notification or all as read
  Future<void> markAsRead({String? id, bool all = false}) async {
    try {
      final response = await _apiService.patch('/user/notifications', data: {
        'id': id,
        'all': all,
      });

      if (response.statusCode == 200) {
        if (all) {
          for (var n in _notifications) {
            n['is_read'] = 1;
          }
        } else if (id != null) {
          final index = _notifications.indexWhere((n) => n['id'].toString() == id);
          if (index != -1) {
            _notifications[index]['is_read'] = 1;
          }
        }
        _calculateUnread();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  void _calculateUnread() {
    _unreadCount = _notifications.where((n) => n['is_read'] == 0 || n['is_read'] == false).length;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
