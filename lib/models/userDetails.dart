class UserDetails {
  int id = 0;
  int userCd = 0;
  String name = '';
  String password = '';
  String empCode = '';
  String editBy = '';
  DateTime editDt = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();

  UserDetails({required this.creatBy, required this.empCode});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id =  json['id']??"0";
    userCd =  json['userCd']??"0";
    name =  json['name']??"";
    password =  json['password']??"";
    empCode =  json['empCode']??"";
    editBy = json['editBy']??'';
    editDt = DateTime.parse(json['editDt']);
    creatBy = json['creatBy']??'';
    creatDt = DateTime.parse(json['creatDt']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userCd': userCd,
    'name': name,
    'password': password,
    'empCode': empCode,
    'editBy': editBy,
    'editDt': editDt.toIso8601String(),
    'creatBy': creatBy,
    'creatDt': creatDt.toIso8601String(),
  };
}
