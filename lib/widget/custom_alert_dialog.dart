import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget child;
  TextStyle? titleStyle;
  List<Widget>? dialogActions = [];

  CustomAlertDialog({
    required this.title,
    required this.child,
    this.dialogActions,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: titleStyle,),
            const SizedBox(
              width: 35,
            ),
            TextButton(
              style: const ButtonStyle(alignment: Alignment.topRight),
              onPressed: () {
                navigator?.pop(context);
              },
              child: const Icon(
                Icons.clear,
                color: themeColor,
              ),
            ),
          ],
        ),
        content: child,
        insetPadding: const EdgeInsets.symmetric(horizontal: 100),
        actions: dialogActions,
      ),
    );
  }
}
