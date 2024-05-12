import 'package:admin/constants/controllers.dart';
import 'package:admin/models/userScreens.dart';
import 'package:admin/routes/routes.dart';

import 'api.dart';
import 'models/userDetails.dart';

class GlobalState {
  static String ipAddress = "";
  static String username = "User";
  static String userEmpCode = "1";
  static String userId = "0";
  static String firebaseToken = "";
  static bool dashboardScreenPrivilege = false;
  static bool employeeScreenPrivilege = false;
  static bool attendanceScreenPrivilege = false;
  static bool salaryMasterScreenPrivilege = false;
  static bool salaryPayoutScreenPrivilege = false;
  static bool alarmsScreenPrivilege = false;
  static bool leaveSalaryScreenPrivilege = false;
  static bool clientsScreenPrivilege = false;
  static bool gratuityScreenPrivilege = false;

  static List<String> sideMenuItems = [];

  static void setScreensForUser(
      String givenUsername, UserScreens screensForUser) {
    username = givenUsername;
    setEmployeeCodeForSession(givenUsername);
    sideMenuItems = [];
    // if(screensForUser.dashboard) {
    //   dashboardScreenPrivilege = true;
    //   sideMenuItems.add(DashboardRoute);
    // }
    if (screensForUser.employees) {
      employeeScreenPrivilege = true;
      sideMenuItems.add(DevicesRoute);
    }
    // if(screensForUser.salaryPayout) {
    //   salaryPayoutScreenPrivilege = true;
    //   sideMenuItems.add(AlarmsRoute);
    // }
    if (screensForUser.attendance) {
      attendanceScreenPrivilege = true;
      sideMenuItems.add(PropertiesRoute);
    }
    if (screensForUser.alarms) {
      alarmsScreenPrivilege = true;
      sideMenuItems.add(AlarmsRoute);
    }
    // if(screensForUser.salaryMaster) {
    //   salaryMasterScreenPrivilege = true;
    //   sideMenuItems.add(MaintenanceRoute);
    // }
    // if(screensForUser.leaveSalary) {
    //   leaveSalaryScreenPrivilege = true;
    //   sideMenuItems.add(CompanyRoute);
    // }
    // if(screensForUser.attendance) {
    //   attendanceScreenPrivilege = true;
    //   sideMenuItems.add(SupportRoute);
    // }
    // if(screensForUser.clients) {
    //   clientsScreenPrivilege = true;
    //   sideMenuItems.add(ClientsRoute);
    // }
    // if(screensForUser.gratuity) {
    //   gratuityScreenPrivilege = true;
    //   sideMenuItems.add(GratuityRoute);
    // }
    sideMenuItems.add(AuthenticationPageRoute);
    menuController.changeActiveItemTo(sideMenuItems[0]);
  }

  static Future<void> setEmployeeCodeForSession(String givenUsername) async {
    UserDetails userDetails =
        (await getUserDetailsWithUsername(givenUsername)).first;
    userEmpCode = userDetails.empCode;
  }

  static void setIpAddress(String ipAddr) {
    ipAddress = ipAddr;
  }

  static void setToken(String token) {
    firebaseToken = token;
  }
}
