import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class LinearGauge extends StatelessWidget {
  final double pointerValue;
  final double height;
  final String title;
  final Color titleColor;
  const LinearGauge({required this.pointerValue, required this.height, required this.title, required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          SizedBox(
            height: height,
            child: SfLinearGauge(
              orientation: LinearGaugeOrientation.vertical,
              minimum: pointerValue - 20,
              maximum: pointerValue + 20,
              markerPointers: [
                LinearWidgetPointer(value: pointerValue, child: Container(height: 12, width: 12, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.red),)),
                // LinearShapePointer(value: pointerValue, position: LinearElementPosition.cross, color: light,),
              ],
              // ranges: [LinearGaugeRange(startValue: -100, endValue: 0, color: Colors.blue,)],
              barPointers: [LinearBarPointer(value: pointerValue, color: Colors.red,)],
            ),
          ),

        ],
      ),
    );
  }
}
