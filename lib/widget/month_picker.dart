import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MonthPicker extends StatefulWidget {
  DateTime pickedDate;
  void Function(DateTime newDate) onDateChange;

  MonthPicker(this.pickedDate, this.onDateChange);

  @override
  _MonthPickerState createState() => _MonthPickerState(pickedDate, onDateChange);
}

class _MonthPickerState extends State<MonthPicker> {
  DateTime _dateTime;
  void Function(DateTime newDate) onDateChange;

  _MonthPickerState(this._dateTime, this.onDateChange);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _dateTime,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null && picked != _dateTime) {
          setState(() {
            _dateTime = picked;
          });
          onDateChange(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMM-yyyy').format(_dateTime),
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
