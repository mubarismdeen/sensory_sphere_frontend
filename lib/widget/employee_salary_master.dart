import 'package:admin/constants/style.dart';
import 'package:admin/models/salaryMasterGet.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api.dart';

class EmployeeSalaryMaster extends StatefulWidget {
  @override
  _EmployeeSalaryMasterState createState() => _EmployeeSalaryMasterState();
}

class _EmployeeSalaryMasterState extends State<EmployeeSalaryMaster> {
  List<SalaryMasterGet> _salaryPay = List<SalaryMasterGet>.empty();

  getData() async {
    _salaryPay =
        await getSalaryMaster(DateFormat('yyyy-MM').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getData(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
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
                                'Salary',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Normal\nOvertime',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Special\nOvertime',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'overseas',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'anchorage',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                        ],
                        rows: _salaryPay
                            .map((salary) => DataRow(cells: [
                                  DataCell(Text(salary.empCode.toString())),
                                  DataCell(Text(salary.name)),
                                  DataCell(Text(salary.salary.toString())),
                                  DataCell(Text(salary.nOtr.toString())),
                                  DataCell(Text(salary.sOtr.toString())),
                                  DataCell(Text(salary.overseas.toString())),
                                  DataCell(Text(salary.anchorage.toString())),
                                ]))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
