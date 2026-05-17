import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Menu 변형 — Figma `Menu/Menu` Variant.
enum AppMenuVariant {
  /// 일반 메뉴 항목
  normal,

  /// 라디오 선택
  radio,

  /// 체크박스 선택
  checkbox,
}

/// Menu 셀 패딩 — Figma Cell Padding variant.
enum AppMenuCellPadding {
  /// 12px 세로 패딩
  px12(12),

  /// 8px 세로 패딩
  px8(8);

  const AppMenuCellPadding(this.value);
  final double value;
}

/// Menu 항목 데이터.
class AppMenuItem {
  const AppMenuItem({
    required this.label,
    this.icon,
    this.subtitle,
    this.isSelected = false,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  final String label;
  final IconData? icon;
  final String? subtitle;
  final bool isSelected;
  final bool isDestructive;
  final bool isDisabled;
}

/// Menu 컴포넌트 — Figma `Menu/Menu`.
///
/// Variant: Normal / Radio / Checkbox
/// Cell Padding: 12px / 8px
class AppMenu extends StatelessWidget {
  const AppMenu({
    super.key,
    required this.items,
    required this.onItemTap,
    this.variant = AppMenuVariant.normal,
    this.cellPadding = AppMenuCellPadding.px12,
    this.width = 240,
  });

  final List<AppMenuItem> items;
  final ValueChanged<int> onItemTap;
  final AppMenuVariant variant;
  final AppMenuCellPadding cellPadding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        boxShadow: AppShadows.shadowBlackStrong,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (i) {
            return _MenuCell(
              item: items[i],
              variant: variant,
              padding: cellPadding.value,
              onTap: items[i].isDisabled ? null : () => onItemTap(i),
              showDivider: i < items.length - 1,
            );
          }),
        ),
      ),
    );
  }
}

class _MenuCell extends StatelessWidget {
  const _MenuCell({
    required this.item,
    required this.variant,
    required this.padding,
    this.onTap,
    this.showDivider = false,
  });

  final AppMenuItem item;
  final AppMenuVariant variant;
  final double padding;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: item.isDisabled ? 0.4 : 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: padding,
              ),
              child: Row(
                children: [
                  // Leading: Radio/Checkbox 인디케이터
                  if (variant == AppMenuVariant.radio) ...[
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: item.isSelected
                              ? AppColor.colorGlobalCoolNeutral10
                              : AppColor.colorGlobalCoolNeutral80,
                          width: item.isSelected ? 6 : 1.5,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.s12),
                  ] else if (variant == AppMenuVariant.checkbox) ...[
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: item.isSelected
                            ? AppColor.colorGlobalCoolNeutral10
                            : Colors.transparent,
                        border: item.isSelected
                            ? null
                            : Border.all(
                                color: AppColor.colorGlobalCoolNeutral80,
                                width: 1.5,
                              ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: item.isSelected
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: AppSpacing.s12),
                  ],

                  // Icon
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 20,
                      color: item.isDestructive
                          ? Colors.red
                          : AppColor.colorGlobalCoolNeutral30,
                    ),
                    SizedBox(width: AppSpacing.s8),
                  ],

                  // Label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.label,
                          style: AppTextStyles.body2NormalRegular.copyWith(
                            color: item.isDestructive
                                ? Colors.red
                                : AppColor.colorGlobalCoolNeutral10,
                          ),
                        ),
                        if (item.subtitle != null)
                          Text(
                            item.subtitle!,
                            style: AppTextStyles.caption1Regular.copyWith(
                              color: AppColor.colorGlobalCoolNeutral50,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Selected check (normal variant)
                  if (variant == AppMenuVariant.normal && item.isSelected)
                    Icon(
                      Icons.check,
                      size: 20,
                      color: AppColor.colorGlobalCoolNeutral10,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            color: AppColor.colorGlobalCoolNeutral97,
          ),
      ],
    );
  }
}
