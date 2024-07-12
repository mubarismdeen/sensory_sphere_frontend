import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../utils/common_utils.dart';

class LinearGauge extends StatelessWidget {
  final double pointerValue;
  final double height;
  final String title;
  final Color titleColor;
  const LinearGauge(
      {required this.pointerValue,
      required this.height,
      required this.title,
      required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: height,
                padding: const EdgeInsets.fromLTRB(20, 5, 25, 5),
                child: SfLinearGauge(
                  isMirrored: true,
                  axisTrackStyle: const LinearAxisTrackStyle(
                      color: Colors.black, thickness: 2),
                  orientation: LinearGaugeOrientation.vertical,
                  minimum: roundDownToNearestInteger(pointerValue - 20),
                  maximum: roundUpToNearestInteger(pointerValue + 20),
                  markerPointers: [
                    LinearWidgetPointer(
                        value: pointerValue,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red),
                        )),
                  ],
                  barPointers: [
                    LinearBarPointer(
                      value: pointerValue,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              Text(
                "$pointerValue °C",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          )
        ],
      ),
    );
  }
}
