import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Circular progress timer with animated arc
class CircularTimer extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final List<double>? phaseMarkers; // Phase positions (0.0 to 1.0)

  const CircularTimer({
    super.key,
    required this.progress,
    this.size = 280,
    this.strokeWidth = 12,
    this.progressColor,
    this.backgroundColor,
    this.child,
    this.phaseMarkers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow effect
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (progressColor ?? AppColor.colorGlobalOrange50)
                      .withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Main circular progress
          CustomPaint(
            size: Size(size, size),
            painter: _CircularTimerPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              progressColor: progressColor ?? AppColor.colorGlobalOrange50,
              backgroundColor:
                  backgroundColor ??
                  AppColor.colorGlobalNeutral22.withOpacity(0.3),
              phaseMarkers: phaseMarkers,
            ),
          ),
          // Inner decorative ring
          Container(
            width: size - strokeWidth * 4,
            height: size - strokeWidth * 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.colorGlobalNeutral22.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          // Center content
          if (child != null)
            SizedBox(
              width: size - strokeWidth * 6,
              height: size - strokeWidth * 6,
              child: child,
            ),
        ],
      ),
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final List<double>? phaseMarkers;

  _CircularTimerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    this.phaseMarkers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [progressColor.withOpacity(0.6), progressColor, progressColor],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect);

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, gradientPaint);

    // Draw phase markers
    if (phaseMarkers != null) {
      final markerPaint = Paint()
        ..color = AppColor.colorGlobalCommon100.withOpacity(0.4)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      for (final marker in phaseMarkers!) {
        final angle = -math.pi / 2 + (2 * math.pi * marker);
        final innerRadius = radius - strokeWidth / 2 - 8;
        final outerRadius = radius + strokeWidth / 2 + 8;

        final innerPoint = Offset(
          center.dx + innerRadius * math.cos(angle),
          center.dy + innerRadius * math.sin(angle),
        );
        final outerPoint = Offset(
          center.dx + outerRadius * math.cos(angle),
          center.dy + outerRadius * math.sin(angle),
        );

        canvas.drawLine(innerPoint, outerPoint, markerPaint);
      }
    }

    // Glowing dot at progress end
    if (progress > 0) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final dotCenter = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      // Outer glow
      final glowPaint = Paint()
        ..color = progressColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(dotCenter, strokeWidth / 2 + 4, glowPaint);

      // Inner dot
      final dotPaint = Paint()
        ..color = AppColor.colorGlobalCommon100
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, strokeWidth / 2 - 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}

/// Phase indicator widget for showing current brewing phase
class PhaseIndicator extends StatelessWidget {
  final int currentPhase;
  final int totalPhases;
  final List<String> phaseNames;
  final List<Color>? phaseColors;

  const PhaseIndicator({
    super.key,
    required this.currentPhase,
    required this.totalPhases,
    required this.phaseNames,
    this.phaseColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPhases, (index) {
        final isActive = index == currentPhase;
        final isPast = index < currentPhase;
        final color = phaseColors?[index] ?? AppColor.colorGlobalOrange50;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: AppRadius.xsBorder,
              color: isActive
                  ? color
                  : isPast
                  ? color.withOpacity(0.5)
                  : AppColor.colorGlobalNeutral30,
            ),
          ),
        );
      }),
    );
  }
}
