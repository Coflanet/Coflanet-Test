import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// 액션시트 스타일.
enum AppActionSheetStyle {
  /// iOS — 본문과 cancel을 분리된 카드로 표시.
  ios,

  /// Android — 단일 시트, cancel은 마지막 row 또는 dismiss로 처리.
  android,
}

/// 액션시트 단일 액션.
class AppActionSheetAction {
  const AppActionSheetAction({
    required this.label,
    this.onPressed,
    this.icon,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// true면 빨간 톤 (`statusNegative`).
  final bool isDestructive;
  final bool isDisabled;
}

/// Action Sheet — Figma `Modal/Action Sheet`.
///
/// 하단에서 올라오는 액션 메뉴. `.show()` 헬퍼 권장.
///
/// ```dart
/// AppActionSheet.show(
///   context,
///   title: '사진 추가',
///   actions: [
///     AppActionSheetAction(label: '카메라', icon: Icons.camera_alt),
///     AppActionSheetAction(label: '앨범에서 선택', icon: Icons.photo),
///     AppActionSheetAction(label: '삭제', isDestructive: true),
///   ],
/// );
/// ```
class AppActionSheet extends StatelessWidget {
  const AppActionSheet({
    super.key,
    required this.actions,
    this.title,
    this.message,
    this.cancelLabel = '취소',
    this.style = AppActionSheetStyle.ios,
  });

  final List<AppActionSheetAction> actions;
  final String? title;
  final String? message;
  final String cancelLabel;
  final AppActionSheetStyle style;

  /// `showModalBottomSheet`로 띄우는 헬퍼. 선택한 action의 인덱스를 반환,
  /// cancel/dismiss는 null.
  static Future<int?> show(
    BuildContext context, {
    required List<AppActionSheetAction> actions,
    String? title,
    String? message,
    String cancelLabel = '취소',
    AppActionSheetStyle style = AppActionSheetStyle.ios,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (sheetContext) => AppActionSheet(
        actions: actions,
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColor.darkBackgroundElevatedNormal
        : AppColor.backgroundElevatedNormal;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space8),
        child: switch (style) {
          AppActionSheetStyle.ios => _buildIos(context, cardColor),
          AppActionSheetStyle.android => _buildAndroid(context, cardColor),
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context, Color cardColor) {
    final hasHeader = title != null || message != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radius14),
          child: Container(
            color: cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasHeader) _Header(title: title, message: message),
                if (hasHeader && actions.isNotEmpty) const _Divider(),
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const _Divider(),
                  _ActionRow(
                    action: actions[i],
                    onTap: () => Navigator.pop(context, i),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radius14),
          child: Container(
            color: cardColor,
            child: _ActionRow(
              action: AppActionSheetAction(label: cancelLabel),
              onTap: () => Navigator.pop(context),
              isCancel: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid(BuildContext context, Color cardColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius20),
      child: Container(
        color: cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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
            if (title != null || message != null)
              _Header(title: title, message: message, compact: true),
            for (var i = 0; i < actions.length; i++)
              _ActionRow(
                action: actions[i],
                onTap: () => Navigator.pop(context, i),
              ),
            const SizedBox(height: AppSpacing.space8),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.title, this.message, this.compact = false});

  final String? title;
  final String? message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: compact ? AppSpacing.space12 : AppSpacing.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: AppTextStyles.label1NormalBold.copyWith(
                color: AppColor.labelNeutral,
              ),
            ),
          if (title != null && message != null) const SizedBox(height: 4),
          if (message != null)
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 0.5, color: AppColor.lineSolidNeutral);
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.action,
    required this.onTap,
    this.isCancel = false,
  });

  final AppActionSheetAction action;
  final VoidCallback onTap;
  final bool isCancel;

  @override
  Widget build(BuildContext context) {
    final color = action.isDestructive
        ? AppColor.statusNegative
        : (action.isDisabled
            ? AppColor.labelDisable
            : AppColor.labelNormal);
    final style = (isCancel
            ? AppTextStyles.body1NormalBold
            : AppTextStyles.body1NormalMedium)
        .copyWith(color: color);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.isDisabled ? null : onTap,
        child: Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (action.icon != null) ...[
                Icon(action.icon, size: 20, color: color),
                const SizedBox(width: AppSpacing.space8),
              ],
              Flexible(
                child: Text(
                  action.label,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
