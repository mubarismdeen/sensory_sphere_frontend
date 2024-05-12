import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/pages/Devices/system_card.dart';
import 'package:admin/widget/loading_wrapper.dart';
import 'package:flutter/material.dart';

import '../../models/status_entity.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<StatusEntity> dropdownOptions = <StatusEntity>[];

  String dropdownValue = '';
  bool _showLoading = true;

  getDropdownInputs() async {
    dropdownOptions = await getProperties();
    dropdownValue = dropdownOptions.first.description;
    setState(() {
      _showLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDropdownInputs();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      height: 300,
      isLoading: _showLoading,
      color: highlightedColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: highlightedColor),
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeColor),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: dropdownValue,
                          style: const TextStyle(
                              color: lightGrey, fontWeight: FontWeight.bold),
                          items: dropdownOptions.map<DropdownMenuItem<String>>(
                              (StatusEntity value) {
                            return DropdownMenuItem<String>(
                                value: (value.description),
                                child: Text(value.description));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SystemCard(
              propertyName: dropdownValue,
              onLocationButtonPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
