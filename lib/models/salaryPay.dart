class SalaryPay{
  int id = 0;
  String empCode = '';
  String name = '';
  double nOtr = 0;
  double sOtr = 0;
  double overseas = 0;
  double anchorage = 0;
  double total = 0;
  double totalPaid = 0;
  double due = 0;
  double attendance = 0;
  double basic = 0;
  double currentDue = 0;
  bool paid = false;
  String editBy = '';
  DateTime editDt = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();

  SalaryPay({
    required this.id,
    required this.empCode,
    required this.name,
    required this.nOtr,
    required this.sOtr,
    required this.overseas,
    required this.anchorage,
    required this.editBy,
    required this.editDt,
    required this.creatBy,
    required this.creatDt,
    required this.total,
    required this.totalPaid,
    required this.due,
    required this.attendance,
    required this.basic,
    required this.currentDue,
    required this.paid,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'empCode': empCode,
    'nOtr': nOtr,
    'sOtr': sOtr,
    'overseas': overseas,
    'anchorage': anchorage,
    'editBy': editBy,
    'editDt': editDt.toIso8601String(),
    'creatBy': creatBy,
    'creatDt': creatDt.toIso8601String(),
  };

  SalaryPay.fromJson(Map<String, dynamic> json) {
    id= json['id'] ?? 0;
    empCode = json['empCode']??'';
    name = json['name']??'';
    nOtr = json['novt']??0.0;
    sOtr = json['sovt']??0.0;
    overseas = json['overseas']??0.0;
    anchorage = json['anchorage']??0.0;
    editBy = json['editBy']??'';
    editDt = DateTime.parse(json['editDt']);
    creatBy = json['creatBy']??'';
    creatDt = DateTime.parse(json['creatDt']);
    total = json['total']??0.0;
    totalPaid = json['totalPaid']??0.0;
    due = json['due']??0.0;
    attendance = json['attendance']??0.0;
    basic = json['basic']??0.0;
    currentDue = json['currentDue']??0.0;
    paid = json['paid']??false;
  }
}
