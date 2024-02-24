import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/leaveSalary.dart';
import 'package:admin/models/salaryPaid.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api.dart';

class LeaveSalaryWidget extends StatefulWidget {
  @override
  _LeaveSalaryWidgetState createState() => _LeaveSalaryWidgetState();
}

class _LeaveSalaryWidgetState extends State<LeaveSalaryWidget> {
  List<LeaveSalary> _leaveSalaries = List<LeaveSalary>.empty();
  double _paidAmount = 0;

  SalaryPaid _salaryPaid = SalaryPaid(
      id: 0,
      empCode: '',
      type: 2,
      payable: 0,
      totalPaid: 0,
      due: 0,
      date: '',
      paidBy: 0,
      paid: false,
      paidDt: DateTime.now(),
      editBy: GlobalState.userEmpCode,
      editDt: DateTime.now(),
      creatBy: GlobalState.userEmpCode,
      creatDt: DateTime.now());

  getData() async {
    _leaveSalaries =
        await getLeaveSalary(DateFormat('yyyy').format(DateTime.now()));
  }

  void _showPaymentDialog(LeaveSalary salary) {
    showDialog(
      context: context,
      builder: (context) {
        _paidAmount = salary.pendingAmt;
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment to ${salary.name} (#${salary.empCode})'),
              const SizedBox(
                width: 35,
              ),
              TextButton(
                style: const ButtonStyle(alignment: Alignment.topRight),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  color: themeColor,
                ),
              ),
            ],
          ),
          content: TextFormField(
            initialValue: _paidAmount.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _paidAmount = double.tryParse(value) ?? _paidAmount;
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                    ),
                    onPressed: () {
                      _submitForm(salary);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm(LeaveSalary salary) async {
    _salaryPaid.empCode = salary.empCode;
    _salaryPaid.payable = salary.pendingAmt;
    _salaryPaid.totalPaid = _paidAmount;
    _salaryPaid.due = salary.pendingAmt - _paidAmount;
    _salaryPaid.date = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    _salaryPaid.paidBy = 1;
    // _salaryPaid.paid = salary.pendingAmt == _paidAmount ? 1 : 0;
    _salaryPaid.paid = salary.pendingAmt == _paidAmount ? true : false;
    _salaryPaid.creatBy = GlobalState.userEmpCode;
    _salaryPaid.editBy = GlobalState.userEmpCode;

    bool status = await saveSalaryPaid(_salaryPaid);
    if (status) {
      showSaveSuccessfulMessage(context);
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
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
                                'Employee ID',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Employee Name',
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
                                'Attendance',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Sick Leave',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Payable Amount',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Paid Amount',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Pending Amount',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Payment',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                        ],
                        rows: _leaveSalaries
                            .map((salary) => DataRow(cells: [
                                  DataCell(Text(salary.empCode)),
                                  DataCell(Text(salary.name)),
                                  DataCell(Text(salary.salary.toString())),
                                  DataCell(Text(salary.attendance.toString())),
                                  DataCell(Text(salary.sickLeave.toString())),
                                  DataCell(Text(salary.payAmt.toString())),
                                  DataCell(Text(
                                      (salary.payAmt - salary.pendingAmt)
                                          .toString())),
                                  DataCell(Text(salary.pendingAmt.toString())),
                                  DataCell(
                                    salary.pendingAmt == 0
                                        ? const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                          )
                                        : TextButton(
                                            onPressed: () =>
                                                _showPaymentDialog(salary),
                                            child: const Text('Pay',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent)),
                                          ),
                                  ),
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
