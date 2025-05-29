import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hungry/main.dart';

class NotificationServices extends GetxController {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        selectNotification(notificationResponse.payload);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        enableVibration: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(), channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token.toString();
    // return token;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msj') {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MessageScreen(
      //               id: message.data['id'],
      //             )));
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

Future selectNotification(String? payload) async {
  Map<String, dynamic> myMap = json.decode(payload!);
  print("payload$payload");
  print("myMap type${myMap["type"]}");
  if (myMap["type"].toString().toLowerCase() == "katha" ||
      myMap["type"].toString().toLowerCase() == "live" ||
      myMap["type"].toString().toLowerCase() == "sabha") {
    var title = myMap["title"].toString();
    var body = myMap["body"].toString();
    var videoId = myMap["url"].toString();
    var slug = myMap["slug"].toString();
    print("video ID$videoId");
    final Map<String, dynamic> arguments = {
      'title': title,
      'body': body,
      'videoId': videoId,
      'slug': slug,
    };
    navigatorKey.currentState?.pushNamed('/katha', arguments: arguments);
  } else if (myMap["type"].toString().toLowerCase() == "audio" ||
      myMap["type"].toString().toLowerCase() == "book") {
    var title = myMap["title"].toString();
    var body = myMap["body"].toString();
    var videoId = myMap["url"].toString();
    final Map<String, dynamic> arguments = {
      'title': title,
      'body': body,
      'videoId': videoId,
    };
    navigatorKey.currentState?.pushNamed('/web', arguments: arguments);
  } else if (myMap["type"].toString() == "News") {
    var title = myMap["title"].toString();
    var body = myMap["body"].toString();
    var newsId = myMap["id"].toString();
    var image = myMap["image"].toString();
    var slug = myMap["slug"].toString();
    final Map<String, dynamic> arguments = {
      'title': title,
      'body': body,
      'newsId': newsId,
      'image': image,
      'slug': slug,
    };
    navigatorKey.currentState?.pushNamed('/news', arguments: arguments);
  } else if (myMap["type"].toString() == "Gvijay") {
    print("called type${myMap["type"]}");
    /*  var title = myMap["title"].toString();
    var body = myMap["body"].toString();
    var gvijayId = myMap["id"].toString();
    var image = myMap["image"].toString();*/
    var pdf = myMap["url"].toString();
    final Map<String, dynamic> arguments = {
      /*'title': title,
      'body': body,
      'gId': gvijayId,
      'image': image,*/
      'pdf': pdf,
    };
    navigatorKey.currentState?.pushNamed('/gvijay', arguments: arguments);
  }
}
