import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class JobDetailsExpanded extends StatefulWidget {
  JobDetailsExpanded({required this.tableData});
  List<Map<String, dynamic>> tableData ;
  @override
  _JobDetailsExpandedState createState() => _JobDetailsExpandedState();
}

class _JobDetailsExpandedState extends State<JobDetailsExpanded> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Job',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Narration',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Assigned To',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Assigned Date',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Status',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Due Date',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Created By',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Create Date',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Edit By',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Edit Date',
                    style: tableHeaderStyle,
                  ),
                ),
              ),
            ],
            rows: widget.tableData
                .map(
                  (tableRow) => DataRow(cells: [
                DataCell(
                  Text(tableRow['job'].toString()),
                ),
                DataCell(
                  Text(tableRow['narration'].toString()),
                ),
                DataCell(
                  Text(tableRow['assignedTo'].toString()),
                ),
                DataCell(
                  Text(tableRow['assignedDate'].toString()),
                ),
                DataCell(
                  Text(tableRow['jobStatus'].toString()),
                ),
                DataCell(
                  Text(tableRow['dueDate'].toString()),
                ),
                DataCell(
                  Text(tableRow['creatBy'].toString()),
                ),
                DataCell(
                  Text(tableRow['creatDt'].toString()),
                ),
                DataCell(
                  Text(tableRow['editBy'].toString()),
                ),
                DataCell(
                  Text(tableRow['editDt'].toString()),
                ),
              ]),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}
