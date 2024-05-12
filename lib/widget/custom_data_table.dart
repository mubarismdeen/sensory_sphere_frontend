import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final TextStyle headerTextStyle;
  final List<String> columnHeaders;
  final BorderRadius borderRadius;
  final Color headingRowColor;
  final double elevation;
  final Color shadowColor;
  final List<DataRow> tableRows;

  CustomDataTable({
    required this.columnHeaders,
    required this.tableRows,
    this.headerTextStyle =
        const TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.headingRowColor = appBarColor,
    this.elevation = 4.0, // Default elevation
    this.shadowColor = highlightedColor,
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
                rows: tableRows,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
