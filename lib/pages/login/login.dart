import 'dart:convert';

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/userScreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../layout.dart';
import '../../models/Address.dart';
import '../../utils/common_utils.dart';
import '../../widget/custom_alert_dialog.dart';
import '../../widget/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RestorationMixin {
  final RestorableTextEditingController _usernameController =
      RestorableTextEditingController();
  final RestorableTextEditingController _passwordController =
      RestorableTextEditingController();
  final RestorableTextEditingController _ipController =
      RestorableTextEditingController();
  final RestorableTextEditingController _clientController =
      RestorableTextEditingController();

  @override
  String get restorationId => 'login_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_usernameController, restorationId);
    registerForRestoration(_passwordController, restorationId);
    registerForRestoration(_ipController, restorationId);
    registerForRestoration(_clientController, restorationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      body: SafeArea(
        child: _MainView(
          usernameController: _usernameController.value,
          passwordController: _passwordController.value,
          ipController: _ipController.value,
          clientController: _clientController.value,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _ipController.dispose();
    super.dispose();
  }
}

class _MainView extends StatefulWidget {
  const _MainView({
    this.usernameController,
    this.passwordController,
    this.ipController,
    this.clientController,
  });

  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  final TextEditingController? ipController;
  final TextEditingController? clientController;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  BoxDecoration? borderDecoration;
  bool showError = false;
  bool showLoading = false;
  String ipAddress = '';
  String ipMessage = 'IP is not set';
  List<Address> addressList = [];
  String _selectedClient = '';
  final _formKey = GlobalKey<FormState>();

  final _addClientName = TextEditingController();
  final _addClientAddress = TextEditingController();

  void _login() {
    Get.to(SiteLayout());
  }

  @override
  void initState() {
    super.initState();
    _getSavedIpAddress();
  }

  Future<void> _getSavedIpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedAddressList = prefs.getStringList(IP_ADDRESSES);
    if (savedAddressList != null) {
      setState(() {
        addressList = savedAddressList.map((jsonString) {
          Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          return Address.fromJson(jsonMap);
        }).toList();
      });
    }
  }

  Future<void> _saveIpAddress() async {
    String ip = widget.ipController!.text.trim();
    ipAddress = ip;
    GlobalState.setIpAddress(ip);
    Address clientAddress =
        addressList.firstWhere((element) => element.name == _selectedClient);
    addressList.remove(clientAddress);
    clientAddress.ip = ip;
    addressList.add(clientAddress);
    saveIPs();
  }

  void saveIPs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (addressList.isNotEmpty) {
      List<String> jsonList =
          addressList.map((obj) => jsonEncode(obj.toJson())).toList();
      await prefs.setStringList(IP_ADDRESSES, jsonList);
    }
  }

  Future<void> _onSubmitClient(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      print('Submitted form data:');
      print('Client Name: ${_addClientName.text}');
      print('Client Address: ${_addClientAddress.text}');

      try {
        Address newClientAddress =
            Address(name: _addClientName.text, ip: _addClientAddress.text);
        setState(() {
          addressList.add(newClientAddress);
        });
        saveIPs();
        _addClientName.clear();
        _addClientAddress.clear();
        Navigator.pop(context);
      } on Exception catch (_) {
        showSaveFailedMessage(context, _.toString());
      }
    } else {
      showSaveFailedMessage(context, "Invalid values");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenw = MediaQuery.of(context).size.width;
    final isDesktop = screenw > 700 ? true : false;
    List<Widget> listViewChildren;

    listViewChildren = [];

    if (_selectedClient == '') {
      listViewChildren = [
        const _AppLogo(),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 0),
            child: DropdownButtonFormField<String>(
              key: Key(addressList.length.toString()),
              iconEnabledColor: Colors.blue,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueAccent),
              decoration: const InputDecoration(
                labelText: "Client",
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              value: _selectedClient,
              items: [Address(name: '', ip: ''), ...addressList]
                  .map((Address address) {
                return DropdownMenuItem<String>(
                  value: address.name,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(address.name),
                      if (address.name != '')
                        IconButton(
                          icon: Icon(Icons.cancel,
                              color: Colors.red.withOpacity(0.5)),
                          onPressed: () {
                            setState(() {
                              addressList.remove(address);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedClient = newValue!;
                  widget.clientController?.text = newValue!;
                  String selectedIP = addressList
                      .firstWhere((ad) => ad.name == _selectedClient)
                      .ip;
                  widget.ipController?.text = selectedIP;
                  ipAddress = selectedIP;
                  GlobalState.setIpAddress(selectedIP);
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                      title: 'Add Client',
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextFormField(
                                labelText: 'Client Name',
                                controller: _addClientName,
                              ),
                              CustomTextFormField(
                                labelText: 'Client Address',
                                controller: _addClientAddress,
                              ),
                              const SizedBox(height: 26.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ...getActionButtonsWithoutPrivilege(
                                    context: context,
                                    onSubmit: () => _onSubmitClient(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // child: EmployeeDetailsForm(closeDialog, tableRow, context),
                    );
                  },
                );
              },
              child: const Text(
                "+ Add Client",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue),
              ),
            ),
          ),
        ),
      ];
    } else {
      if (ipAddress != '') {
        listViewChildren = [
          const _AppLogo(),
          _UsernameInput(
            maxWidth: 400,
            usernameController: widget.usernameController,
          ),
          const SizedBox(height: 12),
          _PasswordInput(
            maxWidth: 400,
            passwordController: widget.passwordController,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    ipAddress = '';
                    _selectedClient = '';
                    widget.passwordController!.clear();
                    widget.usernameController!.clear();
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.arrow_circle_left_outlined, color: Colors.blue),
                    Text(
                      "Switch Client",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // const SizedBox(height: 12),
          _LoginButton(
            maxWidth: 400,
            onTap: () async {
              setState(() {
                showLoading = true;
              });

              try {
                UserScreens screensForUser = await authorizeUser(
                  widget.usernameController!.text,
                  widget.passwordController!.text,
                );
                GlobalState.setScreensForUser(
                    widget.usernameController!.text, screensForUser);
                showError = false;
                _login();
                widget.usernameController?.clear();
                widget.passwordController?.clear();
                widget.ipController?.clear();
                widget.clientController?.clear();
                ipAddress = '';
                _selectedClient = '';
              } catch (e) {
                if (e is UnauthorizedException) {
                  showSaveFailedMessage(context, "Login Failed");
                  showError = true;
                } else {
                  e.printError();
                  setState(() {
                    ipAddress = '';
                    ipMessage = 'Please verify IP';
                  });
                  showSaveFailedMessage(
                      context, "Error in establishing connection");
                }
              }
              setState(() {
                showLoading = false;
              });
            },
            status: showError,
          ),
        ];
      } else {
        listViewChildren = [
          const _AppLogo(),
          _IpNameInput(
            maxWidth: 400,
            clientController: widget.clientController,
          ),
          const SizedBox(height: 15),
          _IpAddressInput(
            maxWidth: 400,
            ipController: widget.ipController,
          ),
          const SizedBox(height: 12),
          _SaveIpButton(
            ipMessage: ipMessage,
            maxWidth: 400,
            onTap: () async {
              setState(() {
                showLoading = true;
              });
              await _saveIpAddress();
              _getSavedIpAddress();
              setState(() {
                showLoading = false;
              });
            },
          ),
        ];
      }
    }
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: isDesktop ? Alignment.center : Alignment.topCenter,
            child: showLoading
                ? const SpinKitWave(
                    color: highlightedColor,
                    size: 30,
                  )
                : ListView(
                    restorationId: 'login_list_view',
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: listViewChildren,
                  ),
          ),
        ),
      ],
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: highlightedColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Hero(
                  tag: 'icon',
                  child: SizedBox(
                    height: 160,
                    child: ExcludeSemantics(
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          mainTitleColor, // Desired color
                          BlendMode.srcIn,
                        ),
                        child: Image.asset('images/app_icon.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  appTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      fontFamily: "LobsterFont",
                      color: mainTitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    this.maxWidth,
    this.usernameController,
  });

  final double? maxWidth;
  final TextEditingController? usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InputBox(
          maxWidth: maxWidth,
          displayText: "Username",
          obscureText: false,
          controller: usernameController),
    );
  }
}

