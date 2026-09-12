import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../domain/entities/location_entity.dart';
import '../../core/utils/unit_converter.dart';

class SavedCityCard extends StatelessWidget {
  final LocationEntity location;
  final TemperatureUnit unit;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const SavedCityCard({
    super.key,
    required this.location,
    required this.unit,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final temp = location.currentTemp ?? 20.0;
    final tempStr = UnitConverter.formatTemperature(temp, unit);
    final highStr = location.tempMax != null ? UnitConverter.formatTemperature(location.tempMax!, unit) : '72°';
    final lowStr = location.tempMin != null ? UnitConverter.formatTemperature(location.tempMin!, unit) : '55°';

    return Dismissible(
      key: ValueKey('saved_city_${location.id}'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onDismissed(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete_outline, color: AppColors.onErrorContainer, size: 28),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: AppColors.onErrorContainer, size: 28),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorderLight, width: 0.8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative background glow
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.glowCyan.withOpacity(0.12),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location.name,
                                style: AppTypography.headlineSm.copyWith(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${location.country} • ${location.localTime ?? "2:45 PM"}',
                          style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          location.conditionText ?? 'Partly Cloudy',
                          style: AppTypography.bodyMd.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  // Right Temperature
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tempStr,
                        style: AppTypography.displayHeroMobile.copyWith(fontSize: 44, height: 1.1),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('H: $highStr', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                          const SizedBox(width: 6),
                          Text('L: $lowStr', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
