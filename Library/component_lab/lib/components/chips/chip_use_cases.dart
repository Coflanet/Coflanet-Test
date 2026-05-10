import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_chip_action.dart';
import 'app_chip_filter.dart';

// ═══════════════════════════════════════════════════════════════
// CHIP / ACTION — Figma `Chip/Action` (Solid/Outlined × 4 size)
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> chipActionUseCases = [
  WidgetbookComponent(
    name: 'Action',
    useCases: [
      WidgetbookUseCase(
        name: '2 Variants × 4 Sizes (Default)',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final variant in AppChipActionVariant.values) ...[
                Text(variant.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: AppSpacing.space12,
                  runSpacing: AppSpacing.space12,
                  alignment: WrapAlignment.center,
                  children: AppChipSize.values
                      .map((s) => AppChipAction(
                            label: _sizeLabel(s),
                            size: s,
                            variant: variant,
                            onPressed: () {},
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space20),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Active 상태',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final variant in AppChipActionVariant.values) ...[
                Text(variant.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: AppSpacing.space12,
                  runSpacing: AppSpacing.space12,
                  alignment: WrapAlignment.center,
                  children: AppChipSize.values
                      .map((s) => AppChipAction(
                            label: _sizeLabel(s),
                            size: s,
                            variant: variant,
                            isActive: true,
                            onPressed: () {},
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space20),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disable 상태',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final variant in AppChipActionVariant.values) ...[
                Text(variant.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: AppSpacing.space12,
                  runSpacing: AppSpacing.space12,
                  alignment: WrapAlignment.center,
                  children: AppChipSize.values
                      .map((s) => AppChipAction(
                            label: _sizeLabel(s),
                            size: s,
                            variant: variant,
                            onPressed: null,
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space20),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Leading / Trailing 아이콘',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space12,
            runSpacing: AppSpacing.space12,
            alignment: WrapAlignment.center,
            children: [
              AppChipAction(
                label: '북마크',
                size: AppChipSize.medium,
                leadingIcon: Icons.bookmark_border_rounded,
                onPressed: () {},
              ),
              AppChipAction(
                label: '북마크됨',
                size: AppChipSize.medium,
                leadingIcon: Icons.bookmark_rounded,
                isActive: true,
                onPressed: () {},
              ),
              AppChipAction(
                label: '닫기',
                size: AppChipSize.medium,
                trailingIcon: Icons.close_rounded,
                onPressed: () {},
              ),
              AppChipAction(
                label: '추가',
                size: AppChipSize.medium,
                leadingIcon: Icons.add_rounded,
                trailingIcon: Icons.arrow_forward_rounded,
                variant: AppChipActionVariant.outlined,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// CHIP / FILTER — Figma `Chip/Filter` (Solid/Outline × 4 size)
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> chipFilterUseCases = [
  WidgetbookComponent(
    name: 'Filter',
    useCases: [
      WidgetbookUseCase(
        name: '2 Variants × 4 Sizes (Default)',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final variant in AppChipFilterVariant.values) ...[
                Text(variant.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: AppSpacing.space12,
                  runSpacing: AppSpacing.space12,
                  alignment: WrapAlignment.center,
                  children: AppChipSize.values
                      .map((s) => AppChipFilter(
                            label: _sizeLabel(s),
                            size: s,
                            variant: variant,
                            onPressed: () {},
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space20),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Active + Count',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final variant in AppChipFilterVariant.values) ...[
                Text(variant.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: AppSpacing.space12,
                  runSpacing: AppSpacing.space12,
                  alignment: WrapAlignment.center,
                  children: AppChipSize.values
                      .map((s) => AppChipFilter(
                            label: _sizeLabel(s),
                            size: s,
                            variant: variant,
                            isActive: true,
                            count: 3,
                            onPressed: () {},
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space20),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Expand 상태 (chevron 위)',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.space12,
            runSpacing: AppSpacing.space12,
            alignment: WrapAlignment.center,
            children: AppChipSize.values
                .map((s) => AppChipFilter(
                      label: _sizeLabel(s),
                      size: s,
                      state: AppChipFilterState.expand,
                      onPressed: () {},
                    ))
                .toList(),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disable 상태',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final variant in AppChipFilterVariant.values) ...[
                Text(variant.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: AppSpacing.space12,
                  runSpacing: AppSpacing.space12,
                  alignment: WrapAlignment.center,
                  children: AppChipSize.values
                      .map((s) => AppChipFilter(
                            label: _sizeLabel(s),
                            size: s,
                            variant: variant,
                            onPressed: null,
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space20),
              ],
            ],
          ),
        ),
      ),
    ],
  ),
];

String _sizeLabel(AppChipSize s) {
  switch (s) {
    case AppChipSize.xsmall:
      return 'XSmall';
    case AppChipSize.small:
      return 'Small';
    case AppChipSize.medium:
      return 'Medium';
    case AppChipSize.large:
      return 'Large';
  }
}

Widget _bg(BuildContext context, Widget child) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    color: isDark
        ? AppColor.darkBackgroundNormalNormal
        : AppColor.backgroundNormalNormal,
    padding: const EdgeInsets.all(AppSpacing.space24),
    alignment: Alignment.center,
    child: child,
  );
}
