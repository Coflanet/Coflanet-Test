import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 셸 상단 네비게이션 — 페이지 배경 기반 페이드 그라데이션 + 타이틀 + 슬롯.
///
/// Figma: Top Navigation/Top Navigation (NOT AppBar), 높이 56px 영역에
/// 타이틀 좌측 플러시. 편집모드: 중앙 타이틀 + leading/trailing 슬롯.
/// 그라데이션/타이틀 색은 테마 반응 — build 내부에서 AppColorScheme 해석.
///
/// [leading]/[trailing] 은 위젯 슬롯 — View 가 백버튼/편집버튼을 빌드해
/// 주입한다 (Get.find + 중첩 Obx 입자는 View 측 책임, 이 위젯은 controller
/// 미참조). 기존 공통 AppHeader 와는 정렬·폰트·슬롯 분기가 전부 달라
/// 통합하지 않는다 (shell 전용).
///
/// [topPadding] 은 View build 에서 1회 계산해 값으로 주입 — 콘텐츠 영역
/// topInset 계산과 출처를 단일화한다 (위젯 내부 MediaQuery 재조회 금지).
class ShellTopNavigation extends StatelessWidget {
  const ShellTopNavigation({
    super.key,
    required this.topPadding,
    required this.title,
    required this.isEditMode,
    this.leading,
    this.trailing,
  });

  /// 상태바 인셋 (View 의 MediaQuery.padding.top — 값 주입)
  final double topPadding;

  /// 타이틀 텍스트 (Rx 구독 보존을 위해 호출부 Obx 클로저에서 계산해 주입)
  final String title;

  /// 편집모드 여부 — true 면 타이틀 중앙 정렬 + headline2Bold
  final bool isEditMode;

  /// 좌측 슬롯 (편집모드 백버튼 — null 이면 타이틀이 좌측 플러시)
  final Widget? leading;

  /// 우측 슬롯 (원두 탭 편집/완료 버튼)
  final Widget? trailing;

  /// 네비게이션 영역 높이
  static const double navHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // 페이지 배경색 기반 페이드 그라데이션 (테마 반응)
    final Color navBase = colors.backgroundNormalAlternative;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      height: topPadding + navHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.7, 1.0],
          colors: [
            navBase.withValues(alpha: 0.0),
            navBase.withValues(alpha: 0.1),
            navBase.withValues(alpha: 0.3),
            navBase.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Leading 슬롯 — 편집모드에서만 (일반 모드는 타이틀 좌측 플러시)
            if (leading != null) leading!,

            // 타이틀 — 편집모드 중앙 / 일반 좌측 플러시
            // Figma Edit Mode: Headline 2/Bold - 17px, weight 600, line-height 141.2%
            Expanded(
              child: isEditMode
                  ? Center(
                      child: Text(
                        title,
                        style: AppTextStyles.headline2Bold.copyWith(
                          color: colors.labelStrong,
                        ),
                      ),
                    )
                  : Text(
                      title,
                      style: AppTextStyles.title3Bold.copyWith(
                        color: colors.labelStrong,
                        letterSpacing: -0.023,
                      ),
                    ),
            ),

            // Trailing 슬롯 — 원두 탭 편집/완료 버튼
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
