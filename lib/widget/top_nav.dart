import 'package:admin/constants/constants.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/helpers/responsiveness.dart';
import 'package:admin/widget/settings_popup.dart';
import 'package:flutter/material.dart';

import '../globalState.dart';
import 'custom_alert_dialog.dart';
import 'custom_text.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      backgroundColor: appBarColor,
      shadowColor: dark,
      elevation: 6,
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Hero(
              tag: 'icon',
              child: Container(
                height: 35,
                padding: const EdgeInsets.only(left: 10, top: 5),
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
            )
          : IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                key.currentState?.openDrawer();
              }),
      title: Wrap(children: [
        Row(
          children: [
            if (!ResponsiveWidget.isSmallScreen(context))
              const Visibility(
                child: Text(
                  appTitle,
                  style: TextStyle(
                      color: mainTitleColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LobsterFont'),
                ),
              ),
            Expanded(child: Container()),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: lightGrey.withOpacity(.7),
              ),
              onPressed: () {
                _openSettings(context);
              },
            ),
            Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: lightGrey.withOpacity(.7),
                    ),
                    onPressed: () {}),
                Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      width: 8,
                      height: 12,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: active,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: themeColor, width: 2)),
                    ))
              ],
            ),
            Container(
              width: 1,
              height: 22,
              color: lightGrey,
            ),
            const SizedBox(
              width: 5,
            ),
            CustomText(
                text: GlobalState.username,
                size: 16,
                color: lightGrey,
                weight: FontWeight.bold),
            const SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  color: lightGrey, borderRadius: BorderRadius.circular(30)),
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  backgroundColor: themeColor,
                  child: Icon(
                    Icons.person_outline,
                    color: lightGrey,
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
      iconTheme: const IconThemeData(color: lightGrey),
    );

void _openSettings(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: 'Settings',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        child: const SettingsPopup(),
      );
    },
  );
}
