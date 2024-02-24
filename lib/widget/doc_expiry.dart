import 'package:admin/constants/style.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/doc_details_upload.dart';
import 'package:admin/widget/doc_expiry_expanded.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import 'package:intl/intl.dart';
import '../models/userPrivileges.dart';
import 'custom_add_new_button.dart';
import 'custom_view_details_button.dart';

class DocExpiry extends StatefulWidget {
  UserPrivileges privileges;

  DocExpiry(this.privileges, {Key? key}) : super(key: key);

  @override
  _DocExpiryState createState() => _DocExpiryState();
}

class _DocExpiryState extends State<DocExpiry> {
  List<Map<String, dynamic>> tableData = <Map<String, String>>[];

  getData() async {
    tableData = await getDocDetails();
  }

  closeDialog() {
    setState(() {
      getData();
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
                      text: "Document Details",
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
                              'Name',
                              style: tableHeaderStyle,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Doc Type',
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
                      ],
                      rows: tableData
                          .map(
                            (tableRow) => DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => _getRowColor(
                                        DateTime.parse(tableRow['dueDate']))),
                                cells: [
                                  DataCell(
                                    Text(tableRow['narration']),
                                  ),
                                  DataCell(
                                    Text(tableRow['docType']),
                                  ),
                                  DataCell(
                                    Text(DateFormat("yyyy-MM-dd")
                                        .format(
                                            DateTime.parse(tableRow['dueDate']))
                                        .toString()),
                                  ),
                                ]),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Center(
                  child:
                      CustomViewDetailsButton(openViewDialog: _openViewDialog),
                ),
              ],
            ),
          );
        });
  }

  Color _getRowColor(DateTime docDate) {
    DateTime today = DateTime.now();
    int differenceInDays = docDate.difference(today).inDays;
    Color rowColor = Colors.transparent;
    if (differenceInDays < 0) {
      rowColor = Colors.red.shade300;
    } else if (differenceInDays < 10) {
      rowColor = Colors.orange.shade200;
    }
    return rowColor;
  }

  void _openViewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Document Details',
          child: DocExpiryExpanded(widget.privileges),
        );
      },
    );
  }

  void _openUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Upload Document Details',
          child: DocDetailsUpload(closeDialog, null, widget.privileges),
        );
      },
    );
  }
}
