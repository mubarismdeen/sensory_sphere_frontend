class SalaryMaster {
  int id;
  String empCode;
  double salary;
  double nOtr;
  double sOtr;
  double overseas;
  double anchorage;
  String editBy;
  DateTime editDt;
  String creatBy;
  DateTime creatDt;
  int status = 1;

  SalaryMaster({
    required this.id,
    required this.empCode,
    required this.salary,
    required this.nOtr,
    required this.sOtr,
    required this.overseas,
    required this.anchorage,
    required this.editBy,
    required this.editDt,
    required this.creatBy,
    required this.creatDt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'empCode': empCode,
    'salary': salary,
    'nOtr': nOtr,
    'sOtr': sOtr,
    'overseas': overseas,
    'anchorage': anchorage,
    'editBy': editBy,
    'editDt': editDt.toIso8601String(),
    'creatBy': creatBy,
    'creatDt': creatDt.toIso8601String(),
    'status': status,
  };
}
