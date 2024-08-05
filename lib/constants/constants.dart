enum Screen {
  dashboard,
  employees,
  attendance,
  salaryMaster,
  salaryPayout,
  leaveSalary,
  clients,
  gratuity,
}

extension ScreenExtension on Screen {
  String get value {
    switch (this) {
      case Screen.dashboard:
        return "Dashboard";
      case Screen.employees:
        return "Employees";
      case Screen.attendance:
        return "Attendance";
      case Screen.salaryMaster:
        return "Salary Master";
      case Screen.salaryPayout:
        return "Salary Payout";
      case Screen.leaveSalary:
        return "Leave Salary";
      case Screen.clients:
        return "Clients";
      case Screen.gratuity:
        return "Gratuity";
    }
  }
}

const String successfulResponse = "true";
const String errorResponse = "error";

const String appTitle = "Sensory Sphere";

const String SMOKE_DETECTOR = "Smoke Detector";
const String FLOAT_SWITCH = "Float Switch";

const String IP_ADDRESSES = "ipAddresses";
