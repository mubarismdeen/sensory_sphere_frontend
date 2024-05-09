import 'package:admin/globalState.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      final fCMToken = await _firebaseMessaging.getToken();
      GlobalState.setToken(fCMToken ?? "");
      print('Token: $fCMToken');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }
}
