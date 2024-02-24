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
  String editBy = '';
  DateTime editDt = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();

  UserScreens({required this.creatBy});

  UserScreens.fromJson(Map<String, dynamic> json) {
    id =  json['id']??"0";
    userId =  json['userId']??"0";
    dashboard =  json['dashboard']??false;
    employees =  json['employees']??false;
    attendance =  json['attendance']??false;
    salaryMaster =  json['salaryMaster']??false;
    salaryPayout =  json['salaryPayout']??false;
    leaveSalary =  json['leaveSalary']??false;
    clients =  json['clients']??false;
    gratuity =  json['gratuity']??false;
    editBy = json['editBy']??'';
    editDt = DateTime.parse(json['editDt']);
    creatBy = json['creatBy']??'';
    creatDt = DateTime.parse(json['creatDt']);
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
    'editBy': editBy,
    'editDt': editDt.toIso8601String(),
    'creatBy': creatBy,
    'creatDt': creatDt.toIso8601String(),
  };
}
