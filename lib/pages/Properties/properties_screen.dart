import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_data_table.dart';
import 'package:admin/widget/loading_wrapper.dart';
import 'package:flutter/material.dart';

import '../../models/property_details.dart';
import 'add_property_form.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  List<PropertyDetails> tableData = [];
  bool _showLoading = true;

  final List<String> columnHeaders = [
    "Id",
    "Name",
    "Status",
    "Created By",
    "Created Date",
    "Edit By",
    "Edit Date",
  ];

  _initialize() async {
    tableData = await getPropertyDetails();
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
                          Colors.blue.shade400.withOpacity(0.85)),
                      elevation: MaterialStateProperty.all<double>(4.0),
                    ),
                    onPressed: () => _propertyDetailsDialog(null),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add Property',
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
              tableRows: tableData.map((tableRow) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(tableRow.id.toString(), style: rowTextStyle),
                    ),
                    DataCell(
                      Text(tableRow.name, style: rowTextStyle),
                    ),
                    DataCell(
                      Text(tableRow.status, style: rowTextStyle),
                    ),
                    DataCell(
                      Text(tableRow.createBy, style: rowTextStyle),
                    ),
                    DataCell(
                      Text(getDateTimeString(tableRow.createDate),
                          style: rowTextStyle),
                    ),
                    DataCell(
                      Text(tableRow.editBy, style: rowTextStyle),
                    ),
                    DataCell(
                      Text(getDateTimeString(tableRow.editDate),
                          style: rowTextStyle),
                    ),
                  ],
                  onSelectChanged: (selected) {
                    if (selected != null) {
                      print('Selected row: $tableRow');
                      _propertyDetailsDialog(tableRow);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _propertyDetailsDialog(PropertyDetails? tableRow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: tableRow != null ? 'Property Details' : 'Add Property',
          child: AddPropertyForm(
            closeDialog: closeDialog,
            // context: context,
            tableRow: tableRow,
          ),
          // child: EmployeeDetailsForm(closeDialog, tableRow, context),
        );
      },
    );
  }

  void closeDialog(PropertyDetails details) {
    setState(() {
      _showLoading = true;
    });
    _initialize();
  }
}
