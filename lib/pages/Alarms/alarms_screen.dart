import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/models/alarm_details.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_data_table.dart';
import 'package:admin/widget/loading_wrapper.dart';
import 'package:flutter/material.dart';

import 'add_alarm_form.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  List<AlarmDetails> tableData = [];
  bool _showLoading = true;

  final List<String> columnHeaders = [
    "Property",
    "Parameter",
    "Condition",
    "Value",
    "Status",
  ];

  // final List<Map<String, dynamic>> tableData = [
  //   {
  //     "Property": "Al Qudra",
  //     "Parameter": "Ambient Temperature",
  //     "Condition": "Greater than",
  //     "Value": 50,
  //     "Status": "Active",
  //   },
  //   {
  //     "Property": "Union Property 3",
  //     "Parameter": "Oxygen B Pressure",
  //     "Condition": "Lesser than",
  //     "Value": 3,
  //     "Status": "Active",
  //   }
  // ];
  _initialize() async {
    tableData = await getAlarmDetails();
    setState(() {
      _showLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _showLoading,
      height: 300,
      color: highlightedColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 30.0, top: 20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          // appBarColor,
                          Colors.blue.shade400.withOpacity(0.85)),
                      elevation: MaterialStateProperty.all<double>(4.0),
                      // shadowColor: MaterialStateProperty.all<Color>(shadowColor),
                    ),
                    onPressed: () => _alarmDetailsDialog(null),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add Alarm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomDataTable(
              columnHeaders: columnHeaders,
              tableData: tableData,
              onRowTap: _alarmDetailsDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _alarmDetailsDialog(AlarmDetails? tableRow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Add new alarm',
          child: AddAlarmForm(
            closeDialog: closeDialog,
            // context: context,
            tableRow: tableRow,
          ),
          // child: EmployeeDetailsForm(closeDialog, tableRow, context),
        );
      },
    );
  }

  void closeDialog(AlarmDetails details) {
    setState(() {
      _showLoading = true;
    });
    _initialize();
  }
}
