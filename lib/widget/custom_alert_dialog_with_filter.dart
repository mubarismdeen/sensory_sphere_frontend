import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomAlertDialogWithFilter extends StatefulWidget {

  final String titleText;
  final Widget child;
  final Widget filterChild;

  CustomAlertDialogWithFilter(this.titleText, this.child, this.filterChild);

  @override
  State<CustomAlertDialogWithFilter> createState() => _CustomAlertDialogWithFilterState();
}

class _CustomAlertDialogWithFilterState extends State<CustomAlertDialogWithFilter> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(widget.titleText),
                const SizedBox(width: 35),
                IconButton(
                  onPressed: _openUploadDialog,
                  icon: Icon(
                    Icons.filter_alt_sharp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            TextButton(
              style: const ButtonStyle(alignment: Alignment.topRight),
              onPressed: () {
                navigator?.pop(context);
              },
              child: const Icon(
                Icons.clear,
                color: themeColor,
              ),
            ),
          ],
        ),
        content: widget.child,
        insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      ),
    );
  }
  void _openUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(content: widget.filterChild);
      },
    );
  }
}
