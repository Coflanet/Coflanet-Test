import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// Card variant.
enum AppCardVariant {
  /// 평평한 카드 (배경색만, 그림자 없음)
  flat,

  /// 그림자 있는 elevated 카드
  elevated,

  /// 테두리 있는 outlined 카드
  outlined,
}

/// 디자인 시스템 표준 카드.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final BorderRadius? borderRadius;
  final double? width;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.space16),
    this.onTap,
    this.variant = AppCardVariant.elevated,
    this.borderRadius,
    this.width,
  });

  /// List 스타일 카드 — Figma `Card/List` 변형. leading / 중앙(title+subtitle) / trailing
  /// 슬롯이 명시적으로 노출된 행 카드. 일반 `AppCard()`처럼 `child`에 임의의 위젯을
  /// 넣는 자유도는 trade-off로 잃지만 목록형 행에 최적화된 정렬·spacing을 제공.
  factory AppCard.list({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    AppCardVariant variant = AppCardVariant.outlined,
    BorderRadius? borderRadius,
    double? width,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.space16,
      vertical: AppSpacing.space12,
    ),
  }) {
    return AppCard(
      key: key,
      padding: padding,
      onTap: onTap,
      variant: variant,
      borderRadius: borderRadius,
      width: width,
      child: _ListCardRow(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final radius = borderRadius ?? AppRadius.radiusCardBorder;
    final bg = c.backgroundElevatedNormal;

    final decoration = switch (variant) {
      AppCardVariant.flat => BoxDecoration(
          color: bg,
          borderRadius: radius,
        ),
      AppCardVariant.elevated => BoxDecoration(
          color: bg,
          borderRadius: radius,
          boxShadow: AppShadows.shadowBlackEmphasize,
        ),
      AppCardVariant.outlined => BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(
            color: c.lineSolidNormal,
            width: 1,
          ),
        ),
    };

    final inner = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    final card = onTap != null
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: inner,
            ),
          )
        : inner;

    return SizedBox(width: width, child: card);
  }
}

class _ListCardRow extends StatelessWidget {
  const _ListCardRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.space12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: c.labelNormal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: c.labelAlternative,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.space12),
          trailing!,
        ],
      ],
    );
  }
}
