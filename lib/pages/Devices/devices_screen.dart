import 'package:admin/pages/Devices/system_card.dart';
import 'package:flutter/material.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {

  getTableData() async {}

  closeDialog() {
    setState(() {
      getTableData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getTableData(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          return SingleChildScrollView(
            child: Column(children: [
              // const SizedBox(height: 50),
              SystemCard(
                label: "Al Qudra Lake",
                onLocationButtonPressed: () {},
                suctionPressure: 10,
                dischargePressure: 15,
                oxygenAPressure: 15,
                oxygenBPressure: 13,
                ambientTemperature: 25,
                totalCurrent: 10,
                isRunning: true,
              ),
            ]),
          );
        });
  }

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
