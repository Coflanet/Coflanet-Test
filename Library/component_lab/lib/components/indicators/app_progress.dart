import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';

/// Linear progress bar (가로 바).
///
/// `value`가 null이면 indeterminate (자체 애니메이션).
class AppLinearProgress extends StatelessWidget {
  final double? value;
  final double height;
  final Color? color;

  const AppLinearProgress({
    super.key,
    this.value,
    this.height = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final track = c.componentFillNormal;
    final fill = color ??
        (c.primaryNormal);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value,
          minHeight: height,
          backgroundColor: track,
          valueColor: AlwaysStoppedAnimation<Color>(fill),
        ),
      ),
    );
  }
}

/// Circular progress (원형).
class AppCircularProgress extends StatelessWidget {
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppCircularProgress({
    super.key,
    this.value,
    this.size = 32,
    this.strokeWidth = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final fill = color ??
        (c.primaryNormal);
    final track = c.componentFillNormal;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        backgroundColor: track,
        valueColor: AlwaysStoppedAnimation<Color>(fill),
      ),
    );
  }
}

/// 라벨 + 진행률 + 바 — 자주 쓰이는 패턴 묶음.
class AppLabeledProgress extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;

  const AppLabeledProgress({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final labelColor =
        c.labelNormal;
    final altColor = c.labelAlternative;
    final pct = (value.clamp(0.0, 1.0) * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                color: altColor,
                fontSize: 12,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AppLinearProgress(value: value, color: color),
      ],
    );
  }
}
