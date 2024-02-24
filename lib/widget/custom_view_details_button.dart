import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class CustomViewDetailsButton extends StatelessWidget {
  final void Function() openViewDialog;
  const CustomViewDetailsButton({Key? key, required this.openViewDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
      ),
      onPressed: openViewDialog,
      child: const Text('View Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: themeColor)),
    );
  }
}
