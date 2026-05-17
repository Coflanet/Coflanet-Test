import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import 'app_divider.dart';

final List<WidgetbookComponent> dividerUseCases = [
  WidgetbookComponent(
    name: 'AppDivider',
    useCases: [
      WidgetbookUseCase(
        name: 'Tick × Vertical — 3 조합',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final pageBg = isDark
              ? AppColor.darkBackgroundNormalNormal
              : AppColor.backgroundNormalNormal;
          final labelColor =
              isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;

          Widget row(String label, {bool tick = false, bool vertical = false}) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.label2Medium
                      .copyWith(color: labelColor),
                ),
                const SizedBox(height: AppSpacing.s8),
                if (vertical)
                  SizedBox(
                    height: 48,
                    child: AppDivider(tick: tick, vertical: vertical),
                  )
                else
                  AppDivider(tick: tick, vertical: vertical),
                const SizedBox(height: AppSpacing.s24),
              ],
            );
          }

          return Container(
            color: pageBg,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                row('Tick=off (1px 가는 선)'),
                row('Tick=on (10px 구분 영역)', tick: true),
                row('Vertical (세로 1px)', vertical: true),
              ],
            ),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'Indent 적용',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final pageBg = isDark
              ? AppColor.darkBackgroundNormalNormal
              : AppColor.backgroundNormalNormal;
          return Container(
            color: pageBg,
            padding: const EdgeInsets.all(24),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDivider(),
                SizedBox(height: 16),
                AppDivider(indent: 16),
                SizedBox(height: 16),
                AppDivider(indent: 16, endIndent: 16),
              ],
            ),
          );
        },
      ),
    ],
  ),
];
