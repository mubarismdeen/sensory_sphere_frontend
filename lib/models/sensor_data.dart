class SensorData {
  final int id;
  final DateTime timestamp;
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;
  final bool isMotorOn;

  SensorData({
    required this.id,
    required this.timestamp,
    required this.suctionPressure,
    required this.dischargePressure,
    required this.oxygenAPressure,
    required this.oxygenBPressure,
    required this.ambientTemperature,
    required this.totalCurrent,
    required this.isMotorOn
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] ?? 0,
      suctionPressure: json['suctionPressure']?.toDouble() ?? 0.0,
      dischargePressure: json['dischargePressure']?.toDouble() ?? 0.0,
      oxygenAPressure: json['oxygenAPressure']?.toDouble() ?? 0.0,
      oxygenBPressure: json['oxygenBPressure']?.toDouble() ?? 0.0,
      ambientTemperature: json['ambientTemperature']?.toDouble() ?? 0.0,
      totalCurrent: json['totalCurrent']?.toDouble() ?? 0.0,
      isMotorOn: json['motorOn'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : DateTime.now(),
    );
  }
}
