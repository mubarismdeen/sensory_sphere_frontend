import 'package:admin/contollers/menu_controller.dart';
import 'package:admin/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/contollers/navigation_controller.dart';
import 'package:admin/constants/style.dart';

void main() {
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
      home: const LoginPage(),
    );
  }
}
