import 'package:intl/intl.dart';

class AttendanceModel {
  int id;
  String empCode;
  double attendance;
  double offdays;
  double lop;
  double novt;
  double sovt;
  double overseas;
  double anchorage;
  String date;
  String editBy;
  DateTime editDt;
  String creatBy;
  DateTime creatDt;

  AttendanceModel({
    required this.id,
    required this.empCode,
    required this.attendance,
    required this.offdays,
    required this.lop,
    required this.novt,
    required this.sovt,
    required this.overseas,
    required this.anchorage,
    required this.date,
    required this.editBy,
    required this.editDt,
    required this.creatBy,
    required this.creatDt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['empCode'] = empCode;
    data['attendance'] = attendance;
    data['offdays'] = offdays;
    data['lop'] = lop;
    data['novt'] = novt;
    data['sovt'] = sovt;
    data['overseas'] = overseas;
    data['anchorage'] = anchorage;
    data['date'] = date;
    data['editBy'] = editBy;
    data['editDt'] = DateFormat('yyyy-MM-dd HH:mm').format(editDt);
    data['creatBy'] = creatBy;
    data['creatDt'] = DateFormat('yyyy-MM-dd HH:mm').format(creatDt);
    return data;
  }
}
