import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isNumeric;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isNumeric = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: highlightedColor),
      ),
      style: const TextStyle(color: lightGrey),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        }
        if (isNumeric && !value.isNumericOnly && !value.isDoubleOnly) {
          return 'Please enter a numeric value';
        }
        return null;
      },
      controller: controller,
    );
  }
}

extension StringExtension on String {
  bool get isDoubleOnly {
    if (isEmpty) {
      return false;
    }
    final RegExp regex = RegExp(r'^\d+(\.\d+)?$');
    return regex.hasMatch(this);
  }
}
