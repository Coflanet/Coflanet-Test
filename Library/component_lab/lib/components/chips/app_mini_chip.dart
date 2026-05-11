import 'package:flutter/material.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_text_style.dart';

/// 작은 정보성 chip (브랜드·향미·태그 등). 보조 라벨 노출이 목적이라
/// `AppChipAction`/`AppChipFilter`처럼 size 매트릭스가 없고 단일 사이즈.
///
/// 톤별 디자인:
/// - `neutral` (default): `componentFillAlternative` 배경 + `labelNormal` 텍스트
/// - `primary`           : `primaryLight` 배경 + `primaryNormal` 텍스트
enum AppMiniChipTone { neutral, primary }

class AppMiniChip extends StatelessWidget {
  const AppMiniChip({
    super.key,
    required this.label,
    this.tone = AppMiniChipTone.neutral,
    this.onTap,
  });

  final String label;
  final AppMiniChipTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final (bg, fg, padding, radius, style) = switch (tone) {
      AppMiniChipTone.neutral => (
          c.componentFillAlternative,
          c.labelNormal,
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          AppRadius.radius8,
          AppTextStyles.label2Regular,
        ),
      AppMiniChipTone.primary => (
          c.primaryLight,
          c.primaryNormal,
          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          AppRadius.radius4,
          AppTextStyles.caption1Bold,
        ),
    };

    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(label, style: style.copyWith(color: fg)),
    );

    if (onTap == null) return body;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: body,
    );
  }
}
