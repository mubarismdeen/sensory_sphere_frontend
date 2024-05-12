import 'dart:io' show Platform;

import 'package:admin/models/userPrivileges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../constants/style.dart';

String getDateStringFromDateTime(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

Card getCustomCard(Widget child) {
  return Card(
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    shadowColor: shadowColor,
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    child: Padding(padding: const EdgeInsets.all(8.0), child: child),
  );
}

bool getViewPrivilege(UserPrivileges privileges) {
  return privileges.viewPrivilege == true ? true : false;
}

List<Widget> getActionButtonsWithoutPrivilege(
    {required BuildContext context,
    required void Function() onSubmit,
    bool hasData = false,
    void Function()? onDelete}) {
  List<Widget> widgetList = [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade400.withOpacity(0.85),
      ),
      onPressed: onSubmit,
      child: Text(
        hasData ? 'Save' : 'Submit',
        style: const TextStyle(color: light, fontWeight: FontWeight.bold),
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ];
  if (hasData) {
    widgetList.add(
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: errorColor,
        ),
        onPressed: onDelete,
        child: const Text(
          'Delete',
          style: TextStyle(color: light, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  return widgetList;
}

List<Widget> getActionButtonsWithPrivilege(
    {required BuildContext context,
    required UserPrivileges privileges,
    required bool hasData,
    required void Function() onSubmit,
    required void Function() onDelete}) {
  List<Widget> widgetList = [
    if (privileges.editPrivilege)
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlightedColor,
        ),
        onPressed: onSubmit,
        child: const Text(
          'Submit',
          style: TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
        ),
      ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColor,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Cancel',
        style: TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
      ),
    ),
  ];
  if (hasData && privileges.deletePrivilege) {
    widgetList.add(
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: errorColor,
        ),
        onPressed: onDelete,
        child: const Text(
          'Delete',
          style: TextStyle(color: lightGrey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  return widgetList;
}

void showSaveSuccessfulMessage(BuildContext context,
    [String message = "Save Successful"]) {
  if (Platform.isWindows) {
    final snackBar = SnackBar(
      content: Container(
          width: 200,
          child: Text(
            message,
            textAlign: TextAlign.center,
          )),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webShowClose: false,
    );
  }
}

void showSaveFailedMessage(BuildContext context,
    [String message = "Unable to save"]) {
  if (Platform.isWindows) {
    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webShowClose: false,
    );
  }
}

String getDateTimeString(DateTime? dateTime) {
  if (dateTime == null) {
    return "";
  }
  DateFormat outputFormat = DateFormat('MMM d, y h:mm a');
  return outputFormat.format(dateTime);
}
