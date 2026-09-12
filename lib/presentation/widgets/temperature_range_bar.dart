import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/unit_converter.dart';

class TemperatureRangeBar extends StatelessWidget {
  final double minTemp;
  final double maxTemp;
  final double weeklyMin;
  final double weeklyMax;
  final double? currentTemp;
  final TemperatureUnit unit;

  const TemperatureRangeBar({
    super.key,
    required this.minTemp,
    required this.maxTemp,
    required this.weeklyMin,
    required this.weeklyMax,
    this.currentTemp,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final range = (weeklyMax - weeklyMin).clamp(1.0, 100.0);
    final leftFactor = ((minTemp - weeklyMin) / range).clamp(0.0, 0.85);
    final rightFactor = ((maxTemp - weeklyMin) / range).clamp(leftFactor + 0.1, 1.0);
    final widthFactor = (rightFactor - leftFactor).clamp(0.1, 1.0);

    return SizedBox(
      width: 135,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Min Temp Label
          SizedBox(
            width: 28,
            child: Text(
              UnitConverter.formatTemperature(minTemp, unit),
              style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),

          // Range Progress Bar
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Range Gradient Bar
                  Positioned.fill(
                    child: FractionallySizedBox(
                      alignment: Alignment(leftFactor * 2 - 1, 0),
                      widthFactor: widthFactor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.secondaryContainer,
                              AppColors.primary,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Current Temp Pip Indicator (if provided)
                  if (currentTemp != null) ...[
                    Builder(
                      builder: (context) {
                        final pipPos = ((currentTemp! - weeklyMin) / range).clamp(0.05, 0.95);
                        return Align(
                          alignment: Alignment(pipPos * 2 - 1, 0),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.textPrimary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Max Temp Label
          SizedBox(
            width: 28,
            child: Text(
              UnitConverter.formatTemperature(maxTemp, unit),
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
