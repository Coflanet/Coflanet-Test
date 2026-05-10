import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'app_color.dart';

/// Opacity use_cases — Figma `Opacity/*` 15단계.
final List<WidgetbookComponent> opacityUseCases = [
  WidgetbookComponent(
    name: 'Opacity Scale',
    useCases: [
      WidgetbookUseCase(
        name: '15단계 — 0~100 (체커 배경)',
        builder: (context) => const _OpacityChart(),
      ),
    ],
  ),
];

class _OpacityChart extends StatelessWidget {
  const _OpacityChart();

  static const _values = [
    ('colorGlobalOpacity0', AppColor.colorGlobalOpacity0),
    ('colorGlobalOpacity5', AppColor.colorGlobalOpacity5),
    ('colorGlobalOpacity8', AppColor.colorGlobalOpacity8),
    ('colorGlobalOpacity12', AppColor.colorGlobalOpacity12),
    ('colorGlobalOpacity16', AppColor.colorGlobalOpacity16),
    ('colorGlobalOpacity22', AppColor.colorGlobalOpacity22),
    ('colorGlobalOpacity28', AppColor.colorGlobalOpacity28),
    ('colorGlobalOpacity35', AppColor.colorGlobalOpacity35),
    ('colorGlobalOpacity43', AppColor.colorGlobalOpacity43),
    ('colorGlobalOpacity52', AppColor.colorGlobalOpacity52),
    ('colorGlobalOpacity61', AppColor.colorGlobalOpacity61),
    ('colorGlobalOpacity74', AppColor.colorGlobalOpacity74),
    ('colorGlobalOpacity88', AppColor.colorGlobalOpacity88),
    ('colorGlobalOpacity97', AppColor.colorGlobalOpacity97),
    ('colorGlobalOpacity100', AppColor.colorGlobalOpacity100),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
    final altColor = isDark
        ? AppColor.darkLabelAlternative
        : AppColor.labelAlternative;
    final overlayColor =
        isDark ? AppColor.colorGlobalCommon100 : AppColor.colorGlobalCommon0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _values.map((it) {
          return SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 체커 배경 + 컬러 오버레이
                _CheckerBox(
                  child: Container(
                    width: 140,
                    height: 80,
                    color: overlayColor.withValues(alpha: it.$2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  it.$1,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(it.$2 * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: altColor,
                    fontSize: 11,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 체커 패턴 배경 — 투명도 시각화에 도움.
class _CheckerBox extends StatelessWidget {
  final Widget child;
  const _CheckerBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // 체커 패턴 (8x8 격자)
          CustomPaint(
            size: const Size(140, 80),
            painter: _CheckerPainter(),
          ),
          child,
        ],
      ),
    );
  }
}

class _CheckerPainter extends CustomPainter {
  static const _cell = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()..color = const Color(0xFFE0E0E0);
    final darkPaint = Paint()..color = const Color(0xFFC0C0C0);

    canvas.drawRect(Offset.zero & size, lightPaint);

    final cols = (size.width / _cell).ceil();
    final rows = (size.height / _cell).ceil();
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if ((r + c) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(c * _cell, r * _cell, _cell, _cell),
            darkPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
