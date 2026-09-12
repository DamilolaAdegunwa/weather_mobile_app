import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SolarHorizonPainter extends CustomPainter {
  final double progress; // 0.0 (sunrise) to 1.0 (sunset)

  SolarHorizonPainter({this.progress = 0.65});

  @override
  void paint(Canvas canvas, Size size) {
    final horizonY = size.height * 0.85;

    // 1. Dashed Horizon Baseline
    final dashPaint = Paint()
      ..color = AppColors.outlineVariant.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double startX = 16.0;
    final endX = size.width - 16.0;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, horizonY),
        Offset(math.min(startX + dashWidth, endX), horizonY),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }

    // 2. Full Parabolic Arch
    final startPoint = Offset(24.0, horizonY);
    final controlPoint = Offset(size.width / 2, -10.0);
    final endPoint = Offset(size.width - 24.0, horizonY);

    final fullPath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    final archPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fullPath, archPaint);

    // 3. Traveled Parabolic Segment
    final clampedProgress = progress.clamp(0.0, 1.0);
    if (clampedProgress > 0.0) {
      final t = clampedProgress;
      // Quadratic Bezier interpolation: B(t) = (1-t)^2 P0 + 2(1-t)t P1 + t^2 P2
      final currentSunX = math.pow(1 - t, 2) * startPoint.dx +
          2 * (1 - t) * t * controlPoint.dx +
          math.pow(t, 2) * endPoint.dx;
      final currentSunY = math.pow(1 - t, 2) * startPoint.dy +
          2 * (1 - t) * t * controlPoint.dy +
          math.pow(t, 2) * endPoint.dy;

      // Draw traveled path
      final traveledPath = Path()..moveTo(startPoint.dx, startPoint.dy);
      for (double i = 0.01; i <= t; i += 0.01) {
        final px = math.pow(1 - i, 2) * startPoint.dx +
            2 * (1 - i) * i * controlPoint.dx +
            math.pow(i, 2) * endPoint.dx;
        final py = math.pow(1 - i, 2) * startPoint.dy +
            2 * (1 - i) * i * controlPoint.dy +
            math.pow(i, 2) * endPoint.dy;
        traveledPath.lineTo(px, py);
      }

      final traveledPaint = Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.secondaryContainer, AppColors.secondary],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(traveledPath, traveledPaint);

      // 4. Sun Halo & Disc
      final sunCenter = Offset(currentSunX, currentSunY);

      // Outer glow pulse
      final glowPaint = Paint()
        ..color = AppColors.secondary.withOpacity(0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(sunCenter, 14.0, glowPaint);

      // Inner glowing core
      final sunCorePaint = Paint()
        ..color = AppColors.secondary
        ..style = PaintingStyle.fill;
      canvas.drawCircle(sunCenter, 7.0, sunCorePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SolarHorizonPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
