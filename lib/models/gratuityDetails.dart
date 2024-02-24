class GratuityDetails {
  int id = 0;
  String empCode = '';
  String name = '';
  String servedYears = '';
  String type = '';
  String gratuityAmount = '';
  String editBy = '';
  DateTime editDt = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();

  GratuityDetails({
    required this.id,
    required this.empCode,
    required this.name,
    required this.servedYears,
    required this.type,
    required this.gratuityAmount,
    required this.editBy,
    required this.editDt,
    required this.creatBy,
    required this.creatDt,
  });

  GratuityDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    empCode = json['empCode']??'';
    name = json['name']??'';
    servedYears = json['servedYears']??'';
    type = json['type']??'';
    gratuityAmount = json['gratuityAmount']??'';
    editBy = json['editBy']??'';
    editDt = DateTime.parse(json['editDt']);
    creatBy = json['creatBy']??'';
    creatDt = DateTime.parse(json['creatDt']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'empCode':empCode,
    'name': name,
    'servedYears': servedYears,
    'type': type,
    'gratuityAmount': gratuityAmount,
    'editBy': editBy,
    'editDt': editDt.toIso8601String(),
    'creatBy': creatBy,
    'creatDt': creatDt.toIso8601String(),
  };
}
