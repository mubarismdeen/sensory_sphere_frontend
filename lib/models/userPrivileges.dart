class UserPrivileges {

  int id = 0;
  int userId = 0;
  String privilegeName = "";
  bool viewPrivilege = false;
  bool addPrivilege = false;
  bool editPrivilege = false;
  bool deletePrivilege = false;
  String editBy = '';
  DateTime editDt = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();

  UserPrivileges({required this.userId, required this.privilegeName, required this.creatBy, required this.creatDt});

  UserPrivileges.fromJson(Map<String, dynamic> json) {
    id =  json['id']??"0";
    userId =  json['userId']??"0";
    privilegeName =  json['privilegeName']??"";
    viewPrivilege =  json['viewPrivilege']??false;
    addPrivilege =  json['addPrivilege']??false;
    editPrivilege =  json['editPrivilege']??false;
    deletePrivilege =  json['deletePrivilege']??false;
    editBy = json['editBy']??'';
    editDt = DateTime.parse(json['editDt']);
    creatBy = json['creatBy']??'';
    creatDt = DateTime.parse(json['creatDt']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'privilegeName': privilegeName,
    'viewPrivilege': viewPrivilege,
    'addPrivilege': addPrivilege,
    'editPrivilege': editPrivilege,
    'deletePrivilege': deletePrivilege,
    'editBy': editBy,
    'editDt': editDt.toIso8601String(),
    'creatBy': creatBy,
    'creatDt': creatDt.toIso8601String(),
  };

}
