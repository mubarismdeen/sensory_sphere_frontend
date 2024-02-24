import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class AttendanceHistory {
  String employeeName;
  String date;
  String attendanceStatus;

  AttendanceHistory(
      {required this.employeeName,
      required this.date,
      required this.attendanceStatus});
}

class AttendanceHistoryScreen extends StatefulWidget {
  @override
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  List<AttendanceHistory> _attendanceHistoryList = [];

  Future<void> _getAttendanceHistory(DateTime selectedDate) async {
    // Code to retrieve attendance history from database or API for the selected date
    // and populate _attendanceHistoryList
    _attendanceHistoryList = [
      AttendanceHistory(
          employeeName: 'John',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Shijith',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Raju',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Raju',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Raju',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Raju',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Raju',
          date: '2023-04-04',
          attendanceStatus: 'Present'),
      AttendanceHistory(
          employeeName: 'Rajesh Kumar',
          date: '2023-04-04',
          attendanceStatus: 'Absent'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          if (!_attendanceHistoryList.isNotEmpty)
            Column(
            children: [
              const Text('Select a date:'),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: themeColor,
                ),
                child: const Text('Pick a date'),
                onPressed: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2050),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _attendanceHistoryList.clear();
                    });
                    await _getAttendanceHistory(selectedDate);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
          if (_attendanceHistoryList.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxHeight: 250, minHeight: 5),
              // height: 250,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Employee Name',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Date',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Attendance Status',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                  ],
                  rows: _attendanceHistoryList
                      .map((attendanceHistory) => DataRow(cells: [
                            DataCell(Text(attendanceHistory.employeeName)),
                            DataCell(Text(attendanceHistory.date)),
                            DataCell(Text(attendanceHistory
                                .attendanceStatus)), // DataCell(Text(attendance.attendanceStatus)),
                          ]))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
