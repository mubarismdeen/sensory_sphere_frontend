import 'package:admin/api.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/models/clientDetails.dart';
import 'package:admin/widget/client_details_form.dart';
import 'package:admin/widget/custom_alert_dialog.dart';
import 'package:admin/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/privilege_constants.dart';
import '../../constants/controllers.dart';
import '../../globalState.dart';
import '../../helpers/responsiveness.dart';
import '../../models/userPrivileges.dart';
import '../../utils/common_utils.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<ClientDetails> _clientDetails = List<ClientDetails>.empty();
  UserPrivileges privileges = UserPrivileges(userId: 0, privilegeName: "", creatBy: "", creatDt: DateTime.now());

  getTableData() async {
    _clientDetails = await getClientDetails();
    List<UserPrivileges> clientScreenPrivileges = await getAPrivilegeForUser(
        GlobalState.username, clientDetailsScreenPrivilege);
    if (clientScreenPrivileges.isNotEmpty) {
      privileges = clientScreenPrivileges.first;
    }
  }

  closeDialog() {
    setState(() {
      getTableData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getTableData(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          return SingleChildScrollView(
            child: Column(children: [
              Obx(() => Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: ResponsiveWidget.isSmallScreen(context)
                                ? 56
                                : 6,
                            left: 10),
                        child: CustomText(
                          text: menuController.activeItem.value,
                          size: 24,
                          weight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  )),
              if (privileges.addPrivilege)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 35.0, top: 35.0),
                      child: _uploadButton(privileges),
                    ),
                  ],
                ),
              // ClientDetailsWidget(_clientDetails),
              Padding(
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
                              showCheckboxColumn: false,
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
                              rows: _clientDetails
                                  .map((client) => DataRow(
                                          cells: [
                                            DataCell(Text(client.name)),
                                            DataCell(Text(client.address)),
                                            DataCell(Text(client.mobile1)),
                                            DataCell(Text(client.mobile2)),
                                            DataCell(Text(
                                                client.creatBy)),
                                            DataCell(Text(
                                                getDateStringFromDateTime(
                                                    client.creatDt))),
                                          ],
                                          onSelectChanged: (selected) {
                                            if (selected != null && selected &&
                                                (privileges.editPrivilege ||
                                                    privileges.deletePrivilege)) {
                                              _openDialog(client, privileges);
                                            }
                                          }))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          );
        });
  }

  void _openDialog(ClientDetails? tableRow, UserPrivileges privileges) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: 'Add New Client',
            child: ClientDetailsForm(closeDialog, tableRow, privileges),
        );
      },
    );
  }

  Widget _uploadButton(UserPrivileges privileges) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: themeColor,
      ),
      onPressed: () => _openDialog(null, privileges),
      child: const Text('Add Client',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
