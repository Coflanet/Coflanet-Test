import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_decorate.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Bottom Sheet 리사이즈 모드 — Figma `Modal/Bottom Sheet` Resize variant.
enum AppBottomSheetResize {
  /// 콘텐츠에 맞춤
  hug,

  /// 유동적 높이
  flexible,

  /// 전체 높이
  fill,

  /// 고정 높이
  fixed,
}

/// Bottom Sheet — Figma `Modal/Bottom Sheet`.
///
/// Variant: Bottom, Size=Medium, Resize, Custom
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.showCloseButton = true,
    this.onClose,
  });

  final Widget child;
  final String? title;
  final bool showHandle;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          if (showHandle)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCoolNeutral90,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

          // Header
          if (title != null || showCloseButton)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
                vertical: AppSpacing.space12,
              ),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTextStyles.headline1Bold.copyWith(
                          color: AppColor.colorGlobalCoolNeutral10,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  if (showCloseButton)
                    GestureDetector(
                      onTap: onClose ?? () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: AppColor.colorGlobalCoolNeutral30,
                      ),
                    ),
                ],
              ),
            ),

          // Content
          child,
        ],
      ),
    );
  }

  /// BottomSheet를 모달로 표시하는 헬퍼.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool showHandle = true,
    bool showCloseButton = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: AppDecorate.dimmer,
      builder: (_) => AppBottomSheet(
        title: title,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        child: child,
      ),
    );
  }
}

/// Modal Popup — Figma `Modal/Popup`.
class AppModalPopup extends StatelessWidget {
  const AppModalPopup({
    super.key,
    required this.child,
    this.title,
    this.onClose,
    this.width = 320,
  });

  final Widget child;
  final String? title;
  final VoidCallback? onClose;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        margin: EdgeInsets.all(AppSpacing.space24),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100,
          borderRadius: BorderRadius.circular(AppRadius.radius20),
          boxShadow: AppShadows.shadowBlackFloating,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.space24,
                  AppSpacing.space24,
                  AppSpacing.space24,
                  AppSpacing.space16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTextStyles.heading1Bold.copyWith(
                          color: AppColor.colorGlobalCoolNeutral10,
                        ),
                      ),
                    ),
                    if (onClose != null)
                      GestureDetector(
                        onTap: onClose,
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: AppColor.colorGlobalCoolNeutral30,
                        ),
                      ),
                  ],
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  /// 모달 팝업을 다이얼로그로 표시.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppDecorate.dimmer,
      builder: (_) => AppModalPopup(
        title: title,
        onClose: () => Navigator.of(context).pop(),
        child: child,
      ),
    );
  }
}
