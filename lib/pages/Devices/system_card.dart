import 'package:flutter/material.dart';

import '../../constants/style.dart';
import 'system_inlay.dart';

class SystemCard extends StatefulWidget {
  final String label;
  final Function onLocationButtonPressed;
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;
  final bool isRunning;

  SystemCard({
    required this.label,
    required this.onLocationButtonPressed,
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
    required this.isRunning,
  });

  @override
  _SystemCardState createState() => _SystemCardState();
}

class _SystemCardState extends State<SystemCard> {

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
                      widget.label,
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
              SystemInlay(
                  suctionPressure: widget.suctionPressure,
                  dischargePressure: widget.dischargePressure,
                  oxygenAPressure: widget.oxygenAPressure,
                  oxygenBPressure: widget.oxygenBPressure,
                  ambientTemperature: widget.ambientTemperature,
                  totalCurrent: widget.totalCurrent),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
