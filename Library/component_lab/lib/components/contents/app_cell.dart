import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_decorate.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Cell 세로 패딩 — Figma `Cell/Cell` Vertical Padding variant.
enum AppCellVerticalPadding {
  /// Medium (12px)
  medium(12),

  /// Large (16px)
  large(16),

  /// Small (8px)
  small(8);

  const AppCellVerticalPadding(this.value);
  final double value;
}

/// Cell 세로 정렬 — Figma Vertical Align variant.
enum AppCellVerticalAlign {
  top,
  center,
}

/// 디자인 시스템 Cell — Figma `Cell/Cell`.
///
/// 128개 variant:
/// - Vertical Padding: Medium / Large / Small
/// - Vertical Align: Top / Center
/// - Fill Width: True / False
/// - Text Ellipsis: True / False
/// - Active: True / False
/// - Disable: True / False
class AppCell extends StatelessWidget {
  const AppCell({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
    this.verticalPadding = AppCellVerticalPadding.medium,
    this.verticalAlign = AppCellVerticalAlign.center,
    this.textEllipsis = false,
    this.isActive = false,
    this.isDisabled = false,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AppCellVerticalPadding verticalPadding;
  final AppCellVerticalAlign verticalAlign;
  final bool textEllipsis;
  final bool isActive;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          color: isActive
              ? AppDecorate.interactionNormalPressed
              : Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding.value,
            horizontal: AppSpacing.space16,
          ),
          child: Row(
            crossAxisAlignment: verticalAlign == AppCellVerticalAlign.top
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: AppSpacing.space12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.colorGlobalCoolNeutral50,
                        ),
                        maxLines: textEllipsis ? 1 : null,
                        overflow: textEllipsis
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible,
                      ),
                    Text(
                      title,
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: AppColor.colorGlobalCoolNeutral10,
                      ),
                      maxLines: textEllipsis ? 1 : null,
                      overflow: textEllipsis
                          ? TextOverflow.ellipsis
                          : TextOverflow.visible,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description!,
                        style: AppTextStyles.caption1Regular.copyWith(
                          color: AppColor.colorGlobalCoolNeutral50,
                        ),
                        maxLines: textEllipsis ? 2 : null,
                        overflow: textEllipsis
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSpacing.space12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
