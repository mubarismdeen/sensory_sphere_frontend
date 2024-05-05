import 'package:admin/constants/constants.dart';
import 'package:admin/constants/style.dart';
import 'package:admin/globalState.dart';
import 'package:admin/models/userScreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../layout.dart';
import '../../utils/common_utils.dart';

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

  @override
  String get restorationId => 'login_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_usernameController, restorationId);
    registerForRestoration(_passwordController, restorationId);
    registerForRestoration(_ipController, restorationId);
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
  });

  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  final TextEditingController? ipController;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  BoxDecoration? borderDecoration;
  bool showError = false;
  bool showLoading = false;
  String ipAddress = '';
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
    String? savedIp = prefs.getString('ipAddress');
    if (savedIp != null) {
      GlobalState.setIpAddress(savedIp);
      setState(() {
        ipAddress = savedIp;
      });
    }
  }

  Future<void> _saveIpAddress(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ip);
  }

  @override
  Widget build(BuildContext context) {
    var screenw = MediaQuery.of(context).size.width;
    final isDesktop = screenw > 700 ? true : false;
    List<Widget> listViewChildren;

      listViewChildren = [
        const _AppLogo(),
      ];

    if (ipAddress != '') {
      listViewChildren = [
          ...listViewChildren,
          _UsernameInput(
          maxWidth: 400,
          usernameController: widget.usernameController,
        ),
        const SizedBox(height: 12),
        _PasswordInput(
          maxWidth: 400,
          passwordController: widget.passwordController,
        ),
        const SizedBox(height: 12),
        _LoginButton(
          maxWidth: 400,
          onTap: () async {
            setState(() {
              showLoading = true;
            });

            try {
              List<UserScreens> screensForUser = await authorizeUserLocally(
                widget.usernameController!.text,
                widget.passwordController!.text,
              );
              if (screensForUser.isNotEmpty) {
                GlobalState.setScreensForUser(
                    widget.usernameController!.text, screensForUser.first);
                showError = false;
                _login();
              } else {
                showError = true;
              }
            } catch (e) {
              e.printError();
              showSaveFailedMessage(
                  context, "Error in establishing connection");
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
        ...listViewChildren,
        _IpInput(
          maxWidth: 400,
          ipController: widget.ipController,
        ),
        const SizedBox(height: 12),
        _SaveIpButton(
          maxWidth: 400,
          onTap: () async {
            setState(() {
              showLoading = true;
            });
            await _saveIpAddress(widget.ipController!.text.trim());
            _getSavedIpAddress();
            setState(() {
              showLoading = false;
            });
          },
        ),
      ];
    }

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: isDesktop ? Alignment.center : Alignment.topCenter,
            child: showLoading
                ? const SpinKitWave(
                    color: lightGrey,
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

class _IpInput extends StatelessWidget {
  const _IpInput({
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

  InputBox(
      {Key? key,
      this.maxWidth,
      required this.displayText,
      required this.obscureText,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: TextField(
        style: const TextStyle(color: light),
        autofillHints: const [AutofillHints.username],
        textInputAction: TextInputAction.next,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: displayText,
          labelStyle: const TextStyle(color: inputFieldOutlineColor, fontWeight: FontWeight.bold),
          focusColor: Colors.white,
          enabledBorder: inputBoxStyle,
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

class _SaveIpButton extends StatefulWidget {
  _SaveIpButton({required this.onTap, this.maxWidth });

  final double? maxWidth;
  final VoidCallback onTap;

  @override
  _SaveIpButtonState createState() => _SaveIpButtonState();
}

class _SaveIpButtonState extends State<_SaveIpButton> {
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
            const Icon(Icons.error_outline_rounded, color: errorColor),
            const SizedBox(width: 12),
            const Text(
              "IP is not set",
              style: TextStyle(color: light),
            ),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: "Save IP",
              onTap: widget.onTap,
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
