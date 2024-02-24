import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/quotations_expanded_with_filter.dart';
import 'package:admin/widget/quotations_upload.dart';
import 'package:flutter/material.dart';
import 'custom_add_new_button.dart';
import 'custom_view_details_button.dart';

class QuotationsPending extends StatefulWidget {
  UserPrivileges privileges;
  QuotationsPending(this.privileges, {Key? key})
      : super(key: key);

  @override
  _QuotationsPendingState createState() => _QuotationsPendingState();
}

class _QuotationsPendingState extends State<QuotationsPending> {
  List<Map<String, dynamic>> tableData = <Map<String, String>>[];

  String _selectedClientName = '';
  String _selectedName = '';
  String _selectedPoStatus = '';
  String _selectedInvoiceStatus = '';
  String _selectedType = '';

  getData() async {
    tableData = await getQuotationDetails(_selectedClientName, _selectedName,
        _selectedPoStatus, _selectedInvoiceStatus, _selectedType);
  }

  closeDialog() {
    setState(() {
      getData();
    });
  }

  applyFilter(String clientName, String name, String poStatus,
      String invoiceStatus, String type) {
    setState(() {
      _selectedClientName = clientName;
      _selectedName = name;
      _selectedPoStatus = poStatus;
      _selectedInvoiceStatus = invoiceStatus;
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getData(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          return getCustomCard(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Quotation Details",
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.bold,
                    ),
                    if (widget.privileges.addPrivilege)
                      CustomAddNewButton(openUploadDialog: _openUploadDialog),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
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
                              'PO Status',
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
                      ],
                      rows: tableData
                          .map(
                            (tableRow) => DataRow(cells: [
                              DataCell(
                                Text(tableRow['clientName'].toString()),
                              ),
                              DataCell(
                                Text(tableRow['name'].toString()),
                              ),
                              DataCell(
                                Text(tableRow['poStatus'].toString()),
                              ),
                              DataCell(
                                Text(tableRow['invStatus'].toString()),
                              ),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Center(
                  child: CustomViewDetailsButton(openViewDialog: _openDialog),
                ),
              ],
            ),
          );
        });
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuotationsExpandedWithFilter(widget.privileges);
      },
    );
  }

  void _openUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Upload Quotation Details',
          child: QuotationsUpload(closeDialog, null, widget.privileges),
        );
      },
    );
  }
}
