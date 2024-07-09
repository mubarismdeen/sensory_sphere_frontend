import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:admin/widget/loading_wrapper.dart';
import 'package:flutter/material.dart';

import '../models/response_dto.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  _SettingsPopupState createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  String message = "";
  String historyMessage = "";

  bool _showLoading = true;

  void _createBackup() async {
    try {
      ResponseDto response = await createDatabaseBackup();
      if (response.success) {
        showSaveSuccessfulMessage(context, "Backup created successfully");
        setState(() {
          message = response.message;
        });
      } else {
        showSaveFailedMessage(context, response.message);
      }
    } catch (e) {
      print('Error: $e');
      showSaveFailedMessage(context, "Operation Failed !");
    }
  }

  _getHistoryMessage() async {
    try {
      historyMessage = (await getBackupHistoryMessage()).message;
      setState(() {
        _showLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      showSaveFailedMessage(
          context, "An error occured while fetching backup history!");
    }
  }

  @override
  void initState() {
    super.initState();
    _getHistoryMessage();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _showLoading,
      height: 100,
      child: SizedBox(
        height: 120,
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Database Backup : ",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: lightGrey)),
              if (message.isEmpty)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                            ),
                            onPressed: _createBackup,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Create Backup',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        historyMessage,
                        style: const TextStyle(color: green, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(message, style: const TextStyle(color: green)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
