class AlarmDetails {
  int id = 0;
  String property = "";
  String parameter = "";
  String condition = "";
  double value = 0;
  String status = "";
  String createBy = "";
  DateTime createDate = DateTime.now();
  String editBy = "";
  DateTime? editDate;

  AlarmDetails();

  AlarmDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    property = json['property'] ?? "";
    parameter = json['parameter'] ?? "";
    condition = json['condition'] ?? "";
    value = json['value'] ?? 0;
    status = json['status'] ?? "";
    createBy = json['createBy'] ?? '';
    createDate = DateTime.fromMillisecondsSinceEpoch(json['createDate'] ?? 0);
    editBy = json['editBy'] ?? '';
    editDate = json['editDate'] == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(json['editDate']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'property': property,
        'parameter': parameter,
        'condition': condition,
        'value': value,
        'status': status,
        'createBy': createBy,
        'createDate': createDate.millisecondsSinceEpoch,
        'editBy': editBy,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
      };
}
