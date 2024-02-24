import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final Function handleOnPress;
  final String buttonText;

  const CustomElevatedButton({Key? key, required this.handleOnPress, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: themeColor,
        ),
        onPressed: () => handleOnPress(),
        child: Text(buttonText),
      ),
    );
  }
}
