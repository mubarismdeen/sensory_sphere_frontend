import 'package:admin/constants/style.dart';
import 'package:admin/models/employeeDetails.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsWidget extends StatefulWidget {
  List<EmployeeDetails> employeeDetails;
  EmployeeDetailsWidget(this.employeeDetails);

  @override
  _EmployeeDetailsWidgetState createState() => _EmployeeDetailsWidgetState();
}

class _EmployeeDetailsWidgetState extends State<EmployeeDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 600),
      child: getCustomCard(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Employee\nID',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Employee\nName',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Mobile 1',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Mobile 2',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Nationality',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Department',
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
                          'DOB',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Joined\nDate',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Created\nBy',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Created\nDate',
                          style: tableHeaderStyle,
                        ),
                      ),
                    ),
                  ],
                  rows: widget.employeeDetails
                      .map((employee) => DataRow(cells: [
                            DataCell(Text(employee.empCode.toString())),
                            DataCell(Text(employee.name)),
                            DataCell(Text(employee.mobile1)),
                            DataCell(Text(employee.mobile2)),
                            DataCell(Text(employee.nationality)),
                            DataCell(Text(employee.department)),
                            DataCell(Text(employee.status)),
                            DataCell(Text(
                                getDateStringFromDateTime(employee.birthDt))),
                            DataCell(Text(
                                getDateStringFromDateTime(employee.joinDt))),
                            DataCell(Text(employee.createBy)),
                            DataCell(Text(getDateStringFromDateTime(
                                employee.createDt))),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
