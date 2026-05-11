import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Toast 변형 — Figma `Toast/Toast` Variant.
enum AppToastVariant {
  /// 기본 (중립)
  normal(
    bgColor: Color(0xFF171719), // CoolNeutral10
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.info_outline,
  ),

  /// 성공
  positive(
    bgColor: Color(0xFF171719),
    iconColor: Color(0xFF00C853),
    icon: Icons.check_circle_outline,
  ),

  /// 주의
  cautionary(
    bgColor: Color(0xFF171719),
    iconColor: Color(0xFFFFC107),
    icon: Icons.warning_amber,
  ),

  /// 에러
  negative(
    bgColor: Color(0xFF171719),
    iconColor: Color(0xFFFF5252),
    icon: Icons.error_outline,
  );

  const AppToastVariant({
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });

  final Color bgColor;
  final Color iconColor;
  final IconData icon;
}

/// Toast 컴포넌트 — Figma `Toast/Toast`.
///
/// Variant: Normal / Positive / Cautionary / Negative
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.variant = AppToastVariant.normal,
    this.action,
    this.onAction,
    this.showIcon = true,
  });

  final String message;
  final AppToastVariant variant;
  final String? action;
  final VoidCallback? onAction;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.space16),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      decoration: BoxDecoration(
        color: variant.bgColor,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
        boxShadow: AppShadows.shadowBlackStrong,
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(variant.icon, size: 20, color: variant.iconColor),
            SizedBox(width: AppSpacing.space8),
          ],
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: AppColor.colorGlobalCommon100,
              ),
            ),
          ),
          if (action != null) ...[
            SizedBox(width: AppSpacing.space8),
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: AppTextStyles.label1NormalBold.copyWith(
                  color: AppColor.colorGlobalCommon100,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Toast를 OverlayEntry로 표시하는 헬퍼.
  static void show(
    BuildContext context, {
    required String message,
    AppToastVariant variant = AppToastVariant.normal,
    String? action,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    // 이중 제거 방지 — action tap + duration 만료가 동시에 일어나는 경합 가드.
    bool removed = false;
    void removeOnce() {
      if (removed) return;
      removed = true;
      if (entry.mounted) entry.remove();
    }

    entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: AppToast(
            message: message,
            variant: variant,
            action: action,
            onAction: () {
              onAction?.call();
              removeOnce();
            },
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, removeOnce);
  }
}
