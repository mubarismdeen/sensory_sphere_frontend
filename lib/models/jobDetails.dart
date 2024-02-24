
class JobDetails {
  int id = 0;
  String job = "";
  String narration = "";
  String assignedDate = "";
  String dueDate = "";
  int jobStatus = 0;
  int status = 1;
  String assignedTo = "";
  String creatBy = "";
  DateTime creatDt = DateTime.now();
  String editBy = "";
  DateTime editDt = DateTime.now();

  JobDetails({
    required this.id,
    required this.job,
    required this.narration,
    required this.assignedDate,
    required this.jobStatus,
    required this.status,
    required this.assignedTo,
    required this.dueDate,
    required this.creatBy,
    required this.creatDt,
    required this.editBy,
    required this.editDt,
  });

  JobDetails.toJson();

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'job': job,
        'narration': narration,
        'assignedDate': assignedDate,
        'jobStatus': jobStatus,
        'status': status,
        'assignedTo': assignedTo,
        'dueDate': dueDate,
        'creatBy':creatBy,
        'creatDt':creatDt.toIso8601String(),
        'editBy':editBy,
        'editDt':editDt.toIso8601String(),
      };

}