import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  static const route = '/alert-screen';

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playSound();
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource(
        "alert.mp3")); // Specify the correct path to your sound file
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RemoteMessage message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.withOpacity(0.5),
        title: const Text(
          'Alert !',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 120, bottom: 20),
                  child: Icon(Icons.report_gmailerrorred,
                      color: Colors.red, size: 100),
                ),
                Text(
                  '${message.notification?.body}',
                  style: const TextStyle(color: Colors.white),
                ),
                // Text('${message.notification?.body}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
