import 'package:admin/constants/style.dart';
import 'package:admin/widget/Gauges/linear_gauge.dart';
import 'package:admin/widget/Gauges/radial_gauge.dart';
import 'package:flutter/material.dart';

import '../../widget/Gauges/current_gauge.dart';
import '../../widget/Gauges/oxygen_pressure_widget.dart';

class SystemInlay extends StatefulWidget {
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;

  SystemInlay({
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
  });

  @override
  State<SystemInlay> createState() => _SystemInlayState();
}

class _SystemInlayState extends State<SystemInlay> {
  bool _isRunning = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(26),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getAmbientTemperatureWidget(),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: appBarColor.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      _getMotorWidget(),
                      _getMotorPressures(),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: themeColor.withOpacity(0.3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CurrentGauge(
                      value: widget.totalCurrent,
                      maximumValue: 90,
                    ),
                    OxygenPressureWidget(
                      pressureA: widget.oxygenAPressure,
                      pressureB: widget.oxygenBPressure,
                      width: 200,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getButton() {
    return !_isRunning
        ? ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isRunning = true;
              });
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[500]?.withOpacity(0.85),
              foregroundColor: light,
            ),
          )
        : ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isRunning = false;
              });
            },
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400]?.withOpacity(0.85),
              foregroundColor: light,
            ),
          );
  }

  Widget _getMotorWidget() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            top: 1,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _isRunning ? Colors.green : Colors.red, // Desired color
                BlendMode.srcIn,
              ),
              child: Image.asset('images/motor_icon.png', width: 200),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Center(child: _getButton()),
                )),
          ),
        ],
      ),
    );
  }

  Widget _getMotorPressures() {
    return Row(
      children: [
        RadialGauge(
          title: "Discharge",
          titleColor: Colors.yellow,
          value: widget.dischargePressure,
          valueColor: Colors.yellow,
          width: 180,
        ),
        RadialGauge(
          title: "Suction",
          titleColor: Colors.lightBlue,
          value: widget.suctionPressure,
          valueColor: Colors.lightBlue,
          width: 180,
        ),
      ],
    );
  }

  Widget _getAmbientTemperatureWidget() {
    return Container(
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10)),
      child: LinearGauge(
        pointerValue: widget.ambientTemperature,
        height: 200,
        title: "Ambient Temperature (°C)",
        titleColor: Colors.black,
      ),
    );
  }

}
