import 'dart:convert';
import 'dart:typed_data';

import 'package:admin/globalState.dart';
import 'package:admin/models/AlertDto.dart';
import 'package:admin/pages/Alert/alert_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> handleForegroundMessage(RemoteMessage? message) async {
  if (message == null) return;

  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  AlertDto alertDto = AlertDto(message: message, playSound: false);
  navigatorKey.currentState?.pushNamed(AlertScreen.route, arguments: alertDto);
}

Future<void> displayNotification(RemoteMessage message) async {
  final vibrationPattern =
      Int64List.fromList([0, 1000, 500, 1000]); // Vibration pattern

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel', // Ensure this matches the channel ID
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications',
    importance: Importance.max,
    priority: Priority.high,
    enableVibration: true,
    vibrationPattern: vibrationPattern,
  );
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    platformChannelSpecifics,
    payload: message.data.toString(),
  );
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  await displayNotification(message);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.max, // Ensure this is set to max for high priority
    playSound: true,
    enableVibration: true,
    vibrationPattern:
        Int64List.fromList([0, 1000, 500, 1000]), // Vibration pattern
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;

      AlertDto alertDto = AlertDto(message: event, playSound: true);
      navigatorKey.currentState
          ?.pushNamed(AlertScreen.route, arguments: alertDto);

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_launcher',
                enableVibration: true,
                vibrationPattern: Int64List.fromList([
                  0,
                  1000,
                  500,
                  1000
                ]) // Ensure this matches the vibration pattern
                ),
          ),
          payload: jsonEncode(event.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      handleForegroundMessage(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      GlobalState.setToken(fCMToken ?? "");
      print('Token: $fCMToken');
      await initPushNotifications();
      await initLocalNotifications();
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }
}
