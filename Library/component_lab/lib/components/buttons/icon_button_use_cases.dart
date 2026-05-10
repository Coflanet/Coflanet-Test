import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import 'app_button.dart';
import 'app_icon_button.dart';

final List<WidgetbookComponent> iconButtonUseCases = [
  WidgetbookComponent(
    name: 'AppIconButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Variants',
        builder: (context) => _wrap(context, [
          AppIconButton(
            icon: Icons.favorite_rounded,
            onPressed: () {},
            variant: AppButtonVariant.solidPrimary,
          ),
          AppIconButton(
            icon: Icons.favorite_rounded,
            onPressed: () {},
            variant: AppButtonVariant.solidSecondary,
          ),
          AppIconButton(
            icon: Icons.favorite_rounded,
            onPressed: () {},
            variant: AppButtonVariant.outline,
          ),
          AppIconButton(
            icon: Icons.favorite_rounded,
            onPressed: () {},
            variant: AppButtonVariant.ghost,
          ),
          AppIconButton(
            icon: Icons.favorite_rounded,
            onPressed: () {},
            variant: AppButtonVariant.text,
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Sizes — sm/md/lg',
        builder: (context) => _wrap(context, [
          AppIconButton(
            icon: Icons.search_rounded,
            onPressed: () {},
            size: AppIconButtonSize.sm,
            variant: AppButtonVariant.outline,
          ),
          AppIconButton(
            icon: Icons.search_rounded,
            onPressed: () {},
            size: AppIconButtonSize.md,
            variant: AppButtonVariant.outline,
          ),
          AppIconButton(
            icon: Icons.search_rounded,
            onPressed: () {},
            size: AppIconButtonSize.lg,
            variant: AppButtonVariant.outline,
          ),
        ]),
      ),
      WidgetbookUseCase(
        name: 'Common usages',
        builder: (context) => _wrap(context, [
          AppIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () {},
            tooltip: '뒤로',
          ),
          AppIconButton(
            icon: Icons.close_rounded,
            onPressed: () {},
            tooltip: '닫기',
          ),
          AppIconButton(
            icon: Icons.share_rounded,
            onPressed: () {},
            tooltip: '공유',
          ),
          AppIconButton(
            icon: Icons.more_vert_rounded,
            onPressed: () {},
            tooltip: '더보기',
          ),
          AppIconButton(
            icon: Icons.add_rounded,
            onPressed: () {},
            variant: AppButtonVariant.solidPrimary,
            tooltip: '추가',
          ),
          AppIconButton(
            icon: Icons.delete_outline_rounded,
            onPressed: () {},
            variant: AppButtonVariant.solidSecondary,
            tooltip: '삭제',
          ),
        ]),
      ),
    ],
  ),
];

Widget _wrap(BuildContext context, List<Widget> children) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bg = isDark
      ? AppColor.darkBackgroundNormalNormal
      : AppColor.backgroundNormalNormal;
  return Container(
    color: bg,
    padding: const EdgeInsets.all(24),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    ),
  );
}
