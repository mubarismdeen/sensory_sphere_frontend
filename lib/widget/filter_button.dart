import 'package:flutter/material.dart';


class FilterIconButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter IconButton Demo'),
      ),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.filter_alt_sharp),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FilterDialog();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Perform other actions here
        },
      ),
    );
  }
}

class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your filter options here
            Text('Filter Dialog'),
          ],
        ),
      ),
    );
  }
}
