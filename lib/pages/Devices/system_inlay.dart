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

class _SystemInlayState extends State<SystemInlay> with TickerProviderStateMixin {
  bool _isRunning = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200), // Shorter duration for faster vibration
    );
    _animation = Tween(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Using elasticOut curve for a vibration effect
      ),
    )..addListener(() {
      setState(() {}); // Redraw widget when animation updates
    });
    if (_isRunning) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 600,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getAmbientTemperatureWidget(),
                    Container(
                      margin:  const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: themeColor.withOpacity(0.3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CurrentGauge(
                            value: widget.totalCurrent,
                            maximumValue: 90,
                          ),
                        ],
                      ),
                    ),
                    OxygenPressureWidget(
                      pressureA: widget.oxygenAPressure,
                      pressureB: widget.oxygenBPressure,
                      colorA: Colors.green.shade300,
                      colorB: Colors.green.shade600,
                      height: 150,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  width: 530,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(color: appBarColor.withOpacity(0.3),borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      _getMotorWidget(),
                      _getMotorPressures(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              child: Transform.translate(
                offset: _isRunning ? Offset(_animation.value, 0.0) : const Offset(0.0, 0.0),
                child: Image.asset('images/motor_icon.png', width: 200),
              ),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RadialGauge(
          title: "Discharge",
          titleColor: Colors.black,
          value: widget.dischargePressure,
          valueColor: Colors.yellow,
          size: 160,
        ),
        RadialGauge(
          title: "Suction",
          titleColor: Colors.black,
          value: widget.suctionPressure,
          valueColor: Colors.lightBlue,
          size: 160,
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
        height: 150,
        title: "Ambient Temperature",
        titleColor: Colors.black,
      ),
    );
  }

}
