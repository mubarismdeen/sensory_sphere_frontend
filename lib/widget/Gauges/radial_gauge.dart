import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGauge extends StatelessWidget {
  final double value;
  final Color valueColor;
  final String title;
  final Color titleColor;
  final double size;

  const RadialGauge({
    required this.value,
    required this.title,
    required this.size,
    required this.valueColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: math.max(3.5, value + 0.5),
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 1.5, color: Colors.green),
              GaugeRange(startValue: 1.5, endValue: 3, color: Colors.orange),
              GaugeRange(startValue: 3, endValue: 1000, color: Colors.red)
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: value,
                enableAnimation: true,
                animationType: AnimationType.ease,
                animationDuration: 1000,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                verticalAlignment: GaugeAlignment.near,
                widget: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        "$value BAR",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: valueColor,
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
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
