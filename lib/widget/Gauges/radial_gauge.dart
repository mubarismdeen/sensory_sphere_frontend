import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGauge extends StatelessWidget {
  final double value;
  final Color valueColor;
  final String title;
  final Color titleColor;
  final double width;

  const RadialGauge(
      {required this.value,
      required this.title,
      required this.width,
      required this.valueColor,
      required this.titleColor,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            interval: 20,
            minimum: 0,
            maximum: 150,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
              GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
              GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
            ],
            pointers: <GaugePointer>[NeedlePointer(value: value)],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  verticalAlignment: GaugeAlignment.near,
                  widget: Column(
                    children: [
                      Text(
                        "$value BAR",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: valueColor,
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
