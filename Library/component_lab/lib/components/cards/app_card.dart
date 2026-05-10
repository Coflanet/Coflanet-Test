import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_shadow.dart';
import '../../foundation/app_spacing.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppRadius.radiusCardBorder;
    final bg = isDark
        ? AppColor.darkBackgroundElevatedNormal
        : AppColor.backgroundElevatedNormal;

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
            color: isDark
                ? AppColor.darkLineSolidNormal
                : AppColor.lineSolidNormal,
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
