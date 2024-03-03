import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String labelText;
  final List<String> dropdownOptions;
  final Function onChanged;
  final String value;

  const CustomDropdownFormField(
      {Key? key,
      required this.labelText,
      required this.value,
      required this.dropdownOptions,
      required this.onChanged})
      : super(key: key);

  @override
  State<CustomDropdownFormField> createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
            color: highlightedColor, fontWeight: FontWeight.bold),
      ),
      style: const TextStyle(color: lightGrey),
      validator: (value) {
        if (value == null) {
          return 'Please select ${widget.labelText.toLowerCase()}';
        }
        return null;
      },
      items: widget.dropdownOptions
          .map((parameter) => DropdownMenuItem<String>(
                value: parameter,
                child: Text(parameter),
              ))
          .toList(),
      onChanged: (String? value) {
        widget.onChanged(value);
      },
      value: widget.value,
    );
  }
}
