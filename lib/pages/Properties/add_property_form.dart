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
  String _selectedFloatMotorTrigger = "YES";
  String _selectedSmokeMotorTrigger = "YES";
  final _name = TextEditingController();

  List<StatusEntity> statuses = <StatusEntity>[];

  final PropertyDetails _propertyDetails = PropertyDetails();

  bool _showLoading = true;

  getDropdownInputs() async {
    statuses = await getStatuses();
    if (widget.tableRow == null) {
      _selectedStatus = statuses.first.description;
    } else {
      _selectedFloatMotorTrigger =
          getControlString(widget.tableRow!.floatPumpControl);
      _selectedSmokeMotorTrigger =
          getControlString(widget.tableRow!.smokePumpControl);
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
              CustomDropdownFormField(
                labelText: 'Control Motor From Float Switch',
                dropdownOptions: const ["YES", "NO"],
                onChanged: (String? value) => {
                  setState(() {
                    _selectedFloatMotorTrigger = value!;
                  }),
                },
                value: _selectedFloatMotorTrigger,
              ),
              CustomDropdownFormField(
                labelText: 'Control Motor From Smoke Detector',
                dropdownOptions: const ["YES", "NO"],
                onChanged: (String? value) => {
                  setState(() {
                    _selectedSmokeMotorTrigger = value!;
                  }),
                },
                value: _selectedSmokeMotorTrigger,
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
      print('Control Motor From Float Switch: $_selectedFloatMotorTrigger');
      print('Control Motor From Smoke Detector: $_selectedSmokeMotorTrigger');

      try {
        _propertyDetails.name = _name.text;
        _propertyDetails.status = _selectedStatus;
        _propertyDetails.floatPumpControl =
            getControlValue(_selectedFloatMotorTrigger);
        _propertyDetails.smokePumpControl =
            getControlValue(_selectedSmokeMotorTrigger);

        ResponseDto response = await savePropertyDetails(_propertyDetails);
        if (response.success) {
          showSaveSuccessfulMessage(context, response.message);
          Navigator.pop(context);
          widget.closeDialog(_propertyDetails);
          setState(() {});
        } else {
          showSaveFailedMessage(context, response.message);
        }
      } on Exception catch (_) {
        showSaveFailedMessage(context, _.toString());
      }
    } else {
      showSaveFailedMessage(context, "Invalid values");
    }
  }
}
