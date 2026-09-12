import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/solar_horizon_painter.dart';
import '../../core/utils/date_formatter.dart';

class SolarHorizonCard extends StatelessWidget {
  final String sunrise;
  final String sunset;
  final double progress;

  const SolarHorizonCard({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text('Solar Horizon', style: AppTypography.labelLg.copyWith(color: AppColors.onSurface)),
                ],
              ),
              Text('Solar Cycle', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            width: double.infinity,
            child: CustomPaint(
              painter: SolarHorizonPainter(progress: progress),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sunrise
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.vertical_align_top_rounded, color: AppColors.secondary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sunrise', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      Text(
                        DateFormatter.formatTime(sunrise),
                        style: AppTypography.labelMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              // Sunset
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Sunset', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      Text(
                        DateFormatter.formatTime(sunset),
                        style: AppTypography.labelMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.vertical_align_bottom_rounded, color: AppColors.secondaryContainer, size: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
