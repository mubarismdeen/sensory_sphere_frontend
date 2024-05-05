import 'package:admin/controllers/menu_controller.dart';
import 'package:admin/firebase_api.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/constants/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  Get.put(CustomMenuController());
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SensorySphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: themeColor,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        colorScheme: const ColorScheme.dark(
          onPrimary: lightGrey,
          primary: highlightedColor,
          surface: highlightedColor,
        ),
      ),
      home: kIsWeb ? const LoginPage() : const SafeArea(child: LoginPage()),
    );
  }
}
