import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../state/weather_notifier.dart';
import '../widgets/temperature_range_bar.dart';
import '../widgets/precipitation_bar_chart.dart';

class SevenDayForecastScreen extends StatefulWidget {
  const SevenDayForecastScreen({super.key});

  @override
  State<SevenDayForecastScreen> createState() => _SevenDayForecastScreenState();
}

class _SevenDayForecastScreenState extends State<SevenDayForecastScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final weatherState = context.watch<WeatherNotifier>().state;
    final dailyItems = weatherState.dailyForecast;
    final unit = weatherState.temperatureUnit;

    if (dailyItems.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
    }

    // Calculate weekly min and max for range bar normalization
    double weeklyMin = 100.0;
    double weeklyMax = -50.0;
    double totalTemp = 0.0;
    for (final day in dailyItems) {
      if (day.tempMin < weeklyMin) weeklyMin = day.tempMin;
      if (day.tempMax > weeklyMax) weeklyMax = day.tempMax;
      totalTemp += ((day.tempMax + day.tempMin) / 2);
    }
    final avgTemp = (totalTemp / dailyItems.length).round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        // 1. Outlook Header & Date Range
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OUTLOOK', style: AppTypography.labelSm.copyWith(color: AppColors.secondary, letterSpacing: 1.2)),
                const SizedBox(height: 2),
                Text('7-Day Forecast', style: AppTypography.headlineLg),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: AppColors.secondary, size: 16),
                  const SizedBox(width: 6),
                  Text('Oct 23 - 29', style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 2. Weekly Summary Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withOpacity(0.7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.glassBorderLight, width: 0.8),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Avg $avgTemp° • Rain expected Wed/Thu',
                  style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.insights, color: AppColors.onSurfaceVariant, size: 18),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 3. 7-Day Forecast Glass Card
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          borderRadius: BorderRadius.circular(28),
          child: Column(
            children: [
              // Column Headers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DAY & CONDITIONS', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                    Row(
                      children: [
                        Text('PRECIP', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 135,
                          child: Text(
                            'LOW / HIGH',
                            style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0x14FFFFFF), height: 16),

              // Forecast Rows
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyItems.length,
                separatorBuilder: (_, __) => const Divider(color: Color(0x0FFFFFFF), height: 12),
                itemBuilder: (context, index) {
                  final day = dailyItems[index];
                  final isExpanded = _expandedIndex == index;
                  return _buildDailyRow(
                    day: day,
                    index: index,
                    isExpanded: isExpanded,
                    weeklyMin: weeklyMin,
                    weeklyMax: weeklyMax,
                    unit: unit,
                    currentTemp: weatherState.currentWeather?.temperature,
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 4. Weekly Precipitation Probability Bar Chart Card
        PrecipitationBarChart(dailyItems: dailyItems),
      ],
    );
  }

  Widget _buildDailyRow({
    required DailyForecastEntity day,
    required int index,
    required bool isExpanded,
    required double weeklyMin,
    required double weeklyMax,
    required dynamic unit,
    double? currentTemp,
  }) {
    final condition = WeatherCodeMapper.map(day.weatherCode);

    return InkWell(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: day.isToday
              ? AppColors.surfaceContainerHighest.withOpacity(0.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day & Icon
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(condition.icon, color: condition.accentColor, size: 24),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              day.dayLabel,
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: day.isToday ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            if (day.isToday) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 85),
                          child: Text(
                            day.conditionDescription,
                            style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Precip & Range Bar
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Precip %
                    SizedBox(
                      width: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (day.precipitationProbability > 0) ...[
                            const Icon(Icons.water_drop, color: AppColors.secondary, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${day.precipitationProbability}%',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else ...[
                            Text(
                              '--',
                              style: AppTypography.labelMd.copyWith(color: AppColors.outlineVariant),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Temperature Range Bar
                    TemperatureRangeBar(
                      minTemp: day.tempMin,
                      maxTemp: day.tempMax,
                      weeklyMin: weeklyMin,
                      weeklyMax: weeklyMax,
                      currentTemp: day.isToday ? currentTemp : null,
                      unit: unit,
                    ),
                  ],
                ),
              ],
            ),

            // Expanded micro-details
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMicroDetail(Icons.water_drop, 'Precipitation', '${day.precipitationSum.toStringAsFixed(1)} mm'),
                    _buildMicroDetail(Icons.thermostat, 'Fluctuation', '${(day.tempMax - day.tempMin).round()}° span'),
                    _buildMicroDetail(Icons.cloud_queue, 'Atmosphere', day.conditionDescription),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMicroDetail(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(height: 4),
        Text(title, style: AppTypography.labelSm.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTypography.labelSm.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
