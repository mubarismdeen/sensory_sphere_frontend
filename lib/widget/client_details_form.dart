import 'package:admin/globalState.dart';
import 'package:admin/models/clientDetails.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import '../utils/common_utils.dart';

class ClientDetailsForm extends StatefulWidget {
  dynamic closeDialog;
  ClientDetails? tableRow;
  UserPrivileges privileges;

  ClientDetailsForm(this.closeDialog, this.tableRow, this.privileges,
      {Key? key})
      : super(key: key);

  @override
  State<ClientDetailsForm> createState() => _ClientDetailsFormState();
}

class _ClientDetailsFormState extends State<ClientDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  var _address = TextEditingController();
  var _name = TextEditingController();
  var _mobile1 = TextEditingController();
  var _mobile2 = TextEditingController();

  setValue() {
    _clientDetails.id = widget.tableRow!.id;
    _name.text = widget.tableRow!.name;
    _address.text = widget.tableRow!.address;
    _mobile1.text = widget.tableRow!.mobile1;
    _mobile2.text = widget.tableRow!.mobile2;
  }

  ClientDetails _clientDetails = ClientDetails(
      id: 0,
      name: '',
      address: '',
      mobile1: '',
      mobile2: '',
      editBy: GlobalState.userEmpCode,
      editDt: DateTime.now(),
      creatBy: GlobalState.userEmpCode,
      creatDt: DateTime.now());

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Submit the form data to a backend API or do something else with it
      print('Submitted form data:');
      print('Client Name: $_name');
      print('Address: $_address');
      print('Mobile 1: $_mobile1');
      print('Mobile 2: $_mobile2');
    }
    _clientDetails.name = _name.text;
    _clientDetails.address = _address.text;
    _clientDetails.mobile1 = _mobile1.text;
    _clientDetails.mobile2 = _mobile2.text;

    bool status = await saveClientDetails(_clientDetails);
    if (status) {
      showSaveSuccessfulMessage(context);
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onDelete() async {
    bool status = await deleteClientDetails(_clientDetails.id);
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
    if (widget.tableRow != null) {
      setValue();
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Client Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client name';
                }
                return null;
              },
              controller: _name,
              onSaved: (value) {},
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
              controller: _address,
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
}
