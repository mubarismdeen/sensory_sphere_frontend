
class DocDetails {
  int id = 0;
  String narration = "";
  String empCode = "";
  int docid = 0;
  DateTime dueDate = DateTime.now();
  DateTime renewedDate = DateTime.now();
  String creatBy = '';
  DateTime creatDt = DateTime.now();
  String editBy = '';
  DateTime editDt = DateTime.now();
  int status = 1;

  DocDetails({
    required this.id,
    required this.narration,
    required this.empCode,
    required this.docid,
    required this.dueDate,
    required this.renewedDate,
    required this.creatBy,
    required this.creatDt,
    required this.editBy,
    required this.editDt,
  });

  DocDetails.toJson();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'narration': narration,
        'empCode': empCode,
        'docid': docid,
        'dueDate': dueDate.toIso8601String(),
        'renewedDate':renewedDate.toIso8601String(),
        'creatBy':creatBy,
        'creatDt':creatDt.toIso8601String(),
        'editBy':editBy,
        'editDt':editDt.toIso8601String(),
        'status': status,
      };

  DocDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    narration = json['narration'] ?? "";
    empCode = json['empCode'] ?? "";
    docid = json['docid'] ?? 0;
    dueDate = json['dueDate'] ?? DateTime.now();
    renewedDate = json['renewedDate'] ?? DateTime.now();
    creatBy = json['creatBy'] ?? '';
    creatDt = json['creatDt'] ?? DateTime.now();
    editBy = json['editBy'] ?? '';
    editDt = json['editDt'] ?? DateTime.now();
    status = json['status'] ?? 1;
  }
}