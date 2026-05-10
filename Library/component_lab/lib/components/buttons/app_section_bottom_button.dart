import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_text_style.dart';

/// Section Bottom 버튼 종류 — Figma `Button/Section Bottom/*` 3종.
enum AppSectionBottomVariant {
  /// 위쪽에 line + 텍스트 — 화면 최하단 안내·이동 버튼
  topLine,

  /// 그라데이션이 위로 페이드되는 fill 버튼
  solid,

  /// 펼침/접힘 토글 (더보기)
  fold,
}

/// 화면 하단에 고정되는 액션 버튼.
///
/// Figma `Button/Section Bottom/*` 3 variant — Top Line / Solid / Fold.
class AppSectionBottomButton extends StatelessWidget {
  final AppSectionBottomVariant variant;
  final String label;
  final VoidCallback? onPressed;
  final IconData? leftIcon;
  final IconData? rightIcon;

  /// `fold` variant 전용 — 펼침 상태
  final bool isExpanded;

  /// `fold` variant 전용 — Slim 사이즈 (40 → 32)
  final bool isSlim;

  /// `fold` variant 전용 — 그라데이션 마스크 적용
  final bool useMask;

  const AppSectionBottomButton({
    super.key,
    required this.label,
    this.variant = AppSectionBottomVariant.topLine,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.isExpanded = false,
    this.isSlim = false,
    this.useMask = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altColor = isDark
        ? AppColor.darkLabelAlternative
        : AppColor.labelAlternative;
    final lineColor = isDark
        ? AppColor.darkLineNormalNormal
        : AppColor.lineNormalNormal;
    final bg = isDark
        ? AppColor.darkBackgroundNormalNormal
        : AppColor.backgroundNormalNormal;

    switch (variant) {
      case AppSectionBottomVariant.topLine:
        return InkWell(
          onTap: onPressed,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lineColor, width: 1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leftIcon != null) ...[
                  Icon(leftIcon, size: 18, color: altColor),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppTextStyles.body1NormalRegular
                      .copyWith(color: altColor),
                ),
                if (rightIcon != null) ...[
                  const SizedBox(width: 6),
                  Icon(rightIcon, size: 18, color: altColor),
                ],
              ],
            ),
          ),
        );

      case AppSectionBottomVariant.solid:
        return Container(
          height: 48,
          // 그라데이션: 위쪽 투명 → 아래쪽 배경색 (페이드 효과)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bg.withValues(alpha: 0), bg],
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leftIcon != null) ...[
                  Icon(leftIcon, size: 18,
                      color: isDark
                          ? AppColor.darkLabelNormal
                          : AppColor.labelNormal),
                  const SizedBox(width: 10),
                ],
                Text(
                  label,
                  style: AppTextStyles.body1NormalBold.copyWith(
                    color: isDark
                        ? AppColor.darkLabelNormal
                        : AppColor.labelNormal,
                  ),
                ),
                if (rightIcon != null) ...[
                  const SizedBox(width: 10),
                  Icon(rightIcon, size: 18,
                      color: isDark
                          ? AppColor.darkLabelNormal
                          : AppColor.labelNormal),
                ],
              ],
            ),
          ),
        );

      case AppSectionBottomVariant.fold:
        // Figma: Slim=False(40h), Slim=True(32h), Mask=True(그라데이션)
        return InkWell(
          onTap: onPressed,
          child: Container(
            height: isSlim ? 32 : 40,
            decoration: BoxDecoration(
              gradient: useMask && !isExpanded
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [bg.withValues(alpha: 0), bg],
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isExpanded ? (label.isEmpty ? '접기' : label) : (label.isEmpty ? '더보기' : label),
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: altColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: altColor,
                ),
              ],
            ),
          ),
        );
    }
  }
}
