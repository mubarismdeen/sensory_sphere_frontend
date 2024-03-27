import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class OxygenPressureWidget extends StatelessWidget {
  final double pressureA;
  final double pressureB;
  final double width;

  const OxygenPressureWidget(
      {required this.pressureA, required this.pressureB, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.greenAccent.withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("A: $pressureA BAR", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10),
                  Text("B: $pressureB BAR", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(
              width: width,
              child: SfLinearGauge(
                axisTrackStyle: const LinearAxisTrackStyle(color: Colors.black, thickness: 2),
                orientation: LinearGaugeOrientation.horizontal,
                minimum: 0,
                maximum: max(pressureB, pressureA) + 10,
                markerPointers: [
                  LinearWidgetPointer(
                    offset: 8,
                    position: LinearElementPosition.outside,
                      value: pressureB,
                      child: Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.red),
                        child: const Center(child: Text("B", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                      ),),
                  LinearWidgetPointer(
                      offset: -2,
                      position: LinearElementPosition.outside,
                      value: pressureA,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Colors.blue),
                        child: const Center(child: Text("A", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                      ),),
                  // LinearShapePointer(value: pointerValue, position: LinearElementPosition.cross, color: light,),
                ],
                // ranges: [LinearGaugeRange(startValue: -100, endValue: 0, color: Colors.blue,)],
                barPointers: [
                  LinearBarPointer(
                    position: LinearElementPosition.outside,
                    value: pressureA,
                    color: Colors.blue,
                    thickness: 10,
                  ),
                  LinearBarPointer(
                    offset: 10,
                    position: LinearElementPosition.outside,
                    value: pressureB,
                    color: Colors.red,
                    thickness: 10,
                  )
                ],
              ),
            ),
            const Text(
              "Oxygen Pressure",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
