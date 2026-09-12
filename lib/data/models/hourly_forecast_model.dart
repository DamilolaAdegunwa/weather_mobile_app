import '../../domain/entities/hourly_forecast_entity.dart';

class HourlyForecastModel extends HourlyForecastEntity {
  const HourlyForecastModel({
    required super.time,
    required super.temperature,
    required super.weatherCode,
    required super.precipitationProbability,
    super.isNow,
  });

  static List<HourlyForecastModel> fromOpenMeteoJson(Map<String, dynamic> json) {
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};
    final times = hourly['time'] as List<dynamic>? ?? [];
    final temps = hourly['temperature_2m'] as List<dynamic>? ?? [];
    final codes = hourly['weather_code'] as List<dynamic>? ?? [];
    final precips = hourly['precipitation_probability'] as List<dynamic>? ?? [];

    final now = DateTime.now();
    final List<HourlyForecastModel> list = [];

    // Find closest index to current hour
    int startIndex = 0;
    for (int i = 0; i < times.length; i++) {
      try {
        final t = DateTime.parse(times[i].toString());
        if (t.isAfter(now.subtract(const Duration(minutes: 30)))) {
          startIndex = i;
          break;
        }
      } catch (_) {}
    }

    final count = (times.length - startIndex).clamp(0, 24);
    for (int i = 0; i < count; i++) {
      final idx = startIndex + i;
      final timeStr = times[idx].toString();
      final temp = (temps[idx] as num?)?.toDouble() ?? 20.0;
      final code = (codes[idx] as num?)?.toInt() ?? 0;
      final precip = (precips[idx] as num?)?.toInt() ?? 0;

      list.add(HourlyForecastModel(
        time: timeStr,
        temperature: temp,
        weatherCode: code,
        precipitationProbability: precip,
        isNow: i == 0,
      ));
    }

    return list;
  }
}
