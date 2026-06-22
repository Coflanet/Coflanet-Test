import 'package:flutter/material.dart';

import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// iyumi 카드 패턴의 **큰 카드(CardSection)** — radius 40, 풀폭, surfaceCard 표면.
///
/// 검정 캔버스 위에 떠 있는 섹션 카드. 그림자/아웃라인 없이 표면 명도 대비로
/// 분리한다. 내부 색은 [AppColorScheme.of] (활성 스킴) 기준 — 라이트=흰 카드,
/// 다크=다크 카드(task 4 방향 B). 수치는 전부 cds 토큰.
///
/// 사용:
/// ```dart
/// CardSection(
///   title: '보유 원두',
///   trailing: TextButton(...),
///   child: Column(...),
/// )
/// ```
class CardSection extends StatelessWidget {
  const CardSection({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.padding,
    this.color,
    this.onTap,
  });

  /// 카드 본문
  final Widget child;

  /// 카드 상단 타이틀 (없으면 헤더 영역 생략)
  final String? title;

  /// 타이틀 우측 액션 (예: '더 보기')
  final Widget? trailing;

  /// 패딩 오버라이드 (기본 [AppSpacing.sectionPadding] = 24/32)
  final EdgeInsets? padding;

  /// 표면색 오버라이드 (기본 surfaceCard, 틴트 카드는 colors.primaryLight 등)
  final Color? color;

  /// 카드 전체 탭 콜백 (null 이면 비탭)
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    final content = Container(
      width: double.infinity,
      padding: padding ?? AppSpacing.sectionPadding,
      decoration: BoxDecoration(
        color: color ?? colors.surfaceCard,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: colors.labelStrong,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          child,
        ],
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }
}

/// iyumi 카드 패턴의 **작은 카드(CardItem)** — radius 24, 큰 카드 안 인셋.
///
/// 기본 표면은 surfaceCardStrong (큰 카드 표면에 가까운 톤으로 은은한 중첩).
class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    final content = Container(
      padding: padding ?? AppSpacing.itemPadding,
      decoration: BoxDecoration(
        color: color ?? colors.surfaceCardStrong,
        borderRadius: AppRadius.itemRadiusBorder,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }
}

/// 카드 사이 공통 간격 (4) — Row/Column 양쪽에서 쓸 수 있게 width/height 동시 지정.
class CardGap extends StatelessWidget {
  const CardGap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSpacing.cardGap,
      height: AppSpacing.cardGap,
    );
  }
}
