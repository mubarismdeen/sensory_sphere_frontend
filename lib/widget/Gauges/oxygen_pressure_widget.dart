import 'dart:math';

import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class OxygenPressureWidget extends StatelessWidget {
  final double pressureA;
  final double pressureB;
  final double height;
  final Color colorA;
  final Color colorB;

  const OxygenPressureWidget(
      {required this.pressureA,
      required this.pressureB,
      required this.height,
      required this.colorA,
      required this.colorB});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeColor.withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "A: $pressureA BAR",
                        style: TextStyle(
                            color: colorA, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "B: $pressureB BAR",
                        style: TextStyle(
                            color: colorB, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height,
                  child: SfLinearGauge(
                    axisTrackStyle: const LinearAxisTrackStyle(
                        color: Colors.black, thickness: 2),
                    orientation: LinearGaugeOrientation.vertical,
                    minimum: 0,
                    maximum: max(pressureB, pressureA) + 0.5,
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
                              color: colorB),
                          child: const Center(
                              child: Text("B",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      LinearWidgetPointer(
                        offset: -2,
                        position: LinearElementPosition.outside,
                        value: pressureA,
                        child: Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: colorA),
                          child: const Center(
                              child: Text("A",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      // LinearShapePointer(value: pointerValue, position: LinearElementPosition.cross, color: light,),
                    ],
                    // ranges: [LinearGaugeRange(startValue: -100, endValue: 0, color: colorA,)],
                    barPointers: [
                      LinearBarPointer(
                        position: LinearElementPosition.outside,
                        value: pressureA,
                        color: colorA,
                        thickness: 10,
                      ),
                      LinearBarPointer(
                        offset: 10,
                        position: LinearElementPosition.outside,
                        value: pressureB,
                        color: colorB,
                        thickness: 10,
                      )
                    ],
                  ),
                ),
              ],
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
