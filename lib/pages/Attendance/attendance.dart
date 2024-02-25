import 'package:admin/constants/constants.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/attendanceModel.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/attendance_excel_upload.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/month_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../api.dart';
import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../models/attedanceDto.dart';
import '../../models/empMaster.dart';
import '../../widget/custom_elevated_button.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DateTime _pickedDate = DateTime.now();
  List<AttendanceDto> attendances = List<AttendanceDto>.empty();
  List<AttendanceModel> _attendanceList = List<AttendanceModel>.empty();
  bool _editable = false;
  bool _enterAttendance = false;
  // bool _enableUpload = false;
  void onDateChange(DateTime newDate) {
    setState(() {
      _pickedDate = newDate;
    });
  }

  closeDialog() {
    setState(() {
      getAttendanceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(),
      // Column(children: [
      //   Obx(() => Row(
      //         children: [
      //           Container(
      //             margin: EdgeInsets.only(
      //                 top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6,
      //                 left: 10),
      //             child: CustomText(
      //               text: menuController.activeItem.value,
      //               size: 24,
      //               weight: FontWeight.bold,
      //               color: Colors.black,
      //             ),
      //           )
      //         ],
      //       )),
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Container(
      //         margin: const EdgeInsets.only(left: 25.0, top: 35.0),
      //         child: MonthPicker(_pickedDate, onDateChange),
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           // Container(
      //           //   margin: const EdgeInsets.only(right: 35.0, top: 35.0),
      //           //   child: _viewButton(),
      //           // ),
      //           Container(
      //             margin: const EdgeInsets.only(right: 35.0, top: 35.0),
      //             child: _uploadButton(),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   const SizedBox(height: 20),
      //   // EmployeeAttendance(pickedDate),
      //   FutureBuilder<dynamic>(
      //       future: getAttendanceData(),
      //       builder: (context, AsyncSnapshot<dynamic> _data) {
      //         return attendances.isEmpty && !_enterAttendance
      //             ? _attendanceNotFoundContainer()
      //             : _attendanceTable();
      //       }),
      // ]),
    );
  }

  getAttendanceData() async {
    attendances =
        await getAttendanceDetails(DateFormat('yyyy-MM').format(_pickedDate));
    _attendanceList = attendances
        .map((att) => AttendanceModel(
            id: att.id,
            empCode: att.employeeId,
            attendance: att.totalAttendance,
            offdays: att.totalOffAndSickDays,
            lop: att.totalOffAndSickDays,
            novt: att.totalNormalOvertimeHours,
            sovt: att.totalSpecialOvertimeHours,
            overseas: att.totalSpecialOvertimeHours,
            anchorage: att.totalAnchorageDays,
            date: DateFormat('yyyy-MM').format(_pickedDate),
            editBy: GlobalState.userEmpCode,
            editDt: DateTime.now(),
            creatBy: GlobalState.userEmpCode,
            creatDt: DateTime.now()))
        .toList();
  }

  getData() async {
    var empList = await getEmpDetails();
    for (int i = 0; i < empList.length; i++) {
      EmpMaster emp = empList[i];
      if (i == 0) {
        attendances = [
          AttendanceDto(
              id: 0,
              employeeId: emp.empCode,
              employeeName: emp.name,
              totalAttendance: 0.0,
              totalOffAndSickDays: 0.0,
              totalLossOfPaymentDays: 0.0,
              totalNormalOvertimeHours: 0.0,
              totalSpecialOvertimeHours: 0.0,
              totalOverseasDays: 0.0,
              totalAnchorageDays: 0.0,
              molId: ''),
        ];
        _attendanceList = [
          AttendanceModel(
              id: 0,
              empCode: emp.empCode,
              attendance: 0,
              offdays: 0,
              lop: 0,
              novt: 0,
              sovt: 0,
              overseas: 0,
              anchorage: 0,
              date: DateFormat('yyyy-MM').format(_pickedDate),
              editBy: GlobalState.userEmpCode,
              editDt: DateTime.now(),
              creatBy: GlobalState.userEmpCode,
              creatDt: DateTime.now())
        ];
      } else {
        attendances.add(AttendanceDto(
            id: 0,
            employeeId: emp.empCode,
            employeeName: emp.name,
            totalAttendance: 0.0,
            totalOffAndSickDays: 0.0,
            totalLossOfPaymentDays: 0.0,
            totalNormalOvertimeHours: 0.0,
            totalSpecialOvertimeHours: 0.0,
            totalOverseasDays: 0.0,
            totalAnchorageDays: 0.0,
            molId: ''));
        _attendanceList.add(AttendanceModel(
            id: 0,
            empCode: emp.empCode,
            attendance: 0,
            offdays: 0,
            lop: 0,
            novt: 0,
            sovt: 0,
            overseas: 0,
            anchorage: 0,
            date: DateFormat('yyyy-MM').format(_pickedDate),
            editBy: GlobalState.userEmpCode,
            editDt: DateTime.now(),
            creatBy: GlobalState.userEmpCode,
            creatDt: DateTime.now()));
      }
    }
  }

  Widget _attendanceNotFoundContainer() {
    return SizedBox(
      height: 450,
      child: getCustomCard(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Attendance data not found for this month'),
            const SizedBox(height: 20),
            _enterAttendanceButton(),
          ],
        ),
      ),
    );
  }

  Widget _attendanceTable() {
    return FutureBuilder<dynamic>(
      future: attendances.isEmpty ? getData() : getAttendanceData(),
      builder: (context, AsyncSnapshot<dynamic> _data) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 500, maxWidth: 1280),
          child:
              getCustomCard(_editable ? _getDataTable() : _getViewDataTable()),
        );
      },
    );
  }

  void listUpdate(rowIndex, val, column) {
    // int rowIndex = processTail.indexWhere((element) => element.srl == int.parse(_srlId));

    int rowLength = _attendanceList.length;

    if (rowLength > rowIndex) {
      switch (column) {
        case 'empId':
          _attendanceList[rowIndex].empCode = val;
          break;
        case 'ancDays':
          _attendanceList[rowIndex].anchorage = val;
          break;
        case 'sOvt':
          _attendanceList[rowIndex].sovt = val;
          break;
        case 'nOvt':
          _attendanceList[rowIndex].novt = val;
          break;
        case 'ovrDays':
          _attendanceList[rowIndex].overseas = val;
          break;
        case 'att':
          _attendanceList[rowIndex].attendance = val;
          break;
        case 'lop':
          _attendanceList[rowIndex].lop = val;
          break;
        case 'off':
          _attendanceList[rowIndex].offdays = val;
          break;
      }
    } else {
      _attendanceList.add(AttendanceModel(
          id: 0,
          empCode: '',
          attendance: 0,
          offdays: 0,
          lop: 0,
          novt: 0,
          sovt: 0,
          overseas: 0,
          anchorage: 0,
          date: DateFormat('yyyy-MM').format(DateTime.now()).toString(),
          editBy: GlobalState.userEmpCode,
          editDt: DateTime.now(),
          creatBy: GlobalState.userEmpCode,
          creatDt: DateTime.now()));
    }
  }

  DataCell _getCustomDataCell({required double field, index, column}) {
    return DataCell(ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 77),
      child: TextFormField(
        initialValue: field == 0 ? "" : field.toString(),
        enabled: _editable,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          field = double.parse(value);
          listUpdate(index, field, column);
        },
      ),
    ));
  }

  Column _getDataTable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 500,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Employee\nID',
                      style: tableHeaderStyle,
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Employee\nName',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Total\nAttendance',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Off Days and\nSick Leave',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Loss of\nPayment Days',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Normal\nOvertime Hours',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Special\nOvertime Hours',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Overseas\nDays',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Anchorage\nDays',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                ],
                rows: attendances
                    .map((att) => DataRow(cells: [
                          DataCell(
                              Center(child: Text(att.employeeId.toString()))),
                          DataCell(Center(child: Text(att.employeeName))),
                          // DataCell(Text(attendance.molId)),
                          _getCustomDataCell(
                              field: att.totalAttendance,
                              index: attendances.indexOf(att),
                              column: 'att'),
                          _getCustomDataCell(
                              field: att.totalOffAndSickDays,
                              index: attendances.indexOf(att),
                              column: 'off'),
                          _getCustomDataCell(
                              field: att.totalLossOfPaymentDays,
                              index: attendances.indexOf(att),
                              column: 'lop'),
                          _getCustomDataCell(
                              field: att.totalNormalOvertimeHours,
                              index: attendances.indexOf(att),
                              column: 'nOvt'),
                          _getCustomDataCell(
                              field: att.totalSpecialOvertimeHours,
                              index: attendances.indexOf(att),
                              column: 'sOvt'),
                          _getCustomDataCell(
                              field: att.totalOverseasDays,
                              index: attendances.indexOf(att),
                              column: 'ovrDays'),
                          _getCustomDataCell(
                              field: att.totalAnchorageDays,
                              index: attendances.indexOf(att),
                              column: 'ancDays'),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        _editable ? _saveButton() : _editButton(),
      ],
    );
  }

  Column _getViewDataTable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 500,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Employee\nID',
                      style: tableHeaderStyle,
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Employee\nName',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Total\nAttendance',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Off Days and\nSick Leave',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Loss of\nPayment Days',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Normal\nOvertime Hours',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Special\nOvertime Hours',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Overseas\nDays',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Anchorage\nDays',
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                ],
                rows: attendances
                    .map((att) => DataRow(cells: [
                          DataCell(
                              Center(child: Text(att.employeeId.toString()))),
                          DataCell(Center(child: Text(att.employeeName))),
                          DataCell(Center(
                              child: Text(att.totalAttendance.toString()))),
                          DataCell(Center(
                              child: Text(att.totalOffAndSickDays.toString()))),
                          DataCell(Center(
                              child:
                                  Text(att.totalLossOfPaymentDays.toString()))),
                          DataCell(Center(
                              child: Text(
                                  att.totalNormalOvertimeHours.toString()))),
                          DataCell(Center(
                              child: Text(
                                  att.totalSpecialOvertimeHours.toString()))),
                          DataCell(Center(
                              child: Text(att.totalOverseasDays.toString()))),
                          DataCell(Center(
                              child: Text(att.totalAnchorageDays.toString()))),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        _editable ? _saveButton() : _editButton(),
      ],
    );
  }

  Widget _saveButton() {
    return CustomElevatedButton(
      handleOnPress: () async {
        String responseString = await saveAttendance(_attendanceList);
        if (responseString.toLowerCase() == successfulResponse) {
          showSaveSuccessfulMessage(context);
        } else {
          showSaveFailedMessage(context, responseString);
        }
        setState(() {
          _editable = false;
        });
      },
      buttonText: 'Save',
    );
  }

  Widget _editButton() {
    return CustomElevatedButton(
      handleOnPress: () => {
        setState(
          () {
            _editable = true;
          },
        ),
      },
      buttonText: 'Edit',
    );
  }

  Widget _enterAttendanceButton() {
    return CustomElevatedButton(
      handleOnPress: () => {
        setState(
          () {
            _enterAttendance = true;
            _editable = true;
          },
        ),
      },
      buttonText: 'Enter Attendance',
    );
  }

  void _openUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Upload Attendance Details',
          child: AttendanceExcelUpload(closeDialog, _pickedDate),
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
      onPressed: _openUploadDialog,
      child: const Text('Upload Attendance',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
