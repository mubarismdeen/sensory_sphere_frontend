class SensorData {
  final int id;
  final int propertyId;
  final DateTime timestamp;
  final double suctionPressure;
  final double dischargePressure;
  final double oxygenAPressure;
  final double oxygenBPressure;
  final double ambientTemperature;
  final double totalCurrent;
  final bool isMotorOn;
  final bool isMotorLoading;
  final bool isAutoMode;
  final bool floatState;
  final bool smokeState;
  final String latitude;
  final String longitude;

  SensorData(
      {required this.id,
      required this.propertyId,
      required this.timestamp,
      required this.suctionPressure,
      required this.dischargePressure,
      required this.oxygenAPressure,
      required this.oxygenBPressure,
      required this.ambientTemperature,
      required this.totalCurrent,
      required this.isMotorOn,
      required this.isMotorLoading,
      required this.isAutoMode,
      required this.floatState,
      required this.smokeState,
      required this.latitude,
      required this.longitude});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] ?? 0,
      propertyId: json['propertyId'] ?? 0,
      suctionPressure: json['suctionPressure']?.toDouble() ?? 0.0,
      dischargePressure: json['dischargePressure']?.toDouble() ?? 0.0,
      oxygenAPressure: json['oxygenAPressure']?.toDouble() ?? 0.0,
      oxygenBPressure: json['oxygenBPressure']?.toDouble() ?? 0.0,
      ambientTemperature: json['ambientTemperature']?.toDouble() ?? 0.0,
      totalCurrent: json['totalCurrent']?.toDouble() ?? 0.0,
      isMotorOn: json['motorOn'] ?? false,
      isMotorLoading: json['motorLoading'] ?? false,
      isAutoMode: json['autoMode'] ?? false,
      floatState: json['floatState'] ?? false,
      smokeState: json['smokeState'] ?? false,
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : DateTime.now(),
    );
  }
}
