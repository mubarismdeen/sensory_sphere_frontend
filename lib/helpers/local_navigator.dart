import 'package:admin/constants/controllers.dart';
import 'package:flutter/widgets.dart';

import '../globalState.dart';
import '../routes/router.dart';

Navigator localNavigator() => Navigator(
  key: navigationController.navigationkey,
  initialRoute: GlobalState.sideMenuItems.first,
  onGenerateRoute: generateRoute,
);