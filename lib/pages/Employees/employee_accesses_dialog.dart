import 'package:admin/api.dart';
import 'package:admin/constants/privilege_constants.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../models/userDetails.dart';
import '../../models/userScreens.dart';
import '../../widget/custom_alert_dialog.dart';

class EmployeeAccessesDialog extends StatefulWidget {
  UserScreens userScreens;
  UserDetails? userDetails;
  List<UserPrivileges> userPrivilegesList;
  String employeeName;
  String employeeCode;

  EmployeeAccessesDialog(
      {required this.userScreens,
      required this.userPrivilegesList,
      required this.employeeName,
      required this.employeeCode,
      required this.userDetails});

  @override
  State<EmployeeAccessesDialog> createState() => _EmployeeAccessesDialogState();
}

class _EmployeeAccessesDialogState extends State<EmployeeAccessesDialog> {
  late UserScreens _userScreens;
  late UserDetails _userDetails;
  late List<UserPrivileges> _privilegesList;
  late List<Screen> _selectedScreens;
  late List<String> _selectedPrivileges;
  late bool _isProfileSet;

  var _username = TextEditingController();
  var _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedScreens = [];
    _selectedPrivileges = [];
    _userScreens = widget.userScreens;
    _isProfileSet = widget.userDetails != null;
    if (_isProfileSet) {
      _userDetails = widget.userDetails!;
      _username.text = _userDetails.name;
      _password.text = _userDetails.password;
    } else {
      _userDetails = UserDetails(
          creatBy: GlobalState.userEmpCode, empCode: widget.employeeCode);
    }
    if (_userScreens.dashboard) _selectedScreens.add(Screen.dashboard);
    if (_userScreens.employees) _selectedScreens.add(Screen.employees);
    if (_userScreens.attendance) _selectedScreens.add(Screen.attendance);
    if (_userScreens.salaryMaster) _selectedScreens.add(Screen.salaryMaster);
    if (_userScreens.salaryPayout) _selectedScreens.add(Screen.salaryPayout);
    if (_userScreens.leaveSalary) _selectedScreens.add(Screen.leaveSalary);
    if (_userScreens.clients) _selectedScreens.add(Screen.clients);
    if (_userScreens.gratuity) _selectedScreens.add(Screen.gratuity);
    _privilegesList = widget.userPrivilegesList;
    for (UserPrivileges priv in _privilegesList) {
      for (Privilege p in Privilege.values) {
        if (p.name == priv.privilegeName) {
          _selectedPrivileges.add(p.displayValue);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: "${widget.employeeName} (${widget.employeeCode})",
      titleStyle: const TextStyle(fontWeight: FontWeight.w500),
      child: Container(
        child: SingleChildScrollView(
          child: DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      child: Text("Profile",
                          style: TextStyle(color: themeColor, fontSize: 16)),
                    ),
                    Tab(
                      child: Text("Screens",
                          style: TextStyle(color: themeColor, fontSize: 16)),
                    ),
                    Tab(
                      child: Text("Privileges",
                          style: TextStyle(color: themeColor, fontSize: 16)),
                    ),
                  ],
                ),
                Container(
                  height: 400,
                  width: 600,
                  child: TabBarView(
                    children: [
                      _buildProfileTab(),
                      _buildScreensTab(),
                      _buildPrivilegesTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isProfileSet)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "User profile not set in the system",
                style: TextStyle(color: Colors.redAccent, fontSize: 13),
                textAlign: TextAlign.start,
              ),
            )
          else
            const SizedBox(width: 1),
          Container(
            width: 450,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                  controller: _username,
                  onSaved: (value) {},
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  controller: _password,
                  onSaved: (value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...getActionButtonsWithoutPrivilege(
                    context: context, onSubmit: _onUserDetailsSubmit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreensTab() {
    if (!_isProfileSet) {
      return _getProfileNotSetMessage();
    }
    List<Widget> checkboxes = Screen.values.map((selectedScreen) {
      String screenName = selectedScreen.value;
      return CheckboxListTile(
        title: Text(
          screenName,
          style: const TextStyle(fontSize: 13),
        ),
        activeColor: Colors.blueAccent,
        value: _selectedScreens.contains(selectedScreen),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedScreens.add(selectedScreen);
              _toggleValueForScreen(selectedScreen);
            } else {
              _selectedScreens.remove(selectedScreen);
              _toggleValueForScreen(selectedScreen);
            }
          });
        },
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 500,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 5.0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: checkboxes,
          ),
        ),
        SizedBox(
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...getActionButtonsWithoutPrivilege(
                  context: context, onSubmit: _onScreensSubmit),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleValueForScreen(Screen screen) {
    switch (screen) {
      case Screen.dashboard:
        _userScreens.dashboard = !_userScreens.dashboard;
        break;
      case Screen.employees:
        _userScreens.employees = !_userScreens.employees;
        break;
      case Screen.attendance:
        _userScreens.attendance = !_userScreens.attendance;
        break;
      case Screen.salaryMaster:
        _userScreens.salaryMaster = !_userScreens.salaryMaster;
        break;
      case Screen.salaryPayout:
        _userScreens.salaryPayout = !_userScreens.salaryPayout;
        break;
      case Screen.leaveSalary:
        _userScreens.leaveSalary = !_userScreens.leaveSalary;
        break;
      case Screen.clients:
        _userScreens.clients = !_userScreens.clients;
        break;
      case Screen.gratuity:
        _userScreens.gratuity = !_userScreens.gratuity;
        break;
    }
  }

  Widget _buildPrivilegesTab() {
    if (!_isProfileSet) {
      return _getProfileNotSetMessage();
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 250,
                    child: DropdownButtonFormField<String>(
                      focusColor: Colors.white,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Add Privilege",
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      items: Privilege.values.map((Privilege option) {
                        return DropdownMenuItem<String>(
                          value: option.displayValue,
                          child: Text(option.displayValue),
                        );
                      }).toList(),
                      onChanged: (selectedOption) {
                        if (selectedOption != null &&
                            !_selectedPrivileges.contains(selectedOption)) {
                          _selectedPrivileges.add(selectedOption);

                          UserPrivileges newPrivilege = UserPrivileges(
                            userId: _userDetails.userCd,
                            privilegeName:
                                _getPrivilegeNameForDisplayValue(selectedOption),
                            creatBy: GlobalState.userEmpCode,
                            creatDt: DateTime.now(),
                          );

                          _privilegesList.add(newPrivilege);
                          setState(() {
                            _selectedPrivileges;
                            _privilegesList;
                          });
                        } else {
                          showSaveFailedMessage(
                              context, "Privilege already present");
                        }
                      },
                    ),
                  ),
                ),
                if (_privilegesList.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                      "No privileges set currently for the user. \nSelect required privileges from the dropdown to start adding.",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_privilegesList.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text("Privilege", style: tableHeaderStyle),
                        ),
                        DataColumn(
                          label: Text("View", style: tableHeaderStyle),
                        ),
                        DataColumn(
                          label: Text("Add", style: tableHeaderStyle),
                        ),
                        DataColumn(
                          label: Text("Edit", style: tableHeaderStyle),
                        ),
                        DataColumn(
                          label: Text("Delete", style: tableHeaderStyle),
                        ),
                      ],
                      rows: _privilegesList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final privilege = entry.value;
                        final privilegeDisplayValue = Privilege.values
                            .filter(
                                (element) => element.name == privilege.privilegeName)
                            .first
                            .displayValue;
                        return DataRow(cells: [
                          DataCell(Text(privilegeDisplayValue)),
                          DataCell(
                            Checkbox(
                              value: privilege.viewPrivilege,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) {
                                _privilegesList[index].viewPrivilege = value!;
                                setState(() {});
                              },
                            ),
                          ),
                          DataCell(
                            Checkbox(
                              value: privilege.addPrivilege,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) {
                                _privilegesList[index].addPrivilege = value!;
                                setState(() {});
                              },
                            ),
                          ),
                          DataCell(
                            Checkbox(
                              value: privilege.editPrivilege,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) {
                                _privilegesList[index].editPrivilege = value!;
                                setState(() {});
                              },
                            ),
                          ),
                          DataCell(
                            Checkbox(
                              value: privilege.deletePrivilege,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) {
                                _privilegesList[index].deletePrivilege = value!;
                                setState(() {});
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
              ],
            ),
            if (_privilegesList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...getActionButtonsWithoutPrivilege(
                        context: context, onSubmit: _onPrivilegesSubmit),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUserDetailsSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      print('Submitted form data:');
      print('Username: $_username');
      print('Password: $_password');
    }
    _userDetails.name = _username.text;
    _userDetails.password = _password.text;
    _userDetails.editBy = GlobalState.userEmpCode;
    _userDetails.editDt = DateTime.now();

    bool status = await saveUserDetails(_userDetails);
    if (status) {
      showSaveSuccessfulMessage(context);
      _userDetails = (await getUserDetails(_userDetails.empCode)).first;
      setState(() {
        _userDetails;
        _isProfileSet = true;
      });
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onScreensSubmit() async {
    _userScreens.editBy = GlobalState.userEmpCode;
    _userScreens.editDt = DateTime.now();
    _userScreens.userId = _userDetails.userCd;

    bool status = await saveScreensForEmployee(_userScreens);
    if (status) {
      showSaveSuccessfulMessage(context);
      _userScreens = (await getScreensForEmployee(_userDetails.empCode)).first;
      setState(() {
        _userScreens;
      });
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onPrivilegesSubmit() async {
    for (int i = 0; i < _privilegesList.length; i++) {
      _privilegesList[i].editBy = GlobalState.userEmpCode;
      _privilegesList[i].editDt = DateTime.now();
    }
    bool status = await savePrivilegesForUser(_privilegesList);
    if (status) {
      showSaveSuccessfulMessage(context);
      _privilegesList = await getAllPrivilegesForUser(widget.employeeCode);
      setState(() {
        _privilegesList;
      });
    } else {
      showSaveFailedMessage(context);
    }
  }

  Widget _getProfileNotSetMessage() {
    return const Center(
      child: Text(
        "User profile not set in the system. \nSet it first to enable this option",
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  String _getPrivilegeNameForDisplayValue(String value) {
    for (Privilege priv in Privilege.values) {
      if (priv.displayValue == value) {
        return priv.name;
      }
    }
    return "";
  }
}
