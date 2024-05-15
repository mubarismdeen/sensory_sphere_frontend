import 'package:admin/globalState.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> handleForegroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  // Display the notification
  await displayNotification(message);
}

Future<void> displayNotification(RemoteMessage message) async {
  const sound = 'default_sound'; // Default sound if not provided
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    // 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound(
        sound), // Use sound specified in payload
  );
  const NotificationDetails platformChannelSpecifics =
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

  // Display the notification with sound
  await displayNotification(message);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onMessage
          .listen(handleForegroundMessage); // Listen to foreground messages
      final fCMToken = await _firebaseMessaging.getToken();
      GlobalState.setToken(fCMToken ?? "");
      print('Token: $fCMToken');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }
}
