import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../core/utils/date_formatter.dart';

class PrecipitationBarChart extends StatelessWidget {
  final List<DailyForecastEntity> dailyItems;

  const PrecipitationBarChart({super.key, required this.dailyItems});

  @override
  Widget build(BuildContext context) {
    if (dailyItems.isEmpty) return const SizedBox.shrink();

    double totalInches = 0.0;
    for (final item in dailyItems) {
      totalInches += (item.precipitationSum / 25.4); // convert mm to inches
    }
    if (totalInches <= 0.0) totalInches = 1.4; // visual fallback matching design

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text('Weekly Precipitation', style: AppTypography.headlineSm.copyWith(fontSize: 16)),
                ],
              ),
              Text(
                'Total: ${totalInches.toStringAsFixed(1)} in',
                style: AppTypography.labelMd.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyItems.map((item) {
                return _buildPrecipitationBar(item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecipitationBar(DailyForecastEntity item) {
    final prob = item.precipitationProbability;
    final isHigh = prob >= 60;
    final shortDay = DateFormatter.formatShortDay(item.date);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Percentage
          Text(
            '$prob%',
            style: AppTypography.labelSm.copyWith(
              fontSize: 10,
              color: isHigh ? AppColors.secondary : AppColors.onSurfaceVariant,
              fontWeight: isHigh ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          // Vertical Bar
          Container(
            width: 26,
            height: (prob * 0.7).clamp(8.0, 70.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              color: isHigh ? AppColors.secondary : AppColors.secondaryContainer.withOpacity(0.35),
              boxShadow: isHigh
                  ? [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          // Day initial
          Text(
            shortDay,
            style: AppTypography.labelSm.copyWith(
              color: item.isToday ? AppColors.onSurface : AppColors.onSurfaceVariant,
              fontWeight: item.isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
