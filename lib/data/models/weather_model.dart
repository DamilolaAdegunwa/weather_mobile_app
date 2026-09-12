import '../../domain/entities/weather_entity.dart';
import '../../core/utils/weather_code_mapper.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.neighborhood,
    required super.country,
    required super.temperature,
    required super.apparentTemperature,
    required super.tempMax,
    required super.tempMin,
    required super.weatherCode,
    required super.isDay,
    required super.conditionText,
    required super.microTag,
    required super.telemetry,
  });

  factory WeatherModel.fromOpenMeteoJson({
    required Map<String, dynamic> forecastJson,
    Map<String, dynamic>? airQualityJson,
    String? cityName,
    String? country,
    String? neighborhood,
  }) {
    final current = forecastJson['current'] as Map<String, dynamic>? ?? {};
    final daily = forecastJson['daily'] as Map<String, dynamic>? ?? {};

    final currentTemp = (current['temperature_2m'] as num?)?.toDouble() ?? 20.0;
    final apparentTemp = (current['apparent_temperature'] as num?)?.toDouble() ?? currentTemp;
    final weatherCode = (current['weather_code'] as num?)?.toInt() ?? 1;
    final isDay = ((current['is_day'] as num?)?.toInt() ?? 1) == 1;

    // Daily min/max
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final tempMax = maxTemps.isNotEmpty ? (maxTemps.first as num).toDouble() : currentTemp + 3;
    final tempMin = minTemps.isNotEmpty ? (minTemps.first as num).toDouble() : currentTemp - 5;

    // Telemetry details
    final windSpeed = (current['wind_speed_10m'] as num?)?.toDouble() ?? 14.0;
    final windDirectionDeg = (current['wind_direction_10m'] as num?)?.toDouble() ?? 245.0;
    final windGusts = (current['wind_gusts_10m'] as num?)?.toDouble() ?? windSpeed + 7.0;
    final humidity = (current['relative_humidity_2m'] as num?)?.toInt() ?? 74;

    // Wind direction label
    final windDirection = _degreesToDirection(windDirectionDeg);

    // Dew point calculation: Td = T - ((100 - RH)/5)
    final dewPoint = currentTemp - ((100 - humidity) / 5.0);

    // UV Index from daily
    final uvList = daily['uv_index_max'] as List<dynamic>? ?? [];
    final uvIndex = uvList.isNotEmpty ? (uvList.first as num).toDouble() : 4.0;
    final uvCategory = _getUvCategory(uvIndex);

    // Air Quality Index
    final currentAir = airQualityJson?['current'] as Map<String, dynamic>? ?? {};
    final aqi = (currentAir['us_aqi'] as num?)?.toInt() ?? 38;
    final aqiStatus = _getAqiStatus(aqi);

    // Sun times
    final sunriseList = daily['sunrise'] as List<dynamic>? ?? [];
    final sunsetList = daily['sunset'] as List<dynamic>? ?? [];
    final sunrise = sunriseList.isNotEmpty ? sunriseList.first.toString() : '2026-09-12T06:42';
    final sunset = sunsetList.isNotEmpty ? sunsetList.first.toString() : '2026-09-12T19:58';

    // Solar progress estimation based on local current time
    final solarProgress = _calculateSolarProgress(sunrise, sunset);

    final conditionInfo = WeatherCodeMapper.map(weatherCode, isDay: isDay);

    final telemetry = TelemetryEntity(
      windSpeed: windSpeed,
      windDirection: windDirection,
      windDirectionDegrees: windDirectionDeg,
      windGust: windGusts,
      humidity: humidity,
      dewPoint: dewPoint,
      uvIndex: uvIndex,
      uvCategory: uvCategory,
      aqi: aqi,
      aqiStatus: aqiStatus,
      sunrise: sunrise,
      sunset: sunset,
      solarProgress: solarProgress,
    );

    return WeatherModel(
      cityName: cityName ?? 'San Francisco',
      neighborhood: neighborhood ?? 'Financial District',
      country: country ?? 'United States',
      temperature: currentTemp,
      apparentTemperature: apparentTemp,
      tempMax: tempMax,
      tempMin: tempMin,
      weatherCode: weatherCode,
      isDay: isDay,
      conditionText: conditionInfo.description,
      microTag: conditionInfo.microTag,
      telemetry: telemetry,
    );
  }

  static String _degreesToDirection(double degrees) {
    const directions = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
    final index = ((degrees + 11.25) % 360 / 22.5).floor();
    return directions[index];
  }

  static String _getUvCategory(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  static String _getAqiStatus(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    return 'Hazardous';
  }

  static double _calculateSolarProgress(String sunriseStr, String sunsetStr) {
    try {
      final now = DateTime.now();
      final sunrise = DateTime.parse(sunriseStr);
      final sunset = DateTime.parse(sunsetStr);

      if (now.isBefore(sunrise)) return 0.0;
      if (now.isAfter(sunset)) return 1.0;

      final totalDuration = sunset.difference(sunrise).inMinutes;
      if (totalDuration <= 0) return 0.5;
      final elapsed = now.difference(sunrise).inMinutes;
      return (elapsed / totalDuration).clamp(0.0, 1.0);
    } catch (_) {
      return 0.65;
    }
  }
}
