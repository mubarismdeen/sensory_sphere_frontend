import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/userDetails.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/models/userScreens.dart';
import 'package:admin/pages/Devices/employee_accesses_dialog.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/employee_details_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../models/employeeDetails.dart';
import '../../utils/common_utils.dart';
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 500,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          );
        });
  }

  void _openUploadDialog(EmployeeDetails? tableRow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Add New Employee',
          child: EmployeeDetailsForm(closeDialog, tableRow, context),
        );
      },
    );
  }

  Widget _uploadButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: elevatedButtonColor,
      ),
      onPressed: () => _openUploadDialog(null),
      child: const Text('Add Employee',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _openPrivilegesDialog(EmployeeDetails employee) async {
    String empCode = employee.empCode;
    var screensData = await getScreensForEmployee(empCode);
    var userData = await getUserDetails(empCode);
    UserScreens empScreens = screensData.isNotEmpty
        ? screensData.first
        : UserScreens(creatBy: GlobalState.userEmpCode);
    UserDetails? userDetails = userData.isNotEmpty ? userData.first : null;
    List<UserPrivileges> privilegesList =
        await getAllPrivilegesForUser(empCode);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EmployeeAccessesDialog(
          userDetails: userDetails,
          userScreens: empScreens,
          userPrivilegesList: privilegesList,
          employeeName: employee.name,
          employeeCode: empCode,
        );
      },
    );
  }
}
