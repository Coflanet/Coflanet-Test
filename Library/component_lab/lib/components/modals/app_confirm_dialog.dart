import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';
import '../buttons/app_solid_button.dart';
import '../buttons/app_outlined_button.dart';

/// Confirm 다이얼로그 — 시각적 확인용 위젯.
///
/// 실제 띄울 때는 [showAppConfirmDialog] 헬퍼 사용.
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;

  /// 확인 버튼이 negative 동작인 경우 (삭제 등) 빨간색
  final bool isDestructive;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bg = c.backgroundElevatedNormal;
    final labelColor =
        c.labelNormal;
    final altColor = c.labelNeutral;

    final confirmButton = AppSolidButton(
      label: confirmText,
      size: AppSolidButtonSize.medium,
      width: double.infinity,
      tone: isDestructive
          ? AppSolidButtonTone.gray
          : AppSolidButtonTone.primary,
      onPressed: onConfirm,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.space24),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppRadius.radiusModalBorder,
            boxShadow: AppShadows.shadowBlackHeavy,
          ),
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.heading2Bold.copyWith(color: labelColor),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.space8),
                Text(
                  message!,
                  style: AppTextStyles.body2NormalRegular
                      .copyWith(color: altColor),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.space24),
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      label: cancelText,
                      size: AppOutlinedButtonSize.medium,
                      width: double.infinity,
                      tone: AppOutlinedButtonTone.assistive,
                      onPressed: onCancel,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space8),
                  Expanded(child: confirmButton),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirm 다이얼로그를 띄우는 헬퍼.
/// `true` = 확인, `false`/`null` = 취소.
Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  String confirmText = '확인',
  String cancelText = '취소',
  bool isDestructive = false,
  bool barrierDismissible = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => AppConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
      onConfirm: () => Navigator.of(ctx).pop(true),
      onCancel: () => Navigator.of(ctx).pop(false),
    ),
  );
}
