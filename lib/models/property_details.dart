class PropertyDetails {
  int id = 0;
  String name = "";
  String status = "";
  String createBy = "";
  DateTime createDate = DateTime.now();
  String editBy = "";
  DateTime? editDate;

  PropertyDetails();

  PropertyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    status = json['status'] ?? "";
    createBy = json['createBy'] ?? '';
    createDate = DateTime.fromMillisecondsSinceEpoch(json['createDate'] ?? 0);
    editBy = json['editBy'] ?? '';
    editDate = json['editDate'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['editDate']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'createBy': createBy,
        'createDate': createDate.millisecondsSinceEpoch,
        'editBy': editBy,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
      };
}
