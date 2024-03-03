import 'package:admin/constants/constants.dart';
import 'package:admin/routes/routes.dart';
import 'package:admin/widget/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/controllers.dart';
import '../constants/style.dart';
import '../globalState.dart';
import '../helpers/responsiveness.dart';
import '../pages/login/login.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
        // color: themeColor,
        decoration: BoxDecoration(
          color: themeColor,
          boxShadow: [
            BoxShadow(
              color: highlightedColor.withOpacity(0.5), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 7, // Blur radius
              // offset: Offset(0, 1), // Offset of the shadow
            ),
          ],
        ),
        child: ListView(children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(
                //   height: 40,
                // ),
                Container(
                  decoration: BoxDecoration(
                    color: highlightedColor.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: _width / 48),
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Hero(
                          tag: 'icon',
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.only(left: 10, top: 5),
                            child: ExcludeSemantics(
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  mainTitleColor, // Desired color
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset('images/app_icon.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Flexible(
                        child: Text(
                          appTitle,
                          style: TextStyle(
                            color: mainTitleColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LobsterFont',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(
            width: _width / 48,
            height: 10,
          ),
          // Divider(
          //   color: lightGrey.withOpacity(.1),
          // ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: GlobalState.sideMenuItems
                .map((itemName) => SideMenuItem(
                      itemName: itemName == AuthenticationPageRoute
                          ? "Log out"
                          : itemName,
                      onTap: () {
                        if (itemName == AuthenticationPageRoute) {
                          Get.off(const LoginPage());
                        }
                        if (!menuController.isActive(itemName)) {
                          menuController.changeActiveItemTo(itemName);
                          if (ResponsiveWidget.isSmallScreen(context)) {
                            Get.back();
                          }
                          navigationController.navigateTo(itemName);
                        }
                      },
                    ))
                .toList(),
          ),
        ]));
  }
}
