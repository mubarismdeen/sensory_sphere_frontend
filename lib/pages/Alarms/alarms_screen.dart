import 'package:admin/constants/style.dart';
import 'package:admin/models/alarm_details.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_data_table.dart';
import 'package:flutter/material.dart';

import 'add_alarm_form.dart';

class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({Key? key}) : super(key: key);

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final List<String> columnHeaders = [
    "Property",
    "Parameter",
    "Condition",
    "Value",
    "Status",
  ];

  final List<Map<String, dynamic>> tableData = [
    {
      "Property": "Al Qudra",
      "Parameter": "Ambient Temperature",
      "Condition": "Greater than",
      "Value": 50,
      "Status": "Active",
    },
    {
      "Property": "Union Property 3",
      "Parameter": "Oxygen B Pressure",
      "Condition": "Lesser than",
      "Value": 3,
      "Status": "Active",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 35.0, top: 35.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      appBarColor,
                    ),
                    elevation: MaterialStateProperty.all<double>(4.0),
                    // shadowColor: MaterialStateProperty.all<Color>(shadowColor),
                  ),
                  onPressed: () => _alarmDetailsDialog(null),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add Alarm',
                      style: TextStyle(
                        color: lightGrey,
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
    );
  }

  void _alarmDetailsDialog(Map<String, dynamic>? tableRow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Add new alarm',
          child: AddAlarmForm(
            closeDialog: closeDialog,
            context: context,
            tableRow: tableRow,
          ),
          // child: EmployeeDetailsForm(closeDialog, tableRow, context),
        );
      },
    );
  }

  void closeDialog(AlarmDetails details) {
    setState(() {
      tableData.add({
        "Property": details.property,
        "Parameter": details.parameter,
        "Condition": details.condition,
        "Value": details.value,
        "Status": details.status,
      });
    });
  }
}
