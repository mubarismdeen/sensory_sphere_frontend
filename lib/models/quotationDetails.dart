
class QuotationDetails {
  int id = 0;
  int clientId = 0;
  String narration = "";
  String name = "";
  String date = "";
  int invoiceNo = 0;
  int poRefNo = 0;
  int reportNo = 0;
  double invoiceAmt = 0.0;
  int poNo = 0;
  int poStatus = 0;
  int invStatus = 0;
  int type = 0;
  String dueDate = "";
  String creatBy = "";
  DateTime creatDt = DateTime.now();
  String editBy = "";
  DateTime editDt = DateTime.now();
  int status = 1;

  QuotationDetails({
    required this.id,
    required this.clientId,
    required this.narration,
    required this.name,
    required this.date,
    required this.invoiceNo,
    required this.poNo,
    required this.poRefNo,
    required this.reportNo,
    required this.invoiceAmt,
    required this.poStatus,
    required this.invStatus,
    required this.type,
    required this.dueDate,
    required this.creatBy,
    required this.creatDt,
    required this.editBy,
    required this.editDt,
  });

  QuotationDetails.toJson();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'clientId': clientId,
        'narration': narration,
        'name': name,
        'date': date,
        'poNo' : poNo,
        'poRefNo' : poRefNo,
        'reportNo' : reportNo,
        'invoiceNo': invoiceNo,
        'invoiceAmt' : invoiceAmt,
        'poStatus': poStatus,
        'invStatus': invStatus,
        'type': type,
        'dueDate': dueDate,
        'creatBy':creatBy,
        'creatDt':creatDt.toIso8601String(),
        'editBy':editBy,
        'editDt':editDt.toIso8601String(),
        'status': status,
      };
}