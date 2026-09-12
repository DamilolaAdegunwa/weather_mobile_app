import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AtmosphericBackground extends StatelessWidget {
  final Widget child;

  const AtmosphericBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bedrock deep gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A0F1D),
                AppColors.background,
                Color(0xFF070B14),
              ],
            ),
          ),
        ),
        // Ambient Cyan Glow Pool (Top Left)
        Positioned(
          top: -80,
          left: -40,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.glowCyan.withOpacity(0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Ambient Azure/Indigo Glow Pool (Top Right)
        Positioned(
          top: 60,
          right: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.glowBlue.withOpacity(0.20),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Foreground Content
        child,
      ],
    );
  }
}
