import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'app_color.dart';
import 'app_radius.dart';

/// Radius 토큰 카탈로그 항목.
class _R {
  final String name;
  final double value;
  final String? description;

  const _R(this.name, this.value, [this.description]);
}

/// Radius use_cases — Palette 7+1 + Semantic 7.
final List<WidgetbookComponent> radiusUseCases = [
  WidgetbookComponent(
    name: 'Palette',
    useCases: [
      WidgetbookUseCase(
        name: 'Figma Round/* 7단계 + Pill',
        builder: (context) => _grid(context, const [
          _R('radius8', AppRadius.radius8, 'Round/8'),
          _R('radius12', AppRadius.radius12, 'Round/12'),
          _R('radius16', AppRadius.radius16, 'Round/16(Box in Box)'),
          _R('radius20', AppRadius.radius20, 'Round/20(Box)'),
          _R('radius24', AppRadius.radius24, 'Round/24(Box)'),
          _R('radius32', AppRadius.radius32, 'Round/32(Box)'),
          _R('radius40', AppRadius.radius40, 'Round/40(1st Box)'),
          _R('radiusPill', AppRadius.radiusPill, 'Pill (Figma 외)'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Semantic',
    useCases: [
      WidgetbookUseCase(
        name: '컴포넌트별 의미 토큰',
        builder: (context) => _grid(context, const [
          _R('radiusChip', AppRadius.radiusChip, 'Chip · 8px'),
          _R('radiusCheckbox', AppRadius.radiusCheckbox,
              'Checkbox · 8px (Figma 통일)'),
          _R('radiusButton', AppRadius.radiusButton, 'Button · 12px'),
          _R('radiusInput', AppRadius.radiusInput, 'Input · 12px'),
          _R('radiusCard', AppRadius.radiusCard, 'Card · 16px'),
          _R('radiusModal', AppRadius.radiusModal, 'Modal · 20px'),
          _R('radiusAvatar', AppRadius.radiusAvatar, 'Avatar · Pill'),
        ]),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'Directional',
    useCases: [
      WidgetbookUseCase(
        name: 'top / bottom / left / right helpers',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bg = isDark ? AppColor.darkPrimaryNormal : AppColor.primaryNormal;
          final border = isDark
              ? AppColor.darkLineSolidNormal
              : AppColor.lineSolidNormal;

          Widget sample(String label, BorderRadius radius) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: radius,
                      border: Border.all(color: border, width: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(label,
                      style: TextStyle(
                        color: isDark
                            ? AppColor.darkLabelNormal
                            : AppColor.labelNormal,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                sample('top(20)', AppRadius.top(20)),
                sample('bottom(20)', AppRadius.bottom(20)),
                sample('left(20)', AppRadius.left(20)),
                sample('right(20)', AppRadius.right(20)),
              ],
            ),
          );
        },
      ),
    ],
  ),
];

/// 각 radius 값을 정사각형 박스로 시각화.
Widget _grid(BuildContext context, List<_R> items) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bg = isDark ? AppColor.darkPrimaryNormal : AppColor.primaryNormal;
  final labelColor = isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
  final altColor =
      isDark ? AppColor.darkLabelAlternative : AppColor.labelAlternative;
  final border =
      isDark ? AppColor.darkLineSolidNormal : AppColor.lineSolidNormal;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((it) {
        return SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 160,
                height: 100,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(it.value),
                  border: Border.all(color: border, width: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                it.name,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${it.value.toStringAsFixed(0)}px',
                style: TextStyle(
                  color: altColor,
                  fontSize: 11,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (it.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  it.description!,
                  style: TextStyle(color: altColor, fontSize: 11),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    ),
  );
}
