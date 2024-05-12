import 'package:flutter/material.dart';

import 'system_inlay.dart';

class SystemCard extends StatelessWidget {
  final String propertyName;
  final Function onLocationButtonPressed;

  SystemCard({
    required this.propertyName,
    required this.onLocationButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SystemInlay(propertyName: propertyName),
          ],
        ),
      ),
    );
  }
}
