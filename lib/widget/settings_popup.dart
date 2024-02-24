import 'package:admin/api.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  _SettingsPopupState createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  String message = "";

  void _createBackup() async {
    try {
      String response = await createDatabaseBackup();
      if (!response.toLowerCase().startsWith(errorResponse)) {
        showSaveSuccessfulMessage(context, "Backup created successfully");
        setState(() {
          message = response;
        });
      } else {
        showSaveFailedMessage(context, response);
      }
    } catch (e) {
      print('Error: $e');
      showSaveFailedMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Database Backup : ",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              if (message.isEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                  onPressed: _createBackup,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Create Backup'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          if (message.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(message),
            ),
        ],
      ),
    );
  }
}
