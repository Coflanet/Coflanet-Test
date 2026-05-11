import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Snackbar 컴포넌트 — Figma `Snackbar/Snackbar`.
///
/// Variant: Normal (단일)
/// Toast보다 정보가 풍부한 알림으로, 아이콘 + 메시지 + 액션 버튼 포함.
class AppSnackbar extends StatelessWidget {
  const AppSnackbar({
    super.key,
    required this.message,
    this.description,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.icon,
  });

  final String message;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.space16),
      padding: EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(AppRadius.radius16),
        boxShadow: AppShadows.shadowBlackHeavy,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColor.colorGlobalCoolNeutral30),
            SizedBox(width: AppSpacing.space12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: AppTextStyles.label1NormalBold.copyWith(
                    color: AppColor.colorGlobalCoolNeutral10,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    description!,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.colorGlobalCoolNeutral50,
                    ),
                  ),
                ],
                if (actionLabel != null) ...[
                  SizedBox(height: AppSpacing.space8),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: AppTextStyles.label1NormalBold.copyWith(
                        color: AppColor.colorGlobalCoolNeutral10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: AppSpacing.space8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 20,
                color: AppColor.colorGlobalCoolNeutral50,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
