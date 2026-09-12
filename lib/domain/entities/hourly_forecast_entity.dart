class HourlyForecastEntity {
  final String time; // ISO string e.g. 2026-09-12T14:00
  final double temperature; // celsius
  final int weatherCode;
  final int precipitationProbability; // 0 to 100%
  final bool isNow;

  const HourlyForecastEntity({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.precipitationProbability,
    this.isNow = false,
  });
}
