import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CurrentGauge extends StatelessWidget {
  final double value; // Current value of the ammeter
  final double maximumValue; // Maximum value of the ammeter

  CurrentGauge({required this.value, required this.maximumValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        alignment: Alignment.centerLeft,
        width: 200,
        height: 200,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              canScaleToFit: true,
              minimum: 0,
              maximum: maximumValue,
              radiusFactor: 0.8,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.1,
                color: Colors.black,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: value,
                  needleColor: Colors.red,
                  needleLength: 0.8,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleStartWidth: 1,
                  needleEndWidth: 6,
                  knobStyle: const KnobStyle(
                    knobRadius: 0.1,
                    color: Colors.red,
                  ),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  verticalAlignment: GaugeAlignment.near,
                  widget: Column(
                    children: [
                      Text(
                        '$value A',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
