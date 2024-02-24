import 'package:admin/globalState.dart';
import 'package:admin/models/docDetails.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api.dart';

class DocDetailsUpload extends StatefulWidget {
  dynamic closeDialog;
  Map<String, dynamic>? tableRow;
  UserPrivileges privileges;

  DocDetailsUpload(this.closeDialog, this.tableRow, this.privileges);

  @override
  State<DocDetailsUpload> createState() => _DocDetailsUploadState();
}

class _DocDetailsUploadState extends State<DocDetailsUpload> {
  final _formKey = GlobalKey<FormState>();

  var _narration = TextEditingController();
  var _dueDate = TextEditingController();
  var _renewedDate = TextEditingController();
  late Map<String, dynamic> _selectedDocType;
  String? _docType;

  List<Map<String, dynamic>> docTypes = <Map<String, dynamic>>[];

  _DocDetailsUploadState();

  getDropdownInputs() async {
    docTypes = await getDocType();
    if (widget.tableRow != null) {
      setValue();
    }
  }

  setValue() {
    _docDetails.id = widget.tableRow!['id'];
    _narration.text = widget.tableRow!['narration'].toString();
    _docType = widget.tableRow!['docType'].toString();
    _dueDate.text = widget.tableRow!['dueDate'].toString();
    _renewedDate.text = widget.tableRow!['renewedDate'].toString();

    _selectedDocType =
        docTypes.firstWhere((docType) => docType['description'] == _docType);
  }

  DocDetails _docDetails = DocDetails(
      id: 0,
      narration: "",
      empCode: GlobalState.userEmpCode,
      docid: 0,
      dueDate: DateTime.now(),
      renewedDate: DateTime.now(),
      creatBy: GlobalState.userEmpCode,
      creatDt: DateTime.now(),
      editBy: GlobalState.userEmpCode,
      editDt: DateTime.now());

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Submit the form data to a backend API or do something else with it
      print('Submitted form data:');
      print('Name: $_narration');
      print('Due Date: $_dueDate');
      print('Renewed Date: $_renewedDate');
    }
    _docDetails.narration = _narration.text;
    _docDetails.dueDate = DateTime.parse(_dueDate.text);
    _docDetails.renewedDate = DateTime.parse(_renewedDate.text);
    _docDetails.docid = _selectedDocType['id'];

    bool status = await saveDocDetails(_docDetails);
    if (status) {
      _narration.clear();
      _dueDate.clear();
      _renewedDate.clear();

      showSaveSuccessfulMessage(context);
      Navigator.pop(context);
      widget.closeDialog();

      setState(() {});
      // _salaryMaster = SalaryMaster as SalaryMaster;
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onDelete() async {
    bool status = await deleteDocDetails(_docDetails.id);
    if (status) {
      showSaveSuccessfulMessage(context);
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
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                    controller: _narration,
                    onSaved: (value) {},
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select document type';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Doc Type'),
                    items:
                        docTypes.map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value['description'].toString(),
                        child: Text(value['description']),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedDocType = docTypes.firstWhere(
                          (docType) => docType['description'] == value);
                    },
                    value: _docType,
                  ),
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
                  TextFormField(
                    controller: _renewedDate,
                    decoration:
                        const InputDecoration(labelText: 'Renewed Date'),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        _renewedDate.text =
                            DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select Renewed Date';
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
                          onDelete: _onDelete)
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
