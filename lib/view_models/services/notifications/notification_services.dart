import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hungry/main.dart';

class NotificationServices extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    requestNotificationPermission();
    isTokenRefresh();
  }

  Future<void> initialize(BuildContext context) async {
    await _setupLocalNotifications();
    _setupFirebaseMessaging(context);
    await setupInteractMessage(context);
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
  }

  void _setupFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        _logNotification(message);
      }

      if (Platform.isIOS) {
        await _setForegroundPresentationOptions();
      }

      if (Platform.isAndroid && message.notification != null) {
        await _showNotification(message);
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      if (kDebugMode) {
        print('Notification permission: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permission: $e');
      }
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    if (message.notification == null || message.notification!.android == null)
      return;

    final channel = AndroidNotificationChannel(
      message.notification!.android!.channelId ?? 'default_channel',
      message.notification!.android!.channelId ?? 'Default Channel',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      enableVibration: true,
    );

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Channel for app notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      0,
      message.notification!.title ?? 'Notification',
      message.notification!.body ?? '',
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  Future<String> getDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      return token ?? '';
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
      return '';
    }
  }

  void isTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) {
      if (kDebugMode) {
        print('Token refreshed: $token');
      }
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(context, message);
    });
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload == null) return;
    _navigateBasedOnPayload(response.payload!);
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    _navigateBasedOnPayload(json.encode(message.data));
  }

  void _navigateBasedOnPayload(String payload) {
    try {
      final data = json.decode(payload) as Map<String, dynamic>;
      final type = (data['type']?.toString().toLowerCase() ?? '');

      String? route;
      Map<String, dynamic> navigationArgs = {};
      switch (type) {
        case 'leftover_food':
          route = '/donation_details';
          navigationArgs = {
            'id': data['id']?.toString() ?? '',
            'name': data['name']?.toString() ?? '',
            'address': data['address']?.toString() ?? '',
          };
          break;

        default:
          return;
      }
      navigatorKey.currentState?.pushNamed(route, arguments: navigationArgs);
    } catch (e) {
      if (kDebugMode) {
        log('Error handling notification payload: $e');
      }
    }
  }

  Future<void> _setForegroundPresentationOptions() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _logNotification(RemoteMessage message) {
    if (message.notification != null) {
      log('Notification title: ${message.notification!.title}');
      log('Notification body: ${message.notification!.body}');
    }
    if (message.notification?.android != null) {
      log('Android count: ${message.notification!.android!.count}');
    }
    log('Notification data: ${message.data}');
  }
}
