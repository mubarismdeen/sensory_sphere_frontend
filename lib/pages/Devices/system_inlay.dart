import 'dart:async';
import 'dart:math';

import 'package:admin/api.dart';
import 'package:admin/constants/controllers.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/models/response_dto.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/Gauges/linear_gauge.dart';
import 'package:admin/widget/Gauges/radial_gauge.dart';
import 'package:flutter/material.dart';

import '../../models/sensor_data.dart';
import '../../routes/routes.dart';
import '../../widget/Gauges/current_gauge.dart';
import '../../widget/Gauges/oxygen_pressure_widget.dart';
import '../../widget/loading_wrapper.dart';

class SystemInlay extends StatefulWidget {
  final String propertyName;
  SystemInlay({
    required this.propertyName,
  });

  @override
  State<SystemInlay> createState() => _SystemInlayState();
}

class _SystemInlayState extends State<SystemInlay>
    with TickerProviderStateMixin {
  bool _isRunning = true;
  bool _isButtonLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late SensorData _sensorData;
  late Timer _timer;
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    _showLoading = true;
    _sensorData = SensorData(
      id: 0,
      propertyId: 0,
      timestamp: DateTime.now(),
      suctionPressure: 0.0,
      dischargePressure: 0.0,
      oxygenAPressure: 0.0,
      oxygenBPressure: 0.0,
      ambientTemperature: 0.0,
      totalCurrent: 0.0,
      isMotorOn: false,
      isMotorLoading: false,
      isAutoMode: false,
      floatState: false,
      smokeState: false,
      longitude: '',
      latitude: '',
    );
    getSensorData();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (menuController.activeItem.value == DevicesRoute) {
        getSensorData();
      } else {
        _timer.cancel();
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 100), // Shorter duration for faster vibration
    );
    _animation = Tween(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            Curves.elasticOut, // Using elasticOut curve for a vibration effect
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
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> getSensorData() async {
    try {
      List<SensorData> data = await getLastSensorData(widget.propertyName);
      if (data.isNotEmpty) {
        setState(() {
          _sensorData = data.first;
          _isRunning = _sensorData.isMotorOn;
          _showLoading = false;
          _isButtonLoading = _sensorData.isMotorLoading;
        });
      } else {
        setState(() {
          _showLoading = true;
        });
        showSaveFailedMessage(context, "No data available for this property");
      }
    } catch (error) {
      showSaveFailedMessage(context, "Unable to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _showLoading,
      height: 500,
      color: highlightedColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
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
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: themeColor.withOpacity(0.3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CurrentGauge(
                                value: _sensorData.totalCurrent,
                                maximumValue:
                                    max(10, _sensorData.totalCurrent + 2),
                              ),
                            ],
                          ),
                        ),
                        OxygenPressureWidget(
                          pressureA: _sensorData.oxygenAPressure,
                          pressureB: _sensorData.oxygenBPressure,
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
                      decoration: BoxDecoration(
                          color: appBarColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              _getModeIndicator(),
                              _getMotorWidget(),
                            ],
                          ),
                          _getMotorPressures(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMotorButton() {
    return LoadingWrapper(
      height: 30,
      isLoading: _isButtonLoading,
      child: ElevatedButton.icon(
        onPressed: () {
          _triggerMotor();
        },
        icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
        label: Text(_isRunning ? 'Stop' : 'Start'),
        style: _isRunning
            ? ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400]?.withOpacity(0.85),
                foregroundColor: light,
              )
            : ElevatedButton.styleFrom(
                backgroundColor: Colors.green[500]?.withOpacity(0.85),
                foregroundColor: light,
              ),
      ),
    );
  }

  Future<void> _triggerMotor() async {
    try {
      ResponseDto response =
          await triggerMotor(_isRunning ? "OFF" : "ON", _sensorData.propertyId);
      if (response.success) {
        showSaveSuccessfulMessage(context, response.message);
        setState(() {
          _isButtonLoading = true;
        });
      } else {
        showSaveFailedMessage(context, response.message);
      }
    } catch (e) {
      print('Error: $e');
      showSaveFailedMessage(context, "Operation Failed !");
    }
  }

  Widget _getModeIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: _sensorData.isAutoMode
            ? Colors.greenAccent.withOpacity(0.6)
            : Colors.orangeAccent.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _sensorData.isAutoMode ? Icons.autorenew : Icons.handyman,
            color: Colors.white,
          ),
          const SizedBox(width: 5.0),
          Text(
            _sensorData.isAutoMode ? 'AUTO' : 'MANUAL',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMotorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 1,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _isRunning
                      ? Colors.green
                      : Colors.red.withOpacity(0.7), // Desired color
                  BlendMode.srcIn,
                ),
                child: Transform.translate(
                  offset: _isRunning
                      ? Offset(_animation.value, 0.0)
                      : const Offset(0.0, 0.0),
                  child: Image.asset('images/motor_icon.png', width: 200),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Center(child: _getMotorButton()),
                  )),
            ),
          ],
        ),
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
          value: _sensorData.dischargePressure,
          valueColor: Colors.yellow,
          size: 160,
        ),
        RadialGauge(
          title: "Suction",
          titleColor: Colors.black,
          value: _sensorData.suctionPressure,
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
        pointerValue: _sensorData.ambientTemperature,
        height: 150,
        title: "Ambient Temperature",
        titleColor: Colors.black,
      ),
    );
  }
}
