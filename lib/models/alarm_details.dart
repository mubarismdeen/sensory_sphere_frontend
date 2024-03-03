
class AlarmDetails {
  int id = 0;
  String property = "";
  String parameter = "";
  String condition = "";
  int value = 0;
  String status = "";
  String creatBy = "";
  DateTime creatDt = DateTime.now();
  String editBy = "";
  DateTime editDt = DateTime.now();

  AlarmDetails();
  // AlarmDetails({
  //   required this.id,
  //   required this.property,
  //   required this.parameter,
  //   required this.condition,
  //   required this.value,
  //   required this.status,
  //   required this.creatBy,
  //   required this.creatDt,
  //   required this.editBy,
  //   required this.editDt,
  // });


  AlarmDetails.toJson();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'property': property,
        'parameter': parameter,
        'condition': condition,
        'value': value,
        'status': status,
        'creatBy':creatBy,
        'creatDt':creatDt.toIso8601String(),
        'editBy':editBy,
        'editDt':editDt.toIso8601String(),
      };

}