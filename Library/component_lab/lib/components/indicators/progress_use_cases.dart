import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_progress.dart';

final List<WidgetbookComponent> progressUseCases = [
  WidgetbookComponent(
    name: 'AppLinearProgress',
    useCases: [
      WidgetbookUseCase(
        name: 'Determinate — 0/25/50/75/100%',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              AppLinearProgress(value: 0),
              SizedBox(height: AppSpacing.space12),
              AppLinearProgress(value: 0.25),
              SizedBox(height: AppSpacing.space12),
              AppLinearProgress(value: 0.5),
              SizedBox(height: AppSpacing.space12),
              AppLinearProgress(value: 0.75),
              SizedBox(height: AppSpacing.space12),
              AppLinearProgress(value: 1),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Indeterminate (애니메이션)',
        builder: (context) => _bg(
          context,
          const AppLinearProgress(),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom color · height',
        builder: (context) => _bg(
          context,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppLinearProgress(
                  value: 0.6, color: AppColor.colorGlobalGreen50),
              const SizedBox(height: AppSpacing.space12),
              const AppLinearProgress(
                  value: 0.4, color: AppColor.colorGlobalOrange50, height: 8),
              const SizedBox(height: AppSpacing.space12),
              const AppLinearProgress(
                  value: 0.8, color: AppColor.colorGlobalRed50, height: 12),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'AppCircularProgress',
    useCases: [
      WidgetbookUseCase(
        name: 'Indeterminate — 다양한 사이즈',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            runSpacing: 24,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppCircularProgress(size: 16, strokeWidth: 2),
              AppCircularProgress(size: 24, strokeWidth: 2.5),
              AppCircularProgress(size: 32),
              AppCircularProgress(size: 48, strokeWidth: 4),
              AppCircularProgress(size: 64, strokeWidth: 5),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Determinate',
        builder: (context) => _bg(
          context,
          const Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              AppCircularProgress(value: 0.25, size: 48),
              AppCircularProgress(value: 0.5, size: 48),
              AppCircularProgress(value: 0.75, size: 48),
              AppCircularProgress(value: 1.0, size: 48),
            ],
          ),
        ),
      ),
    ],
  ),
  WidgetbookComponent(
    name: 'AppLabeledProgress',
    useCases: [
      WidgetbookUseCase(
        name: '라벨 + 퍼센트 + 바',
        builder: (context) => _bg(
          context,
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppLabeledProgress(label: '진행 중', value: 0.35),
              SizedBox(height: AppSpacing.space16),
              AppLabeledProgress(
                  label: '저장됨',
                  value: 0.85,
                  color: AppColor.colorGlobalGreen50),
              SizedBox(height: AppSpacing.space16),
              AppLabeledProgress(
                  label: '거의 완료',
                  value: 0.95,
                  color: AppColor.colorGlobalOrange50),
            ],
          ),
        ),
      ),
    ],
  ),
];

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
