import 'package:admin/constants/style.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/job_details_expanded_with_filter.dart';
import 'package:admin/widget/job_details_upload.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import 'package:intl/intl.dart';

import 'custom_add_new_button.dart';
import 'custom_view_details_button.dart';

class JobDetailsWidget extends StatefulWidget {
  UserPrivileges privileges;

  JobDetailsWidget(this.privileges, {Key? key}) : super(key: key);

  @override
  _JobDetailsWidgetState createState() => _JobDetailsWidgetState();
}

class _JobDetailsWidgetState extends State<JobDetailsWidget> {
  List<Map<String, dynamic>> tableData = <Map<String, String>>[];

  getData() async {
    tableData = await getJobDetails('', '', '');
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
                      text: "Job Details",
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
                                    Text(tableRow['job']),
                                  ),
                                  DataCell(
                                    Text(tableRow['narration']),
                                  ),
                                  DataCell(
                                    Text(tableRow['assignedTo']),
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
        return JobDetailsExpandedWithFilter(closeDialog, widget.privileges);
      },
    );
  }

  void _openUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Upload Job Details',
          child: JobDetailsUpload(closeDialog, null, widget.privileges),
        );
      },
    );
  }
}
