import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController instance = Get.find();
  final GlobalKey<NavigatorState> navigationkey = GlobalKey();

  Future<dynamic>? navigateTo(String routeName) {
    return navigationkey.currentState?.pushNamed(routeName);
  }

  Future<dynamic>? navigateWithArgumentsTo(String routeName, dynamic args) {
    return navigationkey.currentState?.pushNamed(routeName, arguments: args);
  }

  goBack() => navigationkey.currentState?.pop();
}
