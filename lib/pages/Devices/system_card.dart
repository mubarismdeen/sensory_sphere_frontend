import 'package:flutter/material.dart';

import '../../constants/style.dart';
import 'system_inlay.dart';

class SystemCard extends StatelessWidget {
  final String label;
  final Function onLocationButtonPressed;

  SystemCard({
    required this.label,
    required this.onLocationButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Card(
        color: cardColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: highlightedColor,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: lightGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SystemInlay(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
