import 'package:admin/pages/Devices/system_card.dart';
import 'package:flutter/material.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SystemCard(
            label: "Al Qudra Lake",
            onLocationButtonPressed: () {},
          ),
        ],
      ),
    );
  }
}
