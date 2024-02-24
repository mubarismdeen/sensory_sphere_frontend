import 'package:admin/globalState.dart';
import 'package:admin/models/empMaster.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api.dart';
import '../models/jobDetails.dart';
import '../utils/common_utils.dart';

class JobDetailsUpload extends StatefulWidget {
  dynamic closeDialog;
  Map<String, dynamic>? tableRow;
  UserPrivileges privileges;

  JobDetailsUpload(this.closeDialog, this.tableRow, this.privileges);

  @override
  State<JobDetailsUpload> createState() => _JobDetailsUploadState();
}

class _JobDetailsUploadState extends State<JobDetailsUpload> {
  final _formKey = GlobalKey<FormState>();

  var _jobName = TextEditingController();
  var _narration = TextEditingController();
  var _assignedDate = TextEditingController();
  var _dueDate = TextEditingController();
  late EmpMaster _selectedAssignedTo;
  late Map<String, dynamic> _selectedJobStatus;
  String? _assignedTo;
  String? _status;

  List<Map<String, dynamic>> jobStatuses = <Map<String, dynamic>>[];
  List<EmpMaster> assignedToOptions = <EmpMaster>[];

  getDropdownInputs() async {
    jobStatuses = await getJobStatuses();
    assignedToOptions = await getEmpDetails();
    if (widget.tableRow != null) {
      setValue();
    }
  }

  setValue() {
    _jobDetails.id = widget.tableRow!['id'];
    _jobName.text = widget.tableRow!['job'].toString();
    _narration.text = widget.tableRow!['narration'].toString();
    _assignedDate.text = widget.tableRow!['assignedDate'].toString();
    _assignedTo = widget.tableRow!['assignedTo'].toString();
    _status = widget.tableRow!['jobStatus'].toString();
    _dueDate.text = widget.tableRow!['dueDate'].toString();

    _selectedAssignedTo = assignedToOptions
        .firstWhere((assignedTo) => assignedTo.name == _assignedTo);
    _selectedJobStatus = jobStatuses
        .firstWhere((jobStatus) => jobStatus['description'] == _status);
  }

  JobDetails _jobDetails = JobDetails(
      id: 0,
      job: "",
      narration: "",
      assignedDate: "",
      jobStatus: 0,
      status: 1,
      assignedTo: "",
      dueDate: "",
      creatBy: GlobalState.userEmpCode,
      creatDt: DateTime.now(),
      editBy: GlobalState.userEmpCode,
      editDt: DateTime.now());

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Submit the form data to a backend API or do something else with it
      print('Submitted form data:');
      print('Client Name: $_jobName');
      print('Name: $_assignedDate');
      print('Narration: $_narration');
      print('PO Status: $_selectedAssignedTo');
      print('Type: $_selectedJobStatus');
      print('Due Date: $_dueDate');
    }
    _jobDetails.job = _jobName.text;
    _jobDetails.narration = _narration.text;
    _jobDetails.assignedTo = _selectedAssignedTo.empCode;
    _jobDetails.assignedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_assignedDate.text));
    _jobDetails.jobStatus = _selectedJobStatus['id'];
    _jobDetails.dueDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_dueDate.text));

    bool status = await saveJobDetails(_jobDetails);
    if (status) {
      showSaveSuccessfulMessage(context);
      _assignedDate.clear();
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onDelete() async {
    bool status = await deleteJobDetails(_jobDetails.id);
    if (status) {
      showSaveSuccessfulMessage(context);
      _assignedDate.clear();
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getDropdownInputs(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          if (_data.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    width: 25, height: 25, child: CircularProgressIndicator()));
          } else if (_data.hasError) {
            return Text('Error: ${_data.error}');
          } else {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Job'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter client name';
                        }
                        return null;
                      },
                      controller: _jobName,
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Narration'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter narration';
                        }
                        return null;
                      },
                      controller: _narration,
                      onSaved: (value) {},
                    ),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select assigned to';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Assigned To'),
                      items: assignedToOptions
                          .map<DropdownMenuItem<String>>((EmpMaster employee) {
                        return DropdownMenuItem<String>(
                          value: employee.name,
                          child: Text(employee.name),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // setState(() {
                        _selectedAssignedTo = assignedToOptions
                            .firstWhere((employee) => employee.name == value);
                        // });
                      },
                      value: _assignedTo,
                    ),
                    TextFormField(
                      controller: _assignedDate,
                      decoration:
                          const InputDecoration(labelText: 'Assigned Date'),
                      onTap: () async {
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          _assignedDate.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select assigned date';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please select job status';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: jobStatuses
                            .map<DropdownMenuItem<String>>((dynamic value) {
                          return DropdownMenuItem<String>(
                            value: value['description'].toString(),
                            child: Text(value['description']),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // setState(() {
                          _selectedJobStatus = jobStatuses.firstWhere(
                              (jobStatus) => jobStatus['description'] == value);
                          // });
                        },
                        value: _status),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select Due Date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ...getActionButtonsWithPrivilege(
                            context: context,
                            privileges: widget.privileges,
                            hasData: widget.tableRow != null,
                            onSubmit: _onSubmit,
                            onDelete: _onDelete),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
