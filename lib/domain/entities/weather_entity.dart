class TelemetryEntity {
  final double windSpeed; // mph
  final String windDirection; // WSW
  final double windDirectionDegrees;
  final double windGust; // mph
  final int humidity; // percentage
  final double dewPoint; // celsius
  final double uvIndex;
  final String uvCategory; // Low, Moderate, High, Very High
  final int aqi; // Air Quality Index
  final String aqiStatus; // Good, Moderate, Unhealthy
  final String sunrise; // ISO time
  final String sunset; // ISO time
  final double solarProgress; // 0.0 to 1.0

  const TelemetryEntity({
    required this.windSpeed,
    required this.windDirection,
    required this.windDirectionDegrees,
    required this.windGust,
    required this.humidity,
    required this.dewPoint,
    required this.uvIndex,
    required this.uvCategory,
    required this.aqi,
    required this.aqiStatus,
    required this.sunrise,
    required this.sunset,
    required this.solarProgress,
  });
}

class WeatherEntity {
  final String cityName;
  final String neighborhood;
  final String country;
  final double temperature; // celsius
  final double apparentTemperature; // feels like celsius
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final bool isDay;
  final String conditionText;
  final String microTag;
  final TelemetryEntity telemetry;

  const WeatherEntity({
    required this.cityName,
    required this.neighborhood,
    required this.country,
    required this.temperature,
    required this.apparentTemperature,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.isDay,
    required this.conditionText,
    required this.microTag,
    required this.telemetry,
  });
}
