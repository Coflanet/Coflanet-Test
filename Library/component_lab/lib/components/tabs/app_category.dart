import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Category 변형 — Figma `Category/Category` Variant.
enum AppCategoryVariant {
  /// 기본 스타일 (밑줄 인디케이터 없음, 채움 배경)
  normal,

  /// 대안 스타일 (배경 대비 강조)
  alternative,
}

/// Category 사이즈 — Figma 4단계.
enum AppCategorySize {
  /// Large (48h)
  large(48),

  /// Medium (36h)
  medium(36),

  /// Small (32h)
  small(32),

  /// XSmall (28h)
  xsmall(28);

  const AppCategorySize(this.height);
  final double height;
}

/// Category 컴포넌트 — Figma `Category/Category`.
///
/// 정보를 목적 구조에 따라 나누거나 분류를 위한 컴포넌트.
/// Tab과 달리 칩 형태로 표시됩니다.
///
/// Variant: Normal / Alternative
/// Size: Medium / Small
/// Horizontal Padding: True / False
class AppCategory extends StatelessWidget {
  const AppCategory({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = AppCategoryVariant.normal,
    this.size = AppCategorySize.medium,
    this.horizontalPadding = false,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppCategoryVariant variant;
  final AppCategorySize size;
  final bool horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: horizontalPadding
          ? EdgeInsets.symmetric(horizontal: AppSpacing.space16)
          : EdgeInsets.zero,
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = i == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: i < items.length - 1 ? 8 : 0),
            child: _CategoryChip(
              label: items[i],
              isActive: isActive,
              variant: variant,
              height: size.height,
              onTap: () => onChanged(i),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isActive,
    required this.variant,
    required this.height,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final AppCategoryVariant variant;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNormal = variant == AppCategoryVariant.normal;

    Color bgColor;
    Color textColor;
    Border? border;

    if (isActive) {
      bgColor = isNormal
          ? AppColor.colorGlobalCoolNeutral10
          : AppColor.primaryNormal;
      textColor = AppColor.colorGlobalCommon100;
      border = null;
    } else {
      bgColor = isNormal
          ? AppColor.colorGlobalCommon100
          : AppColor.colorGlobalCoolNeutral99;
      textColor = AppColor.colorGlobalCoolNeutral40;
      border = isNormal
          ? Border.all(color: AppColor.colorGlobalCoolNeutral95, width: 1)
          : null;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.label1NormalBold.copyWith(color: textColor),
        ),
      ),
    );
  }
}
