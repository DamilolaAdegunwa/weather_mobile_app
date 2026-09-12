import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../../domain/entities/weather_entity.dart';
import '../../core/utils/unit_converter.dart';

class BentoTelemetryGrid extends StatelessWidget {
  final TelemetryEntity telemetry;
  final TemperatureUnit unit;

  const BentoTelemetryGrid({
    super.key,
    required this.telemetry,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.analytics_outlined, color: AppColors.secondary, size: 18),
              const SizedBox(width: 6),
              Text(
                'Environmental Telemetry',
                style: AppTypography.labelLg.copyWith(color: AppColors.onSurface),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.05,
          children: [
            _buildWindTile(),
            _buildHumidityTile(),
            _buildUvTile(),
            _buildAqiTile(),
          ],
        ),
      ],
    );
  }

  Widget _buildWindTile() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WIND', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
              const Icon(Icons.air, color: AppColors.secondary, size: 20),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${telemetry.windSpeed.round()}',
                    style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
                  ),
                  Text(
                    'mph ${telemetry.windDirection}',
                    style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
              // Tactile Compass Dial
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: (telemetry.windDirectionDegrees * math.pi / 180),
                    child: const Icon(
                      Icons.navigation,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Gusts peaking at ${telemetry.windGust.round()} mph',
            style: AppTypography.labelSm.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityTile() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('HUMIDITY', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
              const Icon(Icons.water_drop_outlined, color: AppColors.primary, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${telemetry.humidity}%',
                style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 6,
                  color: AppColors.surfaceContainerLowest,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (telemetry.humidity / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'The dew point is ${UnitConverter.formatTemperature(telemetry.dewPoint, unit)}',
            style: AppTypography.labelSm.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUvTile() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('UV INDEX', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
              const Icon(Icons.wb_twilight_rounded, color: AppColors.secondary, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${telemetry.uvIndex.round()}',
                    style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    telemetry.uvCategory,
                    style: AppTypography.labelMd.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Multi-spectrum rail
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.secondary,
                          AppColors.secondaryContainer,
                          AppColors.tertiaryContainer,
                        ],
                      ),
                    ),
                  ),
                  FractionalTranslation(
                    translation: Offset((telemetry.uvIndex / 11.0).clamp(0.0, 0.9) * 8, 0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black45, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Moderate shade until 4:30 PM',
            style: AppTypography.labelSm.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAqiTile() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AIR QUALITY', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
              const Icon(Icons.filter_drama, color: AppColors.secondary, size: 20),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${telemetry.aqi}',
                    style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
                  ),
                  Text(
                    'AQI • ${telemetry.aqiStatus}',
                    style: AppTypography.labelSm.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
              // Glowing Pulse Indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Air purity is optimal today',
            style: AppTypography.labelSm.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
