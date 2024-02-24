import 'package:admin/constants/style.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/widget/quotations_filter.dart';
import 'package:admin/widget/quotations_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api.dart';
import 'custom_alert_dialog.dart';

class QuotationsExpandedWithFilter extends StatefulWidget {
  UserPrivileges privileges;

  QuotationsExpandedWithFilter(this.privileges);

  @override
  State<QuotationsExpandedWithFilter> createState() =>
      _QuotationsExpandedWithFilterState();
}

class _QuotationsExpandedWithFilterState
    extends State<QuotationsExpandedWithFilter> {
  List<Map<String, dynamic>> tableData = <Map<String, String>>[];

  String _selectedClientName = '';
  String _selectedName = '';
  String _selectedPoStatus = '';
  String _selectedInvoiceStatus = '';
  String _selectedType = '';

  getTableData() async {
    tableData = await getQuotationDetails(_selectedClientName, _selectedName,
        _selectedPoStatus, _selectedInvoiceStatus, _selectedType);
  }

  applyFilter(String clientName, String name, String poStatus,
      String invoiceStatus, String type) {
    setState(() {
      _selectedClientName = clientName;
      _selectedName = name;
      _selectedPoStatus = poStatus;
      _selectedInvoiceStatus = invoiceStatus;
      _selectedType = type;
      getTableData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getTableData(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Quotation Details'),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: _openFilterDialog,
                        icon: const Icon(
                          Icons.filter_alt_sharp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.topRight),
                    onPressed: () {
                      navigator?.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                height: 500,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Client Name',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Vessel',
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
                              'Type',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Report No',
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
                              'PO Status',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'PO No',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'PO Ref No',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Invoice Status',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Invoice No',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Invoice Amount',
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
                      rows: tableData
                          .map(
                            (tableRow) => DataRow(
                              cells: [
                                DataCell(
                                  Text(tableRow['clientName'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['name'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['narration'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['type'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['reportNo'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['date'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['poStatus'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['poNo'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['poRefNo'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['invStatus'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['invoiceNo'].toString()),
                                ),
                                DataCell(
                                  Text(tableRow['invoiceAmt'].toString()),
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
                              ],
                              onSelectChanged: (selected) {
                                if (selected != null &&
                                    selected &&
                                    (widget.privileges.editPrivilege ||
                                        widget.privileges.deletePrivilege)) {
                                  _openUploadDialog(tableRow);
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 100),
            ),
          );
        });
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(content: QuotationsFilter(applyFilter));
      },
    );
  }

  void _openUploadDialog(tableRow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Upload Quotation Details',
          child: QuotationsUpload(closeDialog, tableRow, widget.privileges),
        );
      },
    );
  }

  closeDialog() {
    setState(() {
      getTableData();
    });
  }
}
