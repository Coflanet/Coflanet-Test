import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Tooltip Compact 변형 — Figma `Tooltip/Compact`.
enum AppTooltipVariant {
  /// 어두운 배경
  normal,

  /// 밝은 배경
  inverse,
}

/// Tooltip Compact — Figma `Tooltip/Compact`.
///
/// Variant: Normal (다크) / Inverse (라이트)
class AppTooltipCompact extends StatelessWidget {
  const AppTooltipCompact({
    super.key,
    required this.message,
    this.variant = AppTooltipVariant.normal,
  });

  final String message;
  final AppTooltipVariant variant;

  @override
  Widget build(BuildContext context) {
    final isDark = variant == AppTooltipVariant.normal;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColor.colorGlobalCoolNeutral10
            : AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(AppRadius.radius8),
        boxShadow: isDark ? null : AppShadows.shadowBlackEmphasize,
      ),
      child: Text(
        message,
        style: AppTextStyles.caption1Regular.copyWith(
          color: isDark
              ? AppColor.colorGlobalCommon100
              : AppColor.colorGlobalCoolNeutral10,
        ),
      ),
    );
  }
}

/// Tooltip Extended — Figma `Tooltip/Extended`.
///
/// Close Button: True / False
class AppTooltipExtended extends StatelessWidget {
  const AppTooltipExtended({
    super.key,
    required this.title,
    required this.description,
    this.showCloseButton = false,
    this.onClose,
  });

  final String title;
  final String description;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacingSemantic.insetLg),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral10,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
                ),
              ),
              if (showCloseButton)
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            description,
            style: AppTextStyles.caption1Regular.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