class _IpNameInput extends StatelessWidget {
  const _IpNameInput({
    this.maxWidth,
    this.clientController,
  });

  final double? maxWidth;
  final TextEditingController? clientController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InputBox(
          enabled: false,
          maxWidth: maxWidth,
          displayText: "Client Name",
          obscureText: false,
          controller: clientController),
    );
  }
}

class _IpAddressInput extends StatelessWidget {
  const _IpAddressInput({
    this.maxWidth,
    this.ipController,
  });

  final double? maxWidth;
  final TextEditingController? ipController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InputBox(
          maxWidth: maxWidth,
          displayText: "IP Address",
          obscureText: false,
          controller: ipController),
    );
  }
}

class InputBox extends StatelessWidget {
  OutlineInputBorder inputBoxStyle = const OutlineInputBorder(
    borderSide: BorderSide(color: inputFieldOutlineColor),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  late final double? maxWidth;
  String? displayText;
  final TextEditingController? controller;
  bool obscureText;
  bool enabled;

  InputBox(
      {Key? key,
      this.maxWidth,
      required this.displayText,
      required this.obscureText,
      this.enabled = true,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: TextField(
        enabled: enabled,
        style: const TextStyle(color: light),
        autofillHints: const [AutofillHints.username],
        textInputAction: TextInputAction.next,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: displayText,
          labelStyle: const TextStyle(
              color: inputFieldOutlineColor, fontWeight: FontWeight.bold),
          focusColor: Colors.white,
          enabledBorder: inputBoxStyle,
          disabledBorder: inputBoxStyle,
          focusedBorder: inputBoxStyle,
        ),
        cursorColor: inputFieldOutlineColor,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    this.maxWidth,
    this.passwordController,
  });

  final double? maxWidth;
  final TextEditingController? passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InputBox(
          maxWidth: maxWidth,
          displayText: "Password",
          obscureText: true,
          controller: passwordController),
    );
  }
}

class _LoginButton extends StatefulWidget {
  _LoginButton({required this.onTap, this.maxWidth, required this.status});

  bool status;
  final double? maxWidth;
  final VoidCallback onTap;

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  BoxDecoration? borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: widget.maxWidth ?? double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            widget.status
                ? const Icon(Icons.error_outline_rounded, color: errorColor)
                : Container(),
            widget.status ? const SizedBox(width: 12) : Container(),
            widget.status
                ? const Text(
                    "user name or password is wrong",
                    style: TextStyle(color: light),
                  )
                : Container(),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: "Login",
              onTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveIpButton extends StatelessWidget {
  _SaveIpButton({required this.onTap, this.maxWidth, required this.ipMessage});

  final double? maxWidth;
  final VoidCallback onTap;
  final String ipMessage;

  BoxDecoration? borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: errorColor),
            const SizedBox(width: 12),
            Text(
              ipMessage,
              style: const TextStyle(color: light),
            ),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: "Save IP",
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: themeColor,
        backgroundColor: inputFieldOutlineColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          const Icon(Icons.lock),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
