class DailyForecastEntity {
  final String date; // ISO date e.g. 2026-09-12
  final String dayLabel; // "Today", "Tue, 24", etc.
  final int weatherCode;
  final String conditionDescription;
  final double tempMax;
  final double tempMin;
  final int precipitationProbability;
  final double precipitationSum; // mm
  final bool isToday;

  const DailyForecastEntity({
    required this.date,
    required this.dayLabel,
    required this.weatherCode,
    required this.conditionDescription,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbability,
    required this.precipitationSum,
    this.isToday = false,
  });
}
