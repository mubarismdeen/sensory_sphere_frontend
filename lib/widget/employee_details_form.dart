import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/empMaster.dart';
import 'package:admin/models/employeeDetails.dart';
import 'package:admin/models/saveEmployeeDetails.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api.dart';
import 'custom_alert_dialog.dart';

class EmployeeDetailsForm extends StatefulWidget {
  dynamic closeDialog;
  EmployeeDetails? tableRow;
  BuildContext context;
  EmployeeDetailsForm(this.closeDialog, this.tableRow, this.context, {Key? key})
      : super(key: key);

  @override
  State<EmployeeDetailsForm> createState() => _EmployeeDetailsFormState();
}

class _EmployeeDetailsFormState extends State<EmployeeDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final _empCode = TextEditingController();
  final _name = TextEditingController();
  final _mobile1 = TextEditingController();
  final _mobile2 = TextEditingController();
  final _dob = TextEditingController();
  final _resignDate = TextEditingController();
  final _joiningDate = TextEditingController();
  late Map<String, dynamic> _selectedDepartment;
  late Map<String, dynamic> _selectedNationality;
  late Map<String, dynamic> _selectedStatus;
  String? _department;
  String? _nationality;
  String? _status;

  List<Map<String, dynamic>> departments = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> nationalities = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> statuses = <Map<String, dynamic>>[];
  List<EmpMaster> assignedToOptions = <EmpMaster>[];

  getDropdownInputs() async {
    departments = await getDepartments();
    nationalities = await getEmployeeNationalities();
    statuses = await getEmployeeStatuses();
    assignedToOptions = await getEmpDetails();
    if (widget.tableRow != null) {
      setValue();
    }
  }

  setValue() {
    _employeeDetails.id = widget.tableRow!.id;
    _empCode.text = widget.tableRow!.empCode;
    _name.text = widget.tableRow!.name;
    _mobile1.text = widget.tableRow!.mobile1;
    _mobile2.text = widget.tableRow!.mobile2;
    _dob.text = DateFormat('yyyy-MM-dd').format(widget.tableRow!.birthDt);
    _joiningDate.text =
        DateFormat('yyyy-MM-dd').format(widget.tableRow!.joinDt);
    _department = widget.tableRow!.department;
    _nationality = widget.tableRow!.nationality;
    _status = widget.tableRow!.status;

    _selectedDepartment = departments
        .firstWhere((department) => department['description'] == _department);
    _selectedNationality = nationalities.firstWhere(
        (nationality) => nationality['description'] == _nationality);
    _selectedStatus =
        statuses.firstWhere((status) => status['description'] == _status);
  }

  final SaveEmployeeDetails _employeeDetails = SaveEmployeeDetails(
      id: 0,
      empCode: '',
      name: '',
      mobile1: '',
      mobile2: '',
      depId: 0,
      statusId: 0,
      natianalityId: 0,
      joinDt: DateTime.now(),
      resignDt: null,
      birthDt: DateTime.now(),
      editBy: GlobalState.userEmpCode,
      editDate: DateTime.now(),
      creatBy: GlobalState.userEmpCode,
      creatDate: DateTime.now());

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Submit the form data to a backend API or do something else with it
      print('Submitted form data:');
      print('Employee Code: $_empCode');
      print('Employee Name: $_name');
      print('Mobile 1: $_mobile1');
      print('Mobile 2: $_mobile2');
      print('Department ID: $_selectedDepartment');
      print('Status ID: $_selectedStatus');
      print('Nationality ID: $_selectedNationality');
      print('Date of Birth: $_dob');
      print('Date of Joining: $_joiningDate');
    }
    _employeeDetails.empCode = _empCode.text;
    _employeeDetails.name = _name.text;
    _employeeDetails.mobile1 = _mobile1.text;
    _employeeDetails.mobile2 = _mobile2.text;
    _employeeDetails.depId = _selectedDepartment['id'];
    _employeeDetails.statusId = _selectedStatus['id'];
    _employeeDetails.natianalityId = _selectedNationality['id'];
    _employeeDetails.joinDt = DateTime.parse(_joiningDate.text);
    _employeeDetails.birthDt = DateTime.parse(_dob.text);

    bool status = await saveEmployeeDetails(_employeeDetails);
    if (status) {
      showSaveSuccessfulMessage(context);
      _dob.clear();
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onDelete() async {
    bool status = await deleteEmployeeDetails(_employeeDetails.id);
    if (status) {
      showSaveSuccessfulMessage(context);
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  void _resignPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: 'Resign Date',
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: _resignDate,
                decoration: const InputDecoration(labelText: ''),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    _resignDate.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                  onPressed: () {
                    _employeeDetails.resignDt =
                        DateTime.parse(_resignDate.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                  onPressed: () {
                    _employeeDetails.resignDt = null;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ])
            ]));
      },
    );
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
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Employee Code'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter employee code';
                      }
                      return null;
                    },
                    controller: _empCode,
                    onSaved: (value) {},
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Employee Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter employee name';
                      }
                      return null;
                    },
                    controller: _name,
                    onSaved: (value) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mobile 1'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Mobile 1';
                      }
                      return null;
                    },
                    controller: _mobile1,
                    onSaved: (value) {},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mobile 2'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Mobile 2';
                      }
                      return null;
                    },
                    controller: _mobile2,
                    onSaved: (value) {},
                  ),
                  DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select department';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Department'),
                      items: departments.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> department) {
                        return DropdownMenuItem<String>(
                          value: department['description'],
                          child: Text(department['description']),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // setState(() {
                        _selectedDepartment = departments.firstWhere(
                            (department) => department['description'] == value);
                        // });
                      },
                      value: _department),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select status';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: statuses.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> status) {
                      return DropdownMenuItem<String>(
                        value: status['description'],
                        child: Text(status['description']),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // setState(() {
                      _selectedStatus = statuses.firstWhere(
                          (status) => status['description'] == value);
                      // });
                      if (value == 'Resigned') {
                        _resignPopup();
                      }
                    },
                    value: _status,
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select nationality';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Nationality'),
                    items: nationalities.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> nationality) {
                      return DropdownMenuItem<String>(
                        value: nationality['description'],
                        child: Text(nationality['description']),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // setState(() {
                      _selectedNationality = nationalities.firstWhere(
                          (nationality) => nationality['description'] == value);
                      // });
                    },
                    value: _nationality,
                  ),
                  TextFormField(
                    controller: _dob,
                    decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        _dob.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select date of birth';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _joiningDate,
                    decoration:
                        const InputDecoration(labelText: 'Date of Joining'),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        _joiningDate.text =
                            DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select date of joining';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...getActionButtonsWithoutPrivilege(
                        context: context,
                        onSubmit: _onSubmit,
                        hasData: widget.tableRow != null,
                        onDelete: _onDelete,
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
