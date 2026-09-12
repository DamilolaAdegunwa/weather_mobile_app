import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/utils/date_formatter.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecastEntity> hourlyItems;
  final TemperatureUnit unit;

  const HourlyForecastList({
    super.key,
    required this.hourlyItems,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.secondary, size: 18),
                  const SizedBox(width: 6),
                  Text('Hourly Outlook', style: AppTypography.labelLg.copyWith(color: AppColors.onSurface)),
                ],
              ),
              Text('Next 24 Hours', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 134,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: hourlyItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = hourlyItems[index];
              return _buildHourlyCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyCard(HourlyForecastEntity item) {
    final condition = WeatherCodeMapper.map(item.weatherCode);
    final timeLabel = item.isNow ? 'Now' : DateFormatter.formatHour(item.time);
    final tempStr = UnitConverter.formatTemperature(item.temperature, unit);

    return Container(
      width: 70,
      height: 134,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: item.isNow
            ? AppColors.secondary.withOpacity(0.18)
            : AppColors.surfaceContainerHigh.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isNow ? AppColors.secondary : AppColors.glassBorderLight,
          width: item.isNow ? 1.5 : 0.8,
        ),
        boxShadow: item.isNow
            ? [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeLabel,
            style: AppTypography.labelSm.copyWith(
              color: item.isNow ? AppColors.secondary : AppColors.onSurfaceVariant,
              fontWeight: item.isNow ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Icon(
            condition.icon,
            color: item.isNow ? AppColors.secondary : condition.accentColor,
            size: 24,
          ),
          Text(
            tempStr,
            style: AppTypography.labelLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Precipitation Badge
          if (item.isNow)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Sunny',
                style: AppTypography.labelSm.copyWith(
                  fontSize: 9,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (item.precipitationProbability > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${item.precipitationProbability}%',
                style: AppTypography.labelSm.copyWith(
                  fontSize: 9,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              '--',
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                color: AppColors.outlineVariant,
              ),
            ),
        ],
      ),
    );
  }
}
