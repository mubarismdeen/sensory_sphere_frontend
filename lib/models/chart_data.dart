class ChartData {
  final String xCoordinate;
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;

  ChartData({
    required this.xCoordinate,
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      xCoordinate: json['xCoordinate'] ?? "",
      suctionPressure: json['suctionPressure']?.toDouble() ?? 0.0,
      dischargePressure: json['dischargePressure']?.toDouble() ?? 0.0,
      oxygenAPressure: json['oxygenAPressure']?.toDouble() ?? 0.0,
      oxygenBPressure: json['oxygenBPressure']?.toDouble() ?? 0.0,
      ambientTemperature: json['ambientTemperature']?.toDouble() ?? 0.0,
      totalCurrent: json['totalCurrent']?.toDouble() ?? 0.0,
    );
  }
}
