import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import 'app_card.dart';

final List<WidgetbookComponent> cardUseCases = [
  WidgetbookComponent(
    name: 'AppCard',
    useCases: [
      WidgetbookUseCase(
        name: 'Variants — flat / elevated / outlined',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final labelColor =
              isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
          final altColor = isDark
              ? AppColor.darkLabelAlternative
              : AppColor.labelAlternative;
          final pageBg = isDark
              ? AppColor.darkBackgroundNormalNormal
              : AppColor.backgroundNormalNormal;

          Widget body(String title) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline2Bold
                        .copyWith(color: labelColor),
                  ),
                  const SizedBox(height: AppSpacing.space8),
                  Text(
                    '카드 안 컨텐츠. 본문 스타일은 body2NormalRegular.',
                    style: AppTextStyles.body2NormalRegular
                        .copyWith(color: altColor),
                  ),
                ],
              );

          return Container(
            color: pageBg,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                AppCard(
                  variant: AppCardVariant.flat,
                  width: double.infinity,
                  child: body('Flat'),
                ),
                const SizedBox(height: AppSpacing.space16),
                AppCard(
                  variant: AppCardVariant.elevated,
                  width: double.infinity,
                  child: body('Elevated (그림자)'),
                ),
                const SizedBox(height: AppSpacing.space16),
                AppCard(
                  variant: AppCardVariant.outlined,
                  width: double.infinity,
                  child: body('Outlined (테두리)'),
                ),
              ],
            ),
          );
        },
      ),
      WidgetbookUseCase(
        name: 'Tappable',
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final labelColor =
              isDark ? AppColor.darkLabelNormal : AppColor.labelNormal;
          final pageBg = isDark
              ? AppColor.darkBackgroundNormalNormal
              : AppColor.backgroundNormalNormal;

          return Container(
            color: pageBg,
            padding: const EdgeInsets.all(24),
            child: AppCard(
              onTap: () {},
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.coffee_rounded,
                      color: AppColor.colorGlobalOrange50, size: 32),
                  const SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('탭 가능한 카드',
                            style: AppTextStyles.headline2Bold
                                .copyWith(color: labelColor)),
                        const SizedBox(height: AppSpacing.space4),
                        Text(
                          'onTap 콜백 있으면 InkWell 자동 적용',
                          style: AppTextStyles.label1NormalRegular.copyWith(
                            color: isDark
                                ? AppColor.darkLabelAlternative
                                : AppColor.labelAlternative,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColor.darkLabelAssistive
                          : AppColor.labelAssistive),
                ],
              ),
            ),
          );
        },
      ),
    ],
  ),
];
