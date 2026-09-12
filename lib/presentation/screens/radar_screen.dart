import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/glass_container.dart';
import '../state/weather_notifier.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  double _timeSliderValue = 0.5;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = context.watch<WeatherNotifier>().state;
    final cityName = weatherState.currentWeather?.cityName ?? 'San Francisco';

    return Stack(
      children: [
        // Simulated Interactive Doppler Radar Map View
        Positioned.fill(
          child: Container(
            color: const Color(0xFF070C18),
            child: Stack(
              children: [
                // Grid Lines
                CustomPaint(
                  size: Size.infinite,
                  painter: _RadarGridPainter(),
                ),

                // Simulated Doppler Weather Radar Cells
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: _RadarCellsPainter(
                        animationValue: _pulseController.value,
                        timeOffset: _timeSliderValue,
                      ),
                    );
                  },
                ),

                // City Center Pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.secondary, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 4),
                            Text(cityName, style: AppTypography.labelMd.copyWith(color: AppColors.onSurface)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.secondary, blurRadius: 10, spreadRadius: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Top Control Overlay: Station Info & Layer Selectors
        Positioned(
          top: 16,
          left: 20,
          right: 20,
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: BorderRadius.circular(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.radar, color: AppColors.secondary, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Highland Bay Doppler', style: AppTypography.labelMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                        Text('High-Resolution Composite', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text('LIVE', style: AppTypography.labelSm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Control Overlay: Time Scrubber & Intensity Legend
        Positioned(
          bottom: 90,
          left: 20,
          right: 20,
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Intensity Scale Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Light', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                    Container(
                      width: 140,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF38BDF8),
                            Color(0xFF34D399),
                            Color(0xFFFBBF24),
                            Color(0xFFF87171),
                            Color(0xFFA855F7),
                          ],
                        ),
                      ),
                    ),
                    Text('Severe', style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 12),
                // Time Scrubber
                Row(
                  children: [
                    const Icon(Icons.play_arrow_rounded, color: AppColors.secondary, size: 24),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          activeTrackColor: AppColors.secondary,
                          inactiveTrackColor: AppColors.surfaceContainerHighest,
                          thumbColor: AppColors.textPrimary,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        ),
                        child: Slider(
                          value: _timeSliderValue,
                          onChanged: (val) {
                            setState(() {
                              _timeSliderValue = val;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      _timeSliderValue < 0.3 ? '-30 min' : (_timeSliderValue > 0.7 ? '+45 min' : 'Now'),
                      style: AppTypography.labelSm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RadarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.outlineVariant.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Range rings
    canvas.drawCircle(center, 80, paint);
    canvas.drawCircle(center, 160, paint);
    canvas.drawCircle(center, 240, paint);

    // Crosshairs
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RadarCellsPainter extends CustomPainter {
  final double animationValue;
  final double timeOffset;

  _RadarCellsPainter({required this.animationValue, required this.timeOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Weather radar echo blobs
    final cellPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final shiftX = (timeOffset - 0.5) * 80;
    final shiftY = (timeOffset - 0.5) * -60;

    canvas.drawCircle(Offset(center.dx - 60 + shiftX, center.dy - 70 + shiftY), 45, cellPaint);
    canvas.drawCircle(Offset(center.dx + 40 + shiftX, center.dy - 120 + shiftY), 60, cellPaint);

    // Heavy core
    final corePaint = Paint()
      ..color = const Color(0xFF34D399).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(center.dx - 55 + shiftX, center.dy - 75 + shiftY), 25, corePaint);

    // Radar sweep line
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          AppColors.secondary.withOpacity(0.18),
        ],
        transform: GradientRotation(animationValue * 6.28318),
      ).createShader(Rect.fromCircle(center: center, radius: 240));

    canvas.drawCircle(center, 240, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarCellsPainter oldDelegate) => true;
}
