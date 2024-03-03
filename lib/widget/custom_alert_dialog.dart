import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle titleStyle;
  final List<Widget>? dialogActions;

  CustomAlertDialog({
    required this.title,
    required this.child,
    this.dialogActions,
    this.titleStyle = const TextStyle(fontWeight: FontWeight.bold, color: lightGrey),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        titlePadding: EdgeInsets.zero,
        shadowColor: elevatedButtonColor,
        // scrollable: true,
        elevation: 15,
        title: Container(
          decoration: const BoxDecoration(
            color: appBarColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: themeColor, // Color of the shadow
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.clear,
                  color: lightGrey,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(child: child),
        actions: dialogActions,
      ),
    );
  }
}
