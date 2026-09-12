import '../../domain/entities/daily_forecast_entity.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../core/utils/date_formatter.dart';

class DailyForecastModel extends DailyForecastEntity {
  const DailyForecastModel({
    required super.date,
    required super.dayLabel,
    required super.weatherCode,
    required super.conditionDescription,
    required super.tempMax,
    required super.tempMin,
    required super.precipitationProbability,
    required super.precipitationSum,
    super.isToday,
  });

  static List<DailyForecastModel> fromOpenMeteoJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>? ?? {};
    final times = daily['time'] as List<dynamic>? ?? [];
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final codes = daily['weather_code'] as List<dynamic>? ?? [];
    final precipSums = daily['precipitation_sum'] as List<dynamic>? ?? [];
    final precipProbs = daily['precipitation_probability_max'] as List<dynamic>? ?? [];

    final List<DailyForecastModel> list = [];
    final count = times.length.clamp(0, 7);

    for (int i = 0; i < count; i++) {
      final dateStr = times[i].toString();
      final maxT = (maxTemps[i] as num?)?.toDouble() ?? 22.0;
      final minT = (minTemps[i] as num?)?.toDouble() ?? 14.0;
      final code = (codes[i] as num?)?.toInt() ?? 0;
      final precipSum = (precipSums.isNotEmpty && i < precipSums.length)
          ? (precipSums[i] as num?)?.toDouble() ?? 0.0
          : 0.0;
      final precipProb = (precipProbs.isNotEmpty && i < precipProbs.length)
          ? (precipProbs[i] as num?)?.toInt() ?? 0
          : 0;

      final condition = WeatherCodeMapper.map(code);
      final dayLabel = DateFormatter.formatDayOfWeek(dateStr);

      list.add(DailyForecastModel(
        date: dateStr,
        dayLabel: dayLabel,
        weatherCode: code,
        conditionDescription: condition.description,
        tempMax: maxT,
        tempMin: minT,
        precipitationProbability: precipProb,
        precipitationSum: precipSum,
        isToday: i == 0,
      ));
    }

    return list;
  }
}
