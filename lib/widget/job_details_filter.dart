import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api.dart';
import '../models/empMaster.dart';

class JobDetailsFilter extends StatefulWidget {
  dynamic applyFilter;
  JobDetailsFilter(this.applyFilter, {Key? key}) : super(key: key);

  @override
  State<JobDetailsFilter> createState() => _JobDetailsFilterState();
}

class _JobDetailsFilterState extends State<JobDetailsFilter> {
  final _formKey = GlobalKey<FormState>();

  var _dueDate = TextEditingController();

  String _selectedJobStatus = '';
  String _selectedAssignedTo = '';
  String _selectedDueDate = '';

  List<Map<String, dynamic>> jobStatuses = <Map<String, dynamic>>[];
  List<EmpMaster> assignedToOptions = <EmpMaster>[];

  getDropdownInputs() async {
    jobStatuses = await getJobStatuses();
    assignedToOptions = await getEmpDetails();
  }

  Future<void> _applyForm() async {
    _selectedDueDate = _dueDate.text;
    widget.applyFilter(_selectedJobStatus, _selectedAssignedTo, _selectedDueDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getDropdownInputs(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                      decoration: const InputDecoration(labelText: 'Job Status'),
                      items: jobStatuses.map<DropdownMenuItem<String>>(
                              (dynamic jobStatus) {
                            return DropdownMenuItem<String>(
                              value: jobStatus['description'].toString(),
                              child: Text(jobStatus['description']),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedJobStatus = jobStatuses.firstWhere(
                                  (jobStatus) => jobStatus['description'] == value)['id'].toString();
                        });
                      }),
                  DropdownButtonFormField(
                      decoration:
                      const InputDecoration(labelText: 'Assigned To'),
                      items: assignedToOptions
                          .map<DropdownMenuItem<String>>((EmpMaster emp) {
                        return DropdownMenuItem<String>(
                          value: emp.name,
                          child: Text(emp.name),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedAssignedTo = assignedToOptions.firstWhere(
                                  (emp) => emp.name == value).id.toString();
                        });
                      }),
                  TextFormField(
                    controller: _dueDate,
                    decoration: const InputDecoration(labelText: 'Due Date'),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        _dueDate.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                        ),
                        onPressed: _applyForm,
                        child: const Text('Apply'),
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
                ],
              ),
            ),
          );
        });
  }
}
