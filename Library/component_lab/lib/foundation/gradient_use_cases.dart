import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'app_color.dart';
import 'app_color_theme.dart';
import 'app_gradient.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_style.dart';

// ═══════════════════════════════════════════════════════════════
// FOUNDATION / GRADIENT — Figma 🌈 Gradient
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> gradientUseCases = [
  WidgetbookComponent(
    name: 'Gradient',
    useCases: [
      WidgetbookUseCase(
        name: 'Solid (4 directions)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space16,
            runSpacing: AppSpacing.space16,
            children: [
              _GradientTile(label: 'Bottom', gradient: AppGradient.solidBottom()),
              _GradientTile(label: 'Top', gradient: AppGradient.solidTop()),
              _GradientTile(label: 'Left', gradient: AppGradient.solidLeft()),
              _GradientTile(label: 'Right', gradient: AppGradient.solidRight()),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Solid — primary tint',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space16,
            runSpacing: AppSpacing.space16,
            children: [
              _GradientTile(
                label: 'Primary Bottom',
                gradient: AppGradient.solidBottom(color: AppColor.primaryNormal),
              ),
              _GradientTile(
                label: 'Primary Top',
                gradient: AppGradient.solidTop(color: AppColor.primaryNormal),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Mask (4 directions)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space16,
            runSpacing: AppSpacing.space16,
            children: [
              _GradientTile(label: 'Mask Bottom', gradient: AppGradient.maskBottom()),
              _GradientTile(label: 'Mask Top', gradient: AppGradient.maskTop()),
              _GradientTile(label: 'Mask Left', gradient: AppGradient.maskLeft()),
              _GradientTile(label: 'Mask Right', gradient: AppGradient.maskRight()),
            ],
          ),
        ),
      ),
    ],
  ),
];

class _GradientTile extends StatelessWidget {
  const _GradientTile({required this.label, required this.gradient});

  final String label;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 160,
          height: 100,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.radius8),
            border: Border.all(color: c.lineNormalNeutral, width: 0.5),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.caption1Regular.copyWith(color: c.labelNeutral),
        ),
      ],
    );
  }
}

Widget _bg(BuildContext context, Widget child) {
  return Container(
    color: context.appColors.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.space24),
    alignment: Alignment.center,
    child: child,
  );
}
