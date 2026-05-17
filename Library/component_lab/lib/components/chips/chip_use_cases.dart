import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_spacing.dart';
import 'app_chip.dart';
import 'app_chip_action.dart';
import 'app_chip_filter.dart';

// ═══════════════════════════════════════════════════════════════
// CHIP / BASIC — `AppChip` (13 colors × 2 sizes)
// ═══════════════════════════════════════════════════════════════
final List<WidgetbookComponent> chipBasicUseCases = [
  WidgetbookComponent(
    name: 'Basic',
    useCases: [
      WidgetbookUseCase(
        name: '13 colors × 2 sizes',
        builder: (context) => _bg(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final size in AppChipTagSize.values) ...[
                Text(
                  size == AppChipTagSize.sm ? 'Small' : 'Medium',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  alignment: WrapAlignment.center,
                  children: AppChipColor.values
                      .map((color) => AppChip(
                            label: color.name,
                            color: color,
                            size: size,
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.s20),
              ],
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Leading icon',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            alignment: WrapAlignment.center,
            children: const [
              AppChip(
                label: 'Coffee',
                color: AppChipColor.brown,
                leadingIcon: Icons.coffee_rounded,
              ),
              AppChip(
                label: 'New',
                color: AppChipColor.primary,
                leadingIcon: Icons.fiber_new_rounded,
              ),
              AppChip(
                label: 'Sale',
                color: AppChipColor.red,
                leadingIcon: Icons.local_offer_rounded,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Deletable + onTap',
        builder: (context) => _bg(
          context,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            alignment: WrapAlignment.center,
            children: [
              AppChip(
                label: 'Tap me',
                color: AppChipColor.primary,
                onTap: () {},
              ),
              AppChip(
                label: 'Remove',
                color: AppChipColor.neutral,
                onDelete: () {},
              ),
              AppChip(
                label: 'Both',
                color: AppChipColor.violet,
                onTap: () {},
                onDelete: () {},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
];

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
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s20),
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
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s20),
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
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s20),
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
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s20),
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
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s20),
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
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s8),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
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
                const SizedBox(height: AppSpacing.s20),
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
    padding: const EdgeInsets.all(AppSpacing.s24),
    alignment: Alignment.center,
    child: child,
  );
}
