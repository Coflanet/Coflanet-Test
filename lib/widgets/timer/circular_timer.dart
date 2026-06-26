import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';

/// Circular progress timer with animated arc
///
/// Figma(레시피 타이머)는 연보라로 채워진 원판 위에 회색 트랙 + 보라 진행
/// 아크(둥근 캡)를 얹은 형태. 글로우/장식 링/끝점 도트는 없다.
class CircularTimer extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;

  /// 원판 내부 채움색 (Figma: primaryLight 연보라). null 이면 채우지 않음.
  final Color? fillColor;
  final Widget? child;
  final List<double>? phaseMarkers; // Phase positions (0.0 to 1.0)

  /// 진행 아크 보간 시간 — Duration.zero(기본)면 즉시 점프(기존 동작),
  /// 1초 틱 타이머에서 Duration(seconds: 1) + Curves.linear 로 주면
  /// 틱 사이가 이어져 연속적으로 차오르는 스윕이 된다.
  /// 스텝 전환(진행률 리셋) 시 되감기 애니메이션을 피하려면
  /// 호출부에서 key 를 스텝 단위로 바꿔 상태를 초기화한다.
  final Duration animationDuration;

  const CircularTimer({
    super.key,
    required this.progress,
    this.size = 220,
    this.strokeWidth = 12,
    this.progressColor,
    this.backgroundColor,
    this.fillColor,
    this.child,
    this.phaseMarkers,
    this.animationDuration = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 트랙(배경 링) 기본값 — backgroundColor 가 주입되면 그대로 존중하고,
    // 미주입 시에만 테마 분기.
    final resolvedTrackColor =
        backgroundColor ??
        (isDark
            ? AppColor.colorGlobalCoolNeutral50.withValues(alpha: 0.45)
            : AppColor.colorGlobalNeutral22.withValues(alpha: 0.3));
    final arcColor = progressColor ?? AppColor.colorGlobalViolet50;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 연보라 원판 + 은은한 보라 그림자 (Figma 원판 채움/그림자)
          if (fillColor != null)
            Container(
              width: size - strokeWidth,
              height: size - strokeWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor,
                boxShadow: [
                  BoxShadow(
                    color: arcColor.withValues(alpha: 0.12),
                    blurRadius: 40,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          // Main circular progress — animationDuration 이 있으면 이전 값에서
          // 새 값까지 선형 보간 (1초 틱과 맞물려 연속 스윕)
          if (animationDuration == Duration.zero)
            CustomPaint(
              size: Size(size, size),
              painter: _CircularTimerPainter(
                progress: progress,
                strokeWidth: strokeWidth,
                progressColor: arcColor,
                backgroundColor: resolvedTrackColor,
                phaseMarkers: phaseMarkers,
              ),
            )
          else
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: animationDuration,
              curve: Curves.linear,
              builder: (context, animatedProgress, _) => CustomPaint(
                size: Size(size, size),
                painter: _CircularTimerPainter(
                  progress: animatedProgress,
                  strokeWidth: strokeWidth,
                  progressColor: arcColor,
                  backgroundColor: resolvedTrackColor,
                  phaseMarkers: phaseMarkers,
                ),
              ),
            ),
          // Center content
          if (child != null)
            SizedBox(
              width: size - strokeWidth * 4,
              height: size - strokeWidth * 4,
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

    // Progress arc — Figma 는 단색 보라 + 둥근 캡(그라데이션 없음)
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, progressPaint);

    // Draw phase markers
    if (phaseMarkers != null) {
      final markerPaint = Paint()
        ..color = AppColor.colorGlobalCommon100.withValues(alpha: 0.4)
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
  }

  @override
  bool shouldRepaint(covariant _CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
