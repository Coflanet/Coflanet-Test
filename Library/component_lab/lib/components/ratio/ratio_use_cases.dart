import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';
import 'app_ratio.dart';

final List<WidgetbookComponent> ratioUseCases = [
  // ── Horizontal (가로 기준) ────────────────────────
  WidgetbookComponent(
    name: 'AppRatioBox',
    useCases: [
      WidgetbookUseCase(
        name: 'Landscape / Square (9 variants)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: const [
              _RatioCell('1:1 square', AppRatio.square, 120),
              _RatioCell('5:4', AppRatio.ratio5x4, 140),
              _RatioCell('4:3', AppRatio.ratio4x3, 160),
              _RatioCell('3:2', AppRatio.ratio3x2, 180),
              _RatioCell('16:10', AppRatio.ratio16x10, 200),
              _RatioCell('1.618:1 golden', AppRatio.goldenLandscape, 200),
              _RatioCell('16:9 wide', AppRatio.ratio16x9, 240),
              _RatioCell('2:1', AppRatio.ratio2x1, 240),
              _RatioCell('21:9 cinematic', AppRatio.ratio21x9, 280),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Portrait (8 variants)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: const [
              _RatioCell('4:5', AppRatio.ratio4x5, 120),
              _RatioCell('3:4', AppRatio.ratio3x4, 110),
              _RatioCell('2:3', AppRatio.ratio2x3, 100),
              _RatioCell('10:16', AppRatio.ratio10x16, 90),
              _RatioCell('1:1.618 golden', AppRatio.goldenPortrait, 90),
              _RatioCell('9:16', AppRatio.ratio9x16, 80),
              _RatioCell('1:2', AppRatio.ratio1x2, 80),
              _RatioCell('9:21', AppRatio.ratio9x21, 70),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: '실 사용 — 이미지 비율 고정',
        builder: (context) => _bg(
          context,
          SizedBox(
            width: 280,
            child: AppRatioBox(
              ratio: AppRatio.ratio16x9,
              child: Image.network(
                'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    ],
  ),

  // ── Vertical (세로 기준) ──────────────────────────
  WidgetbookComponent(
    name: 'AppRatioBoxVertical',
    useCases: [
      WidgetbookUseCase(
        name: '세로 기준 비율 (1:1, 1:2)',
        builder: (context) => _bg(
          context,
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _VerticalRatioCell('1:1', AppRatio.square, context),
                const SizedBox(width: 16),
                _VerticalRatioCell('1:2', AppRatio.ratio1x2, context),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
];

// ── Helper widgets ─────────────────────────────────

/// Horizontal 비율 셀 — 가로 폭 고정, 높이는 비율에 따라 결정.
class _RatioCell extends StatelessWidget {
  final String label;
  final AppRatio ratio;
  final double width;

  const _RatioCell(this.label, this.ratio, this.width);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
    final altColor =
        isDark ? AppColor.darkLabelAlternative : AppColor.labelAlternative;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppRatioBox(
            ratio: ratio,
            child: Center(
              child: Icon(Icons.image_outlined,
                  color: altColor, size: width * 0.2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption1Medium.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }
}

/// Vertical 비율 셀 — 부모 높이 기준으로 가로 폭 결정.
Widget _VerticalRatioCell(
    String label, AppRatio ratio, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final labelColor =
      isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
  final altColor =
      isDark ? AppColor.darkLabelAlternative : AppColor.labelAlternative;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: AppRatioBoxVertical(
          ratio: ratio,
          child: Center(
            child: Icon(Icons.image_outlined, color: altColor, size: 32),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: AppTextStyles.caption1Medium.copyWith(color: labelColor),
      ),
    ],
  );
}

Widget _bg(BuildContext context, Widget child) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bg = isDark
      ? AppColor.darkBackgroundNormalNormal
      : AppColor.backgroundNormalNormal;
  return Container(
    color: bg,
    padding: const EdgeInsets.all(24),
    child: child,
  );
}
