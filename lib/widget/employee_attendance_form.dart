import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceForm extends StatefulWidget {
  @override
  _EmployeeAttendanceFormState createState() => _EmployeeAttendanceFormState();
}

class _EmployeeAttendanceFormState extends State<EmployeeAttendanceForm> {
  final _formKey = GlobalKey<FormState>();
  String _employeeName = '';
  DateTime _date = DateTime.now();
  String _attendanceStatus = 'Present';


  // Define methods to update the state variables based on user input
  // ...

  // Define a method to submit the form data
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Send the data to a server or save it locally
      // ...
      // Clear the form and reset the state variables
      _formKey.currentState?.reset();
      setState(() {
        _employeeName = '';
        _date = DateTime.now();
        _attendanceStatus = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Employee Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) => setState(() => _employeeName = value!),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Date'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a date';
              }
              return null;
            },
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _date ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _date = date);
              }
            },
            readOnly: true,
            controller: TextEditingController(text: _date.toString()),
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Attendance Status'),
            value: _attendanceStatus,
            items: const [
              DropdownMenuItem(value: 'Present', child: Text('Present')),
              DropdownMenuItem(value: 'Absent', child: Text('Absent')),
              DropdownMenuItem(value: 'Late', child: Text('Late')),
            ],
            validator: (value) {
              if (value == null) {
                return 'Please select an attendance status';
              }
              return null;
            },
            onChanged: (value) => setState(() => _attendanceStatus = value.toString()),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                ),
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

