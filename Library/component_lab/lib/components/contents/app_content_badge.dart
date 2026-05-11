import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// Content Badge variant — Figma `Contents/Content Badge`.
enum AppContentBadgeVariant { solid, outlined }

/// Content Badge color — Figma `Contents/Content Badge` color.
enum AppContentBadgeColor {
  /// 회색 톤 (기본)
  neutral,

  /// 시안 톤 — primary accent
  accent,

  /// 초록 톤 — 성공/완료 상태 강조
  success,

  /// 주황 톤 — 경고
  warning,

  /// 파랑 톤 — 정보성
  info,
}

/// Content Badge size — Figma `Contents/Content Badge` size.
enum AppContentBadgeSize {
  /// 12px font, 6px H pad
  xsmall,

  /// 13px font, 8px H pad (default)
  small,

  /// 14px font, 10px H pad
  medium,
}

/// Content Badge — Figma `Contents/Content Badge`.
///
/// 콘텐츠 상태/속성을 시각적으로 강조하는 작은 pill.
/// `AppChip` 보다 가벼운 표시용 라벨로 디자인 의도가 다르다.
class AppContentBadge extends StatelessWidget {
  const AppContentBadge({
    super.key,
    required this.label,
    this.variant = AppContentBadgeVariant.solid,
    this.color = AppContentBadgeColor.neutral,
    this.size = AppContentBadgeSize.small,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final AppContentBadgeVariant variant;
  final AppContentBadgeColor color;
  final AppContentBadgeSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  ({double padH, double padV, double iconSize, TextStyle text}) _spec() {
    switch (size) {
      case AppContentBadgeSize.xsmall:
        return (
          padH: 6,
          padV: 2,
          iconSize: 10,
          text: AppTextStyles.caption2Medium,
        );
      case AppContentBadgeSize.small:
        return (
          padH: 8,
          padV: 3,
          iconSize: 12,
          text: AppTextStyles.caption1Medium,
        );
      case AppContentBadgeSize.medium:
        return (
          padH: 10,
          padV: 4,
          iconSize: 14,
          text: AppTextStyles.label2Medium,
        );
    }
  }

  ({Color bg, Color fg, Color border}) _colors() {
    final tone = switch (color) {
      AppContentBadgeColor.neutral => (
          solidBg: AppColor.lineSolidNormal,
          fg: AppColor.labelAlternative,
          outlineBorder: AppColor.lineNormalNormal,
        ),
      AppContentBadgeColor.accent => (
          solidBg: AppColor.colorGlobalCyan95,
          fg: AppColor.accentForegroundCyan,
          outlineBorder: AppColor.accentForegroundCyan,
        ),
      AppContentBadgeColor.success => (
          solidBg: AppColor.colorGlobalGreen95,
          fg: AppColor.accentForegroundGreen,
          outlineBorder: AppColor.accentForegroundGreen,
        ),
      AppContentBadgeColor.warning => (
          solidBg: AppColor.colorGlobalOrange95,
          fg: AppColor.accentForegroundOrange,
          outlineBorder: AppColor.accentForegroundOrange,
        ),
      AppContentBadgeColor.info => (
          solidBg: AppColor.colorGlobalBlue95,
          fg: AppColor.accentForegroundBlue,
          outlineBorder: AppColor.accentForegroundBlue,
        ),
    };
    if (variant == AppContentBadgeVariant.solid) {
      return (
        bg: tone.solidBg,
        fg: tone.fg,
        border: AppColor.transparent,
      );
    }
    return (
      bg: AppColor.transparent,
      fg: tone.fg,
      border: tone.outlineBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec();
    final c = _colors();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spec.padH, vertical: spec.padV),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(AppRadius.radiusPill),
        border: c.border == AppColor.transparent
            ? null
            : Border.all(color: c.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: spec.iconSize, color: c.fg),
            const SizedBox(width: 2),
          ],
          Text(label, style: spec.text.copyWith(color: c.fg)),
          if (trailingIcon != null) ...[
            const SizedBox(width: 2),
            Icon(trailingIcon, size: spec.iconSize, color: c.fg),
          ],
        ],
      ),
    );
  }
}
