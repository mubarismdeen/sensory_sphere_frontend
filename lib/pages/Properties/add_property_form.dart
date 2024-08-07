import 'package:admin/api.dart';
import 'package:admin/models/property_details.dart';
import 'package:admin/models/response_dto.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';

import '../../constants/style.dart';
import '../../globalState.dart';
import '../../models/status_entity.dart';
import '../../widget/custom_text_form_field.dart';
import '../../widget/loading_wrapper.dart';

class AddPropertyForm extends StatefulWidget {
  final Function closeDialog;
  final PropertyDetails? tableRow;

  const AddPropertyForm({
    Key? key,
    required this.closeDialog,
    this.tableRow,
  }) : super(key: key);

  @override
  State<AddPropertyForm> createState() => _AddPropertyFormState();
}

class _AddPropertyFormState extends State<AddPropertyForm> {
  final _formKey = GlobalKey<FormState>();

  String _selectedStatus = "";
  final _name = TextEditingController();

  List<StatusEntity> statuses = <StatusEntity>[];

  final PropertyDetails _propertyDetails = PropertyDetails();

  bool _showLoading = true;

  getDropdownInputs() async {
    statuses = await getStatuses();
    if (widget.tableRow == null) {
      _selectedStatus = statuses.first.description;
    }
    setState(() {
      _showLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDropdownInputs();
    if (widget.tableRow != null) {
      _name.text = widget.tableRow!.name;
      _selectedStatus = widget.tableRow!.status;
      _propertyDetails.id = widget.tableRow!.id;
      _propertyDetails.editBy = GlobalState.username;
      _propertyDetails.editDate = DateTime.now();
    } else {
      _propertyDetails.createBy = GlobalState.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _showLoading,
      height: 200,
      color: highlightedColor,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                labelText: 'Property Name',
                controller: _name,
              ),
              CustomDropdownFormField(
                labelText: 'Status',
                dropdownOptions:
                    statuses.map((stat) => stat.description).toList(),
                onChanged: (String? value) => {
                  setState(() {
                    _selectedStatus = value!;
                  }),
                },
                value: _selectedStatus,
              ),
              const SizedBox(height: 26.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...getActionButtonsWithoutPrivilege(
                    context: context,
                    onSubmit: () => _onSubmit(context),
                    hasData: widget.tableRow != null,
                    onDelete: () => () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      print('Submitted form data:');
      print('Name: ${_name.text}');
      print('Status: $_selectedStatus');

      try {
        bool confirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Confirm Action",
                style: TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure?",
                style: TextStyle(color: lightGrey),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User did not confirm
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirmed
                  },
                  child: const Text("Confirm",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ),
              ],
            );
          },
        );
        if (confirmed != null && confirmed) {
          _propertyDetails.name = _name.text;
          _propertyDetails.status = _selectedStatus;

          ResponseDto response = await savePropertyDetails(_propertyDetails);
          if (response.success) {
            showSaveSuccessfulMessage(context, response.message);
            Navigator.pop(context);
            widget.closeDialog(_propertyDetails);
            setState(() {});
          } else {
            showSaveFailedMessage(context, response.message);
          }
        }
      } on Exception catch (_) {
        showSaveFailedMessage(context, _.toString());
      }
    } else {
      showSaveFailedMessage(context, "Invalid values");
    }
  }
}
