import 'package:admin/api.dart';
import 'package:admin/models/alarm_details.dart';
import 'package:admin/models/response_dto.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';

import '../../globalState.dart';
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

  String _property = "test_property";
  String _parameter = "Suction Pressure";
  String _condition = "Greater than";
  final _value = TextEditingController();
  String _status = "active";

  final AlarmDetails _alarmDetails = AlarmDetails();

  @override
  void initState() {
    super.initState();
    if (widget.tableRow != null) {
      _property = widget.tableRow!.property;
      _parameter = widget.tableRow!.parameter;
      _condition = widget.tableRow!.condition;
      _value.text = widget.tableRow!.value.toString();
      _status = widget.tableRow!.status;
      _alarmDetails.id = widget.tableRow!.id;
      _alarmDetails.editBy = GlobalState.username;
      _alarmDetails.editDate = DateTime.now();
    } else {
      _alarmDetails.createBy = GlobalState.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDropdownFormField(
              labelText: 'Property',
              dropdownOptions: const ['test_property'],
              onChanged: (String? value) => {
                setState(() {
                  _property = value!;
                }),
              },
              value: _property,
            ),
            CustomDropdownFormField(
              labelText: 'Parameter',
              dropdownOptions: const [
                'Suction Pressure',
                'Discharge Pressure',
                'Oxygen A Pressure',
                'Oxygen B Pressure',
                'Ambient Temperature',
                'Total Current'
              ],
              onChanged: (String? value) => {
                setState(() {
                  _parameter = value!;
                }),
              },
              value: _parameter,
            ),
            CustomDropdownFormField(
              labelText: 'Condition',
              dropdownOptions: const [
                'Greater than',
                'Greater than or equal to',
                'Lesser than',
                'Lesser than or equal to'
              ],
              onChanged: (String? value) => {
                setState(() {
                  _condition = value!;
                }),
              },
              value: _condition,
            ),
            CustomTextFormField(
              labelText: 'Value',
              controller: _value,
              isNumeric: true,
            ),
            CustomDropdownFormField(
              labelText: 'Status',
              dropdownOptions: const ['active', 'inactive'],
              onChanged: (String? value) => {
                setState(() {
                  _status = value!;
                }),
              },
              value: _status,
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
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      print('Submitted form data:');
      print('Property: ${_property}');
      print('Parameter: $_parameter');
      print('Condition: $_condition');
      print('Value: ${_value.text}');
      print('Status: $_status');

      try {
        _alarmDetails.property = _property;
        _alarmDetails.parameter = _parameter;
        _alarmDetails.condition = _condition;
        _alarmDetails.value = double.parse(_value.text);
        _alarmDetails.status = _status;

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
