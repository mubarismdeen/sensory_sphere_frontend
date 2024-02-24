import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/userDetails.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/models/userScreens.dart';
import 'package:admin/pages/Employees/employee_accesses_dialog.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/employee_details_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../models/employeeDetails.dart';
import '../../utils/common_utils.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late List<EmployeeDetails> _employeeDetails;

  @override
  void initState() {
    super.initState();
    _employeeDetails = [];
  }

  getTableData() async {
    _employeeDetails = await getEmployeeDetails();
  }

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
              Obx(() => Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: ResponsiveWidget.isSmallScreen(context)
                                ? 56
                                : 6,
                            left: 10),
                        child: CustomText(
                          text: menuController.activeItem.value,
                          size: 24,
                          weight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 35.0, top: 35.0),
                    child: _uploadButton(),
                  ),
                ],
              ),
              // EmployeeDetailsWidget(_employeeDetails),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 600),
                child: getCustomCard(
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
                          child: _getDataTable(),
                        ),
                      ),
                    ],
                  ),
                ),
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
        backgroundColor: themeColor,
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

  //   CustomAlertDialog(
  //     // [
  //     //   TextButton(
  //     //     onPressed: () {
  //     //       // Implement submission logic here
  //     //       Navigator.pop(context);
  //     //     },
  //     //     child: const Text("Submit"),
  //     //   ),
  //     // ],
  // );

  Widget _getDataTable() {
    return DataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text('Employee\nID', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Employee\nName', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Mobile 1', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Mobile 2', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Nationality', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Department', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Status', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('DOB', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Joined\nDate', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Created\nBy', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Created\nDate', style: tableHeaderStyle),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Settings', style: tableHeaderStyle),
          ),
        ),
      ],
      rows: _employeeDetails
          .map((employee) => DataRow(
                cells: [
                  DataCell(Text(employee.empCode)),
                  DataCell(Text(employee.name)),
                  DataCell(Text(employee.mobile1)),
                  DataCell(Text(employee.mobile2)),
                  DataCell(Text(employee.nationality)),
                  DataCell(Text(employee.department)),
                  DataCell(Text(employee.status)),
                  DataCell(Text(getDateStringFromDateTime(employee.birthDt))),
                  DataCell(Text(getDateStringFromDateTime(employee.joinDt))),
                  DataCell(Text(employee.createBy)),
                  DataCell(Text(getDateStringFromDateTime(employee.createDt))),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.settings_outlined,
                          color: Colors.blueAccent),
                      onPressed: () => _openPrivilegesDialog(employee),
                    ),
                  ),
                ],
                onSelectChanged: (selected) {
                  if (selected != null && selected) {
                    _openUploadDialog(employee);
                  }
                },
              ))
          .toList(),
    );
  }
}
