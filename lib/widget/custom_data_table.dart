import 'package:admin/constants/style.dart';
import 'package:admin/models/alarm_details.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final TextStyle headerTextStyle;
  final TextStyle rowTextStyle;
  final List<String> columnHeaders;
  final List<AlarmDetails> tableData;
  final BorderRadius borderRadius;
  final Color headingRowColor;
  final Color backGroundColor;
  final double elevation;
  final Color shadowColor;
  final Function? onRowTap;

  CustomDataTable({
    required this.columnHeaders,
    this.headerTextStyle =
        const TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
    this.rowTextStyle = const TextStyle(color: Colors.black),
    this.tableData = const [],
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.headingRowColor = appBarColor,
    this.backGroundColor = cardColor,
    this.elevation = 4.0, // Default elevation
    this.shadowColor = highlightedColor,
    this.onRowTap, // Default shadow color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(), // You can customize border properties if needed
              ),
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => headingRowColor),
                dataRowColor: MaterialStateColor.resolveWith(
                    (states) => lightGrey.withOpacity(0.5)),
                columns: columnHeaders.map((header) {
                  return DataColumn(
                    label: Text(header, style: headerTextStyle),
                  );
                }).toList(),
                rows: tableData.map((tableRow) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(tableRow.property, style: rowTextStyle),
                      ),
                      DataCell(
                        Text(tableRow.parameter, style: rowTextStyle),
                      ),
                      DataCell(
                        Text(tableRow.condition, style: rowTextStyle),
                      ),
                      DataCell(
                        Text(tableRow.value.toString(), style: rowTextStyle),
                      ),
                      DataCell(
                        Text(tableRow.status, style: rowTextStyle),
                      ),
                    ],
                    onSelectChanged: (selected) {
                      if (selected != null) {
                        print('Selected row: $tableRow');
                        onRowTap!(tableRow);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
