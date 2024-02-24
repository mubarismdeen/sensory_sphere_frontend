import 'package:admin/constants/style.dart';
import 'package:admin/models/clientDetails.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/material.dart';

class ClientDetailsWidget extends StatefulWidget {
  List<ClientDetails> clientDetails;
  ClientDetailsWidget(this.clientDetails);

  @override
  _ClientDetailsWidgetState createState() => _ClientDetailsWidgetState();
}

class _ClientDetailsWidgetState extends State<ClientDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 600),
        child: getCustomCard(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Client Name',
                            style: tableHeaderStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Address',
                            style: tableHeaderStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Mobile 1',
                            style: tableHeaderStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Mobile 2',
                            style: tableHeaderStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Created By',
                            style: tableHeaderStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Created Date',
                            style: tableHeaderStyle,
                          ),
                        ),
                      ),
                    ],
                    rows: widget.clientDetails
                        .map((client) => DataRow(cells: [
                              DataCell(Text(client.name)),
                              DataCell(Text(client.address)),
                              DataCell(Text(client.mobile1)),
                              DataCell(Text(client.mobile2)),
                              DataCell(Text(client.creatBy)),
                              DataCell(Text(
                                  getDateStringFromDateTime(client.creatDt))),
                            ]))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
