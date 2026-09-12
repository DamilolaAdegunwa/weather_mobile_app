import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'glass_container.dart';

class AppBarHeader extends StatelessWidget {
  final String subtitle;
  final String currentCity;
  final VoidCallback onLocationTap;

  const AppBarHeader({
    super.key,
    required this.subtitle,
    required this.currentCity,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLowest.withOpacity(0.75),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Brand Logo & Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.cloud_outlined,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Aether', style: AppTypography.headlineSm.copyWith(fontSize: 16)),
                  Text(subtitle, style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ],
          ),

          // Center: Location Selection Capsule
          GestureDetector(
            onTap: onLocationTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withOpacity(0.7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.glassBorderLight,
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: AppColors.secondary, size: 16),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      currentCity,
                      style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 14),
                ],
              ),
            ),
          ),

          // Right: Action Buttons (Theme Mode / Avatar)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.dark_mode_outlined, size: 18, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 18, color: AppColors.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
