import 'package:admin/models/alarm_details.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_text_form_field.dart';

class AddAlarmForm extends StatefulWidget {
  final Function closeDialog;
  final Map<String,dynamic>? tableRow;
  final BuildContext context;

  const AddAlarmForm({
    Key? key,
    required this.closeDialog,
    this.tableRow,
    required this.context,
  }) : super(key: key);

  @override
  State<AddAlarmForm> createState() => _AddAlarmFormState();
}

class _AddAlarmFormState extends State<AddAlarmForm> {
  final _formKey = GlobalKey<FormState>();

  final _property = TextEditingController();
  String _parameter = "Suction Pressure";
  String _condition = "Greater than";
  final _value = TextEditingController();
  String _status = "Active";

  final AlarmDetails _alarmDetails = AlarmDetails();

  @override
  void initState() {
    super.initState();
    if (widget.tableRow != null) {
      _property.text = widget.tableRow!["Property"];
      // _alarmDetails.property = widget.tableRow!["Property"];
      _parameter = widget.tableRow!["Parameter"];
      // _alarmDetails.parameter = widget.tableRow!["Parameter"];
      _condition = widget.tableRow!["Condition"];
      // _alarmDetails.condition = widget.tableRow!["Condition"];
      _value.text = widget.tableRow!["Value"].toString();
      // _alarmDetails.value = widget.tableRow!["Value"];
      _status = widget.tableRow!["Status"];
      // _alarmDetails.status = widget.tableRow!["Status"];

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
            CustomTextFormField(
              labelText: 'Property',
              controller: _property,
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
              dropdownOptions: const ['Active', 'Inactive'],
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
      print('Property: ${_property.text}');
      print('Parameter: $_parameter');
      print('Condition: $_condition');
      print('Value: ${_value.text}');
      print('Status: $_status');

      _alarmDetails.property = _property.text;
      _alarmDetails.parameter = _parameter;
      _alarmDetails.condition = _condition;
      _alarmDetails.value = int.parse(_value.text);
      _alarmDetails.status = _status;

      widget.closeDialog(_alarmDetails);

      Navigator.pop(context);

      // bool status = await saveEmployeeDetails(_employeeDetails);
      // if (status) {
      //   showSaveSuccessfulMessage(context);
      //   _dob.clear();
      //   Navigator.pop(context);
      //   widget.closeDialog();
      //   setState(() {});
      // } else {
      //   showSaveFailedMessage(context);
      // }

    } else {
      showSaveFailedMessage(context, "Invalid values");
    }

  }
}
