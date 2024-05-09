class UserScreens {
  int id = 0;
  int userId = 0;
  bool dashboard = false;
  bool employees = false;
  bool attendance = false;
  bool salaryMaster = false;
  bool salaryPayout = false;
  bool leaveSalary = false;
  bool clients = false;
  bool gratuity = false;
  bool alarms = false;
  String editBy = '';
  DateTime editDt = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();

  UserScreens({required this.creatBy});

  UserScreens.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "0";
    userId = json['userId'] ?? "0";
    dashboard = json['dashboard'] ?? false;
    employees = json['employees'] ?? false;
    attendance = json['attendance'] ?? false;
    salaryMaster = json['salaryMaster'] ?? false;
    salaryPayout = json['salaryPayout'] ?? false;
    leaveSalary = json['leaveSalary'] ?? false;
    clients = json['clients'] ?? false;
    gratuity = json['gratuity'] ?? false;
    alarms = json['alarms'] ?? false;
    editBy = json['editBy'] ?? '';
    editDt = json['editDate'] == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(json['editDate']);
    creatBy = json['createBy'] ?? '';
    creatDt = DateTime.fromMillisecondsSinceEpoch(json['createDate'] ?? 0);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'dashboard': dashboard,
        'employees': employees,
        'attendance': attendance,
        'salaryMaster': salaryMaster,
        'salaryPayout': salaryPayout,
        'leaveSalary': leaveSalary,
        'clients': clients,
        'gratuity': gratuity,
        'alarms': alarms,
        'editBy': editBy,
        'editDate': editDt.millisecondsSinceEpoch,
        'createBy': creatBy,
        'createDate': creatDt.millisecondsSinceEpoch,
      };
}
