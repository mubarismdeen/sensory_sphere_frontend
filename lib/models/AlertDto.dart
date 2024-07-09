import 'package:firebase_messaging/firebase_messaging.dart';

class AlertDto {
  RemoteMessage message;
  bool playSound;

  AlertDto({required this.message, required this.playSound});
}
