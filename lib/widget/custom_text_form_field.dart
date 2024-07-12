import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isNumeric;
  final bool allowNegative;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isNumeric = false,
    this.allowNegative = true,
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
        if (isNumeric &&
            !value.isNumericOnly &&
            !allowNegative &&
            !value.isPositiveDouble) {
          return 'Please enter a positive value';
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
    final RegExp regex = RegExp(r'^-?\d+(\.\d+)?$');
    return regex.hasMatch(this);
  }

  bool get isPositiveDouble {
    if (isEmpty) {
      return false;
    }
    final RegExp regex = RegExp(r'^\d+(\.\d+)?$');
    return regex.hasMatch(this);
  }
}
