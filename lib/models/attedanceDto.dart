class AttendanceDto {
  int id = 0;
  String employeeId = '';
  String employeeName = '';
  String molId = '';
  double totalAttendance = 0.0;
  double totalOffAndSickDays = 0.0;
  double totalLossOfPaymentDays = 0.0;
  double totalNormalOvertimeHours = 0.0;
  double totalSpecialOvertimeHours = 0.0;
  double totalOverseasDays = 0.0;
  double totalAnchorageDays = 0.0;

  AttendanceDto(
      {required this.id,
        required this.employeeId,
        required this.employeeName,
        required this.molId,
        required this.totalAttendance,
        required this.totalOffAndSickDays,
        required this.totalLossOfPaymentDays,
        required this.totalNormalOvertimeHours,
        required this.totalSpecialOvertimeHours,
        required this.totalOverseasDays,
        required this.totalAnchorageDays});

  AttendanceDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    employeeId = json['empCode'] ?? 'NULL';
    employeeName = json['name'] ?? 'NULL';
    molId = json['molId'] ?? 'NULL';
    totalAttendance = json['attendance'] ?? 0.0;
    totalOffAndSickDays = json['offDays'] ?? 0.0;
    totalLossOfPaymentDays = json['lop'] ?? 0.0;
    totalNormalOvertimeHours = json['novt'] ?? 0.0;
    totalSpecialOvertimeHours = json['sovt'] ?? 0.0;
    totalOverseasDays = json['overseas'] ?? 0.0;
    totalAnchorageDays = json['anchorage'] ?? 0.0;
  }
}
