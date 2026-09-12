import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../state/weather_notifier.dart';
import '../state/weather_state.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/bento_telemetry_grid.dart';
import '../widgets/solar_horizon_card.dart';

class TodayForecastScreen extends StatelessWidget {
  final VoidCallback onOpenRadar;

  const TodayForecastScreen({super.key, required this.onOpenRadar});

  @override
  Widget build(BuildContext context) {
    final weatherState = context.watch<WeatherNotifier>().state;

    if (weatherState.status == WeatherStatus.loading && weatherState.currentWeather == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      );
    }

    final weather = weatherState.currentWeather;
    if (weather == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 54, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('No Weather Data Available', style: AppTypography.headlineSm),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<WeatherNotifier>().loadInitialData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final unit = weatherState.temperatureUnit;
    final condition = WeatherCodeMapper.map(weather.weatherCode, isDay: weather.isDay);
    final tempValue = UnitConverter.getTemperatureValue(weather.temperature, unit);
    final highStr = UnitConverter.formatTemperature(weather.tempMax, unit);
    final lowStr = UnitConverter.formatTemperature(weather.tempMin, unit);
    final feelsLikeStr = UnitConverter.formatTemperature(weather.apparentTemperature, unit);

    return RefreshIndicator(
      color: AppColors.secondary,
      backgroundColor: AppColors.surfaceContainerHigh,
      onRefresh: () => context.read<WeatherNotifier>().refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          // 1. Dynamic Atmosphere Living Backdrop Hero Card
          _buildHeroLivingBackdrop(
            weather: weather,
            condition: condition,
            tempValue: tempValue,
            highStr: highStr,
            lowStr: lowStr,
            feelsLikeStr: feelsLikeStr,
            onOpenRadar: onOpenRadar,
          ),

          const SizedBox(height: 24),

          // 2. Horizontal Scrollable 24-Hour Forecast
          HourlyForecastList(
            hourlyItems: weatherState.hourlyForecast,
            unit: unit,
          ),

          const SizedBox(height: 24),

          // 3. Environmental Telemetry 2x2 Bento Matrix
          BentoTelemetryGrid(
            telemetry: weather.telemetry,
            unit: unit,
          ),

          const SizedBox(height: 24),

          // 4. Sun & Moon Solar Horizon Arc Card
          SolarHorizonCard(
            sunrise: weather.telemetry.sunrise,
            sunset: weather.telemetry.sunset,
            progress: weather.telemetry.solarProgress,
          ),

          const SizedBox(height: 20),

          // 5. Live Doppler Radar Peek Banner
          _buildRadarPeekBanner(onOpenRadar),
        ],
      ),
    );
  }

  Widget _buildHeroLivingBackdrop({
    required dynamic weather,
    required WeatherConditionInfo condition,
    required int tempValue,
    required String highStr,
    required String lowStr,
    required String feelsLikeStr,
    required VoidCallback onOpenRadar,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceContainerHigh.withOpacity(0.9),
            AppColors.surfaceContainer.withOpacity(0.8),
            AppColors.surfaceContainerLow.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Aura Glows
            Positioned(
              top: -60,
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer.withOpacity(0.2),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Top Quick Bar: Location Chip & Hourly/Radar Switcher
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.near_me, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              weather.neighborhood,
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Segmented Mode Switcher
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Hourly',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.onSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onOpenRadar,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                child: Text(
                                  'Radar',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Weather Icon Badge & Condition
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(condition.icon, color: AppColors.secondary, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          condition.description,
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Hero Temperature
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$tempValue',
                        style: AppTypography.displayHeroMobile.copyWith(
                          fontSize: 78,
                          height: 1.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        '°',
                        style: AppTypography.displayHeroMobile.copyWith(
                          fontSize: 64,
                          height: 1.0,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // High / Low / Feels Like
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('H: $highStr', style: AppTypography.labelMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.outlineVariant, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('L: $lowStr', style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.outlineVariant, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text('Feels like $feelsLikeStr', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Atmosphere micro-tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.air, color: AppColors.secondary, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          weather.microTag,
                          style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarPeekBanner(VoidCallback onOpenRadar) {
    return GestureDetector(
      onTap: onOpenRadar,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.radar, color: AppColors.secondary, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Highland Bay Doppler', style: AppTypography.labelLg.copyWith(color: AppColors.onSurface)),
                    Text('Showers expected near Marin county at 3:15 PM', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 22),
          ],
        ),
      ),
    );
  }
}
