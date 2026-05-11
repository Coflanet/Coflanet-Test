import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'app_color_theme.dart';
import 'app_decorate.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_style.dart';

// ═══════════════════════════════════════════════════════════════
// FOUNDATION / DECORATE — Figma 💅 Decorate
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> decorateUseCases = [
  WidgetbookComponent(
    name: 'Decorate',
    useCases: [
      WidgetbookUseCase(
        name: 'Interaction overlay (3 강도 × 4 상태)',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final intensity in InteractionIntensity.values) ...[
                _IntensityRow(intensity: intensity),
                const SizedBox(height: AppSpacing.space16),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Dimmer',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('아래 색상은 모달/바텀시트 배경 딤 처리용 (52% opacity).'),
              const SizedBox(height: AppSpacing.space12),
              Container(
                width: 240,
                height: 80,
                color: AppDecorate.dimmer,
                alignment: Alignment.center,
                child: Text(
                  'AppDecorate.dimmer (52%)',
                  style: AppTextStyles.label2Medium.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.space8),
              Container(
                width: 240,
                height: 80,
                color: AppDecorate.dimmerWithOpacity(0.7),
                alignment: Alignment.center,
                child: Text(
                  'dimmerWithOpacity(0.7)',
                  style: AppTextStyles.label2Medium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

class _IntensityRow extends StatelessWidget {
  const _IntensityRow({required this.intensity});

  final InteractionIntensity intensity;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          intensity.name,
          style: AppTextStyles.label1NormalBold.copyWith(color: c.labelNormal),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: AppSpacing.space12,
          runSpacing: AppSpacing.space12,
          children: InteractionState.values
              .map((state) => _OverlayTile(intensity: intensity, state: state))
              .toList(),
        ),
      ],
    );
  }
}

class _OverlayTile extends StatelessWidget {
  const _OverlayTile({required this.intensity, required this.state});

  final InteractionIntensity intensity;
  final InteractionState state;

  @override
  Widget build(BuildContext context) {
    final overlay = AppDecorate.interactionColor(
      intensity: intensity,
      state: state,
    );
    final c = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 96,
              height: 60,
              decoration: BoxDecoration(
                color: c.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(color: c.lineNormalNeutral, width: 0.5),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: overlay,
                  borderRadius: BorderRadius.circular(AppRadius.radius8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          state.name,
          style: AppTextStyles.caption1Regular.copyWith(color: c.labelAlternative),
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
