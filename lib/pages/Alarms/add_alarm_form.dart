import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/models/alarm_details.dart';
import 'package:admin/models/response_dto.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_dropdown_form_field.dart';
import 'package:admin/widget/loading_wrapper.dart';
import 'package:flutter/material.dart';

import '../../globalState.dart';
import '../../models/status_entity.dart';
import '../../widget/custom_text_form_field.dart';

class AddAlarmForm extends StatefulWidget {
  final Function closeDialog;
  final AlarmDetails? tableRow;

  const AddAlarmForm({
    Key? key,
    required this.closeDialog,
    this.tableRow,
  }) : super(key: key);

  @override
  State<AddAlarmForm> createState() => _AddAlarmFormState();
}

class _AddAlarmFormState extends State<AddAlarmForm> {
  final _formKey = GlobalKey<FormState>();

  String _selectedProperty = "";
  String _selectedParameter = "";
  String _selectedCondition = "";
  String _selectedStatus = "";
  final _value = TextEditingController();

  List<StatusEntity> properties = <StatusEntity>[];
  List<StatusEntity> parameters = <StatusEntity>[];
  List<StatusEntity> conditions = <StatusEntity>[];
  List<StatusEntity> statuses = <StatusEntity>[];

  final AlarmDetails _alarmDetails = AlarmDetails();

  bool _showLoading = true;

  getDropdownInputs() async {
    properties = await getProperties();
    String propertyName = widget.tableRow == null
        ? properties.first.description
        : widget.tableRow!.property;
    parameters = await getParameters(propertyName);
    conditions = await getConditions();
    statuses = await getStatuses();
    if (widget.tableRow == null) {
      _selectedProperty = properties.first.description;
      _selectedParameter = parameters.first.description;
      _selectedCondition = conditions.first.description;
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
      _selectedProperty = widget.tableRow!.property;
      _selectedParameter = widget.tableRow!.parameter;
      _selectedCondition = widget.tableRow!.condition;
      _value.text = widget.tableRow!.value.toString();
      _selectedStatus = widget.tableRow!.status;
      _alarmDetails.id = widget.tableRow!.id;
      _alarmDetails.editBy = GlobalState.username;
      _alarmDetails.editDate = DateTime.now();
    } else {
      _alarmDetails.createBy = GlobalState.username;
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
              CustomDropdownFormField(
                labelText: 'Property',
                dropdownOptions:
                    properties.map((prop) => prop.description).toList(),
                onChanged: (String? value) => {
                  setState(() {
                    _selectedProperty = value!;
                  }),
                },
                value: _selectedProperty,
              ),
              CustomDropdownFormField(
                labelText: 'Parameter',
                dropdownOptions:
                    parameters.map((param) => param.description).toList(),
                onChanged: (String? value) => {
                  setState(() {
                    _selectedParameter = value!;
                  }),
                },
                value: _selectedParameter,
              ),
              CustomDropdownFormField(
                labelText: 'Condition',
                dropdownOptions:
                    conditions.map((cond) => cond.description).toList(),
                onChanged: (String? value) => {
                  setState(() {
                    _selectedCondition = value!;
                  }),
                },
                value: _selectedCondition,
              ),
              CustomTextFormField(
                labelText: 'Value',
                controller: _value,
                isNumeric: true,
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
      print('Property: ${_selectedProperty}');
      print('Parameter: $_selectedParameter');
      print('Condition: $_selectedCondition');
      print('Value: ${_value.text}');
      print('Status: $_selectedStatus');

      try {
        _alarmDetails.property = _selectedProperty;
        _alarmDetails.parameter = _selectedParameter;
        _alarmDetails.condition = _selectedCondition;
        _alarmDetails.value = double.parse(_value.text);
        _alarmDetails.status = _selectedStatus;

        ResponseDto response = await saveAlarmDetails(_alarmDetails);
        if (response.success) {
          showSaveSuccessfulMessage(context, response.message);
          Navigator.pop(context);
          widget.closeDialog(_alarmDetails);
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
