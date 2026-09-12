import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.id,
    required super.name,
    required super.country,
    super.admin1,
    required super.latitude,
    required super.longitude,
    super.currentTemp,
    super.tempMax,
    super.tempMin,
    super.conditionText,
    super.localTime,
    super.isSaved,
  });

  factory LocationModel.fromGeocodingJson(Map<String, dynamic> json) {
    return LocationModel(
      id: (json['id'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      name: json['name']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      admin1: json['admin1']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'admin1': admin1,
      'latitude': latitude,
      'longitude': longitude,
      'currentTemp': currentTemp,
      'tempMax': tempMax,
      'tempMin': tempMin,
      'conditionText': conditionText,
      'localTime': localTime,
      'isSaved': isSaved,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      country: json['country'] as String,
      admin1: json['admin1'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      currentTemp: (json['currentTemp'] as num?)?.toDouble(),
      tempMax: (json['tempMax'] as num?)?.toDouble(),
      tempMin: (json['tempMin'] as num?)?.toDouble(),
      conditionText: json['conditionText'] as String?,
      localTime: json['localTime'] as String?,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }
}
