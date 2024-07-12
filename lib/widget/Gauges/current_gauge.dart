import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../utils/common_utils.dart';

class CurrentGauge extends StatelessWidget {
  final double value; // Current value of the ammeter
  final double maximumValue; // Maximum value of the ammeter

  CurrentGauge({required this.value, required this.maximumValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 180,
      height: 180,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            minimum: min(0, roundDownToNearestInteger(value)),
            maximum: maximumValue,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.1,
              color: Colors.black,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              NeedlePointer(
                enableAnimation: true,
                animationType: AnimationType.ease,
                animationDuration: 1000,
                value: value,
                needleColor: Colors.orange,
                needleLength: 0.8,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 1,
                needleEndWidth: 6,
                knobStyle: const KnobStyle(
                  knobRadius: 0.1,
                  color: Colors.orange,
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                verticalAlignment: GaugeAlignment.near,
                widget: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        '$value A',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ),
                    const Text(
                      "Total Current",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
