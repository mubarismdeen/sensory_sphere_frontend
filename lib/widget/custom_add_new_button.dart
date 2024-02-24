import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomAddNewButton extends StatelessWidget {
  final void Function() openUploadDialog;
  const CustomAddNewButton({Key? key, required this.openUploadDialog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: openUploadDialog,
      child: Row(
        children: const [
          Icon(Icons.add, size: 16, weight: 900),
          SizedBox(
            width: 5,
          ),
          CustomText(
              text: "Add New",
              size: 14,
              color: themeColor,
              weight: FontWeight.bold),
        ],
      ),
    );
  }
}