import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class NotificationProvider with ChangeNotifier, WidgetsBindingObserver {
  final ApiService _apiService = ApiService();

  List<dynamic> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  Timer? _pollingTimer;
  Duration _currentInterval = const Duration(seconds: 10);
  static const Duration _minInterval = Duration(seconds: 10);
  static const Duration _maxInterval = Duration(minutes: 5);

  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  void startPolling() {
    WidgetsBinding.instance.addObserver(this);
    _scheduleNext();
    fetchNotifications(silent: true);
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _scheduleNext() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer(_currentInterval, () async {
      await fetchNotifications(silent: true);
      _scheduleNext();
    });
  }

  void _onSuccess() {
    _currentInterval = _minInterval;
  }

  void _onError() {
    final doubled = _currentInterval * 2;
    _currentInterval = doubled > _maxInterval ? _maxInterval : doubled;
    debugPrint('Notification backoff: next poll in ${_currentInterval.inSeconds}s');
  }

  @visibleForTesting
  Duration get currentIntervalForTest => _currentInterval;
  @visibleForTesting
  void onSuccessForTest() => _onSuccess();
  @visibleForTesting
  void onErrorForTest() => _onError();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      stopPolling();
    } else if (state == AppLifecycleState.resumed) {
      _currentInterval = _minInterval;
      _scheduleNext();
      fetchNotifications(silent: true);
    }
  }

  Future<void> fetchNotifications({bool silent = false}) async {
    final token = await _apiService.getStoredToken();
    final guestId = await _apiService.getGuestId();

    if (token == null && guestId == null) {
      stopPolling();
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
        _onSuccess();
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        debugPrint('Notification sync stopped: Unauthorized');
        stopPolling();
      } else {
        debugPrint('Error fetching notifications: $e');
        _onError();
      }
    } finally {
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

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
          if (index != -1) _notifications[index]['is_read'] = 1;
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
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    super.dispose();
  }
}
