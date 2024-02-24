import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api.dart';
import '../models/salaryPaid.dart';
import '../models/salaryPay.dart';

class EmployeeSalary extends StatefulWidget {
  @override
  _EmployeeSalaryState createState() => _EmployeeSalaryState();
}

class _EmployeeSalaryState extends State<EmployeeSalary> {
  List<SalaryPay> _salaryPay = List<SalaryPay>.empty();
  double _paidAmount = 0;
  SalaryPaid _salaryPaid = SalaryPaid(
      id: 0,
      empCode: '',
      type: 1,
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
    _salaryPay =
        await getSalaryPay(DateFormat('yyyy-MM').format(DateTime.now()));
  }

  Future<void> _submitForm(SalaryPay salary) async {
    _salaryPaid.empCode = salary.empCode;
    _salaryPaid.payable = salary.due;
    _salaryPaid.totalPaid = _paidAmount;
    _salaryPaid.due = salary.due - _paidAmount;
    _salaryPaid.date = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    _salaryPaid.paidBy = 1;
    _salaryPaid.paid = salary.due == _paidAmount ? true : false;
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

  void _showPaymentDialog(SalaryPay salary) {
    showDialog(
      context: context,
      builder: (context) {
        _paidAmount = salary.due;
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
                                'Basic',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Working\nDays',
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
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Payable\nAmount',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Paid\nAmount',
                                style: tableHeaderStyle,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Pending\nAmount',
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
                        rows: _salaryPay
                            .map((salary) => DataRow(cells: [
                                  DataCell(Text(salary.empCode)),
                                  DataCell(Text(salary.name)),
                                  DataCell(Text(salary.basic.toString())),
                                  DataCell(Text(salary.attendance.toString())),
                                  DataCell(Text(salary.nOtr.toString())),
                                  DataCell(Text(salary.sOtr.toString())),
                                  DataCell(Text(salary.overseas.toString())),
                                  DataCell(Text(salary.anchorage.toString())),
                                  DataCell(Text(salary.total.toString())),
                                  DataCell(Text(
                                      (salary.total - salary.due).toString())),
                                  DataCell(Text(salary.due.toString())),
                                  DataCell(
                                    salary.due == 0
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
