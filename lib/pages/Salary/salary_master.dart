import 'package:admin/constants/style.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:admin/widget/employee_salary_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../api.dart';
import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../models/salaryMasterGet.dart';
import '../../utils/common_utils.dart';

class SalaryMaster extends StatefulWidget {
  const SalaryMaster({Key? key}) : super(key: key);

  @override
  State<SalaryMaster> createState() => _SalaryMasterState();
}

class _SalaryMasterState extends State<SalaryMaster> {
  List<SalaryMasterGet> _salaryPay = List<SalaryMasterGet>.empty();

  getTableData() async {
    _salaryPay =
        await getSalaryMaster(DateFormat('yyyy-MM').format(DateTime.now()));
  }

  closeDialog() {
    setState(() {
      getTableData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(),
      // Column(children: [
      //   Obx(() => Row(
      //         children: [
      //           Container(
      //             margin: EdgeInsets.only(
      //                 top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6,
      //                 left: 10),
      //             child: CustomText(
      //               text: menuController.activeItem.value,
      //               size: 24,
      //               weight: FontWeight.bold,
      //               color: Colors.black,
      //             ),
      //           )
      //         ],
      //       )),
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Container(
      //         margin: const EdgeInsets.only(right: 35.0, top: 35.0),
      //         child: _uploadButton(),
      //       ),
      //     ],
      //   ),
      //   // EmployeeSalaryMaster(),
      //   FutureBuilder<dynamic>(
      //       future: getTableData(),
      //       builder: (context, AsyncSnapshot<dynamic> _data) {
      //         return ConstrainedBox(
      //           constraints: const BoxConstraints(minHeight: 600),
      //           child: getCustomCard(
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 SingleChildScrollView(
      //                   scrollDirection: Axis.horizontal,
      //                   child: SingleChildScrollView(
      //                     child: DataTable(
      //                       showCheckboxColumn: false,
      //                       columns: const <DataColumn>[
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'Employee\nID',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'Employee\nName',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'Salary',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'Normal\nOvertime',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'Special\nOvertime',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'overseas',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                         DataColumn(
      //                           label: Expanded(
      //                             child: Text(
      //                               'anchorage',
      //                               style: tableHeaderStyle,
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                       rows: _salaryPay
      //                           .map((salary) => DataRow(cells: [
      //                                 DataCell(Text(salary.empCode)),
      //                                 DataCell(Text(salary.name)),
      //                                 DataCell(Text(salary.salary.toString())),
      //                                 DataCell(Text(salary.nOtr.toString())),
      //                                 DataCell(Text(salary.sOtr.toString())),
      //                                 DataCell(
      //                                     Text(salary.overseas.toString())),
      //                                 DataCell(
      //                                     Text(salary.anchorage.toString())),
      //                               ], onSelectChanged: (selected) {
      //                         if (selected != null && selected) {
      //                           _openDialog(salary);
      //                         }
      //                       }))
      //                           .toList(),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       }),
      // ]),
    );
  }

  void _openDialog(SalaryMasterGet? tableRow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Upload Salary Details',
          child: EmployeeSalaryForm(closeDialog, tableRow),
        );
      },
    );
  }

  Widget _uploadButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: themeColor,
      ),
      onPressed: () => _openDialog(null),
      child: const Text('Upload Salary',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
