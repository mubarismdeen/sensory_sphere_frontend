class EmployeeDetails {
  int id = 0;
  String empCode = '';
  String name = '';
  String mobile1 = '';
  String mobile2 = '';
  String department = '';
  String status = '';
  String nationality = '';
  DateTime birthDt = DateTime.now();
  DateTime joinDt = DateTime.now();
  String editBy = '';
  DateTime editDt = DateTime.now();
  String createBy = '';
  DateTime createDt = DateTime.now();

  EmployeeDetails({
    required this.id,
    required this.empCode,
    required this.name,
    required this.mobile1,
    required this.mobile2,
    required this.department,
    required this.status,
    required this.nationality,
    required this.birthDt,
    required this.joinDt,
    required this.editBy,
    required this.editDt,
    required this.createBy,
    required this.createDt,
  });

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']>>0;
    empCode = json['empCode']??'';
    name = json['name']??'';
    mobile1 = json['mobile1']??'';
    mobile2 = json['mobile2']??'';
    department = json['department']??'';
    status = json['status']??'';
    nationality = json['nationality']??'';
    birthDt = DateTime.parse(json['birthDt']);
    joinDt = DateTime.parse(json['joinDt']);
    editBy = json['editBy']??'';
    editDt = DateTime.parse(json['editDt']);
    createBy = json['createBy']??'';
    createDt = DateTime.parse(json['createDt']);
  }
}
