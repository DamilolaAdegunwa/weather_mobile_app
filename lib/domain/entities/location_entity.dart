class LocationEntity {
  final int id;
  final String name;
  final String country;
  final String? admin1; // State or region
  final double latitude;
  final double longitude;
  final double? currentTemp; // celsius
  final double? tempMax;
  final double? tempMin;
  final String? conditionText;
  final String? localTime;
  final bool isSaved;

  const LocationEntity({
    required this.id,
    required this.name,
    required this.country,
    this.admin1,
    required this.latitude,
    required this.longitude,
    this.currentTemp,
    this.tempMax,
    this.tempMin,
    this.conditionText,
    this.localTime,
    this.isSaved = false,
  });

  LocationEntity copyWith({
    int? id,
    String? name,
    String? country,
    String? admin1,
    double? latitude,
    double? longitude,
    double? currentTemp,
    double? tempMax,
    double? tempMin,
    String? conditionText,
    String? localTime,
    bool? isSaved,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      admin1: admin1 ?? this.admin1,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentTemp: currentTemp ?? this.currentTemp,
      tempMax: tempMax ?? this.tempMax,
      tempMin: tempMin ?? this.tempMin,
      conditionText: conditionText ?? this.conditionText,
      localTime: localTime ?? this.localTime,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
