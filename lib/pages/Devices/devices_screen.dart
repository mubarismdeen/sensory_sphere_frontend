import 'package:flutter/material.dart';

import 'devices_card.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   _employeeDetails = [];
  // }

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
              const SizedBox(height: 50),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Container(
              //       margin: const EdgeInsets.only(right: 35.0, top: 35.0),
              //       child: _uploadButton(),
              //     ),
              //   ],
              // ),
              // EmployeeDetailsWidget(_employeeDetails),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: [
                    DevicesCard(
                        label: "Al Qudra Lake",
                        currentAmperes: 10,
                        pressurePsi: 15,
                        temperatureCelsius: 30,
                        onLocationButtonPressed: () {}),
                    DevicesCard(
                        label: "Union Property 1",
                        currentAmperes: 5,
                        pressurePsi: 8,
                        temperatureCelsius: 40,
                        onLocationButtonPressed: () {}),
                    DevicesCard(
                        label: "Union Property 2",
                        currentAmperes: 15,
                        pressurePsi: 18,
                        temperatureCelsius: 42,
                        onLocationButtonPressed: () {}),
                    DevicesCard(
                        label: "Union Property 3",
                        currentAmperes: 9,
                        pressurePsi: 20,
                        temperatureCelsius: 35,
                        onLocationButtonPressed: () {}),
                  ],
                ),
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
