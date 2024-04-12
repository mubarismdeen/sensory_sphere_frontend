import 'dart:async';

import 'package:admin/pages/Devices/system_card.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';

import '../../api.dart';
import '../../models/sensor_data.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late SensorData _sensorData;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sensorData = SensorData(
      id: 0,
      timestamp: DateTime.now(),
      suctionPressure: 0.0,
      dischargePressure: 0.0,
      oxygenAPressure: 0.0,
      oxygenBPressure: 0.0,
      ambientTemperature: 0.0,
      totalCurrent: 0.0,
    );
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getTableData(context);
    });
    getTableData(context); // Fetch data once when the screen is initialized
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  Future<void> getTableData(BuildContext context) async {
    try {
      List<SensorData> data = await getLastSensorData();
      if (data.isNotEmpty) {
        setState(() {
          _sensorData = data.first;
        });
      } else {
        throw Error();
      }
    } catch (error) {
      showSaveFailedMessage(context, "Unable to fetch data");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SystemCard(
            label: "Al Qudra Lake",
            onLocationButtonPressed: () {},
            suctionPressure: _sensorData.suctionPressure,
            dischargePressure: _sensorData.dischargePressure,
            oxygenAPressure: _sensorData.oxygenAPressure,
            oxygenBPressure: _sensorData.oxygenBPressure,
            ambientTemperature: _sensorData.ambientTemperature,
            totalCurrent: _sensorData.totalCurrent,
            isRunning: true,
          ),
        ],
      ),
    );
  }

  // closeDialog() {
  //   setState(() {
  //     getTableData();
  //   });
  // }

  // void _openUploadDialog(EmployeeDetails? tableRow) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomAlertDialog(
  //         title: 'Add New Employee',
  //         child: EmployeeDetailsForm(closeDialog, tableRow, context),
  //       );
  //     },
  //   );
  // }

  // Widget _uploadButton() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       padding: const EdgeInsets.all(16.0),
  //       backgroundColor: elevatedButtonColor,
  //     ),
  //     onPressed: () => _openUploadDialog(null),
  //     child: const Text('Add Employee',
  //         style: TextStyle(fontWeight: FontWeight.bold)),
  //   );
  // }

  // void _openPrivilegesDialog(EmployeeDetails employee) async {
  //   String empCode = employee.empCode;
  //   var screensData = await getScreensForEmployee(empCode);
  //   var userData = await getUserDetails(empCode);
  //   UserScreens empScreens = screensData.isNotEmpty
  //       ? screensData.first
  //       : UserScreens(creatBy: GlobalState.userEmpCode);
  //   UserDetails? userDetails = userData.isNotEmpty ? userData.first : null;
  //   List<UserPrivileges> privilegesList =
  //       await getAllPrivilegesForUser(empCode);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return EmployeeAccessesDialog(
  //         userDetails: userDetails,
  //         userScreens: empScreens,
  //         userPrivilegesList: privilegesList,
  //         employeeName: employee.name,
  //         employeeCode: empCode,
  //       );
  //     },
  //   );
  // }
}
