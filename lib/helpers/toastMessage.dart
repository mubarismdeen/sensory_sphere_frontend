import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

late FToast fToast ;

@override
void initState() {
  // super.initState();
  fToast = FToast();
  // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
  fToast.init(context as BuildContext);
}