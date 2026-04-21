import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../api_service.dart';
import '../../features/home/ad_detail_screen.dart';
import '../../models/ad_model.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static String? fcmToken;
  static GlobalKey<NavigatorState>? navigatorKey;

  /// Initialize Firebase Messaging and Local Notifications
  static Future<void> initialize(GlobalKey<NavigatorState> key) async {
    navigatorKey = key;
    
    // 1. Request permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Get the token
    fcmToken = await _firebaseMessaging.getToken();

    // 3. Setup Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
         // Payload is usually a stringified map
         // For now, simpler: we check if there's a stored message
      },
    );

    // 4. Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // 5. Handle Background/Terminated state clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message);
    });

    // Check if app was opened from a terminated state by a notification
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage);
    }
  }

  static void _handleMessageNavigation(RemoteMessage message) {
    final data = message.data;
    if (data.containsKey('adId') && data['adId'].isNotEmpty) {
      final adId = data['adId'];
      _navigateToAd(adId);
    }
  }

  static void _navigateToAd(String adId) async {
    if (navigatorKey?.currentState == null) return;
    
    // Fetch ad data and push screen
    try {
      final api = ApiService();
      final res = await api.get('/anuncio/$adId');
      if (res.data['success']) {
        final ad = AdModel.fromJson(res.data['data']);
        navigatorKey!.currentState!.push(
          MaterialPageRoute(builder: (_) => AdDetailScreen(ad: ad))
        );
      }
    } catch (e) {
      debugPrint('Deep Link Error: $e');
    }
  }

  static void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'klicus_main_channel',
      'Alertas KLICUS',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: message.data.toString(),
    );
  }

  static Future<void> registerToken() async {
    if (fcmToken == null) return;
    try {
      final apiService = ApiService();
      
      String deviceType = 'web';
      if (!kIsWeb) {
        deviceType = Platform.isAndroid ? 'android' : 'ios';
      }

      await apiService.post('/user/fcm-token', data: {
        'token': fcmToken,
        'deviceType': deviceType,
      });
      debugPrint('FCM Token registered: $fcmToken ($deviceType)');
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
    }
  }
}
