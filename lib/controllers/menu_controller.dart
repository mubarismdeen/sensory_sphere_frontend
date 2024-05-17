import 'package:admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';

class CustomMenuController extends GetxController {
  static CustomMenuController instance = Get.find();
  var activeItem = DevicesRoute.obs;
  // var activeItem = GlobalState.sideMenuItems.isNotEmpty ? GlobalState.sideMenuItems.first.obs : DashboardRoute.obs;
  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isActive(String itemName) => activeItem.value == itemName;

  isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case SupportRoute:
        return _customIcon(Icons.support_agent_sharp, itemName);
      case DevicesRoute:
        return _customIcon(Icons.my_location, itemName);
      case DashboardRoute:
        return _customIcon(Icons.dashboard, itemName);
      case MaintenanceRoute:
        return _customIcon(Icons.settings, itemName);
      case AlarmsRoute:
        return _customIcon(Icons.alarm, itemName);
      case PropertiesRoute:
        return _customIcon(Icons.broadcast_on_home, itemName);
      case AnalyticsRoute:
        return _customIcon(Icons.area_chart_outlined, itemName);
      case CompanyRoute:
        return _customIcon(Icons.home_work_outlined, itemName);
      case ClientsRoute:
        return _customIcon(Icons.handshake_outlined, itemName);
      case GratuityRoute:
        return _customIcon(Icons.savings_outlined, itemName);
      case AuthenticationPageRoute:
        return _customIcon(Icons.exit_to_app, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName))
      return Icon(
        icon,
        size: 22,
        color: highlightedColor,
      );

    return Icon(
      icon,
      color: isHovering(itemName) ? highlightedColor : lightGrey,
    );
  }
}
