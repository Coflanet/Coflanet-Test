import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 셸 하단 탭바 — Figma `Home_Item_yes` 기준 5탭, pill-shaped liquid glass.
///
/// 배경 패널 없이 투명 — pill glass 컨테이너만 화면 위에 떠 있다
/// (BackdropFilter 블러 + 어두운 틴트).
/// **의도적으로 테마와 무관한 "항상 다크 글래스" 고정 디자인** — 어떤 배경
/// (라이트/다크) 위에서도 동일한 룩을 유지한다. 따라서 이 위젯은
/// AppColorScheme 을 일절 사용하지 않는다 (테마 회귀 구조적 차단):
/// - raw 팔레트 const: coolNeutral15(틴트) / violet60(활성) / common0(활성 pill)
/// - `AppColor.inverseLabelNeutral` 은 **static 시맨틱 getter**(라이트 고정값,
///   테마 무관) — `colors.inverseLabelNeutral`(AppColorScheme) 로 치환하면
///   다크에서 값이 뒤집혀 비활성 탭이 배경에 묻힌다. 치환 금지.
/// - 활성색 violet60 은 편집버튼의 `colors.primaryNormal` 과 다크에서만
///   우연히 일치 — 공통화 금지 (라이트에서 violet50 으로 달라짐).
///
/// [currentIndex] 는 호출부 Obx 클로저에서 평가해 값으로 주입한다.
class ShellTabBar extends StatelessWidget {
  const ShellTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  /// 현재 활성 탭 index
  final int currentIndex;

  /// 탭 선택 콜백
  final ValueChanged<int> onTabTapped;

  /// 5개 탭 데이터 — 홈, 원두, 커뮤니티, 쇼핑, 마이.
  /// View 의 상단 네비 타이틀 계산(navTitle)도 이 리스트를 단일 출처로 쓴다.
  /// Icons: filled for selected, outline for unselected.
  static const List<ShellTabData> tabs = [
    ShellTabData(
      iconFilled: Icons.home_rounded,
      iconOutline: Icons.home_outlined,
      label: '홈',
      navTitle: '홈',
    ),
    ShellTabData(
      iconFilled: Icons.coffee_rounded,
      iconOutline: Icons.coffee_outlined,
      label: '원두',
      navTitle: '원두 목록',
    ),
    ShellTabData(
      iconFilled: Icons.forum_rounded,
      iconOutline: Icons.forum_outlined,
      label: '커뮤니티',
      navTitle: '커뮤니티',
    ),
    ShellTabData(
      iconFilled: Icons.shopping_bag_rounded,
      iconOutline: Icons.shopping_bag_outlined,
      label: '쇼핑',
      navTitle: '쇼핑',
    ),
    ShellTabData(
      iconFilled: Icons.person_rounded,
      iconOutline: Icons.person_outline_rounded,
      label: '마이',
      navTitle: 'My 행성',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 5개 탭을 수용하기 위해 화면 너비에서 좌우 16px 여백을 뺀 폭 사용.
    final screenWidth = MediaQuery.of(context).size.width;
    final innerWidth = (screenWidth - 32).clamp(280.0, 400.0);

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      child: Center(
        child: SizedBox(
          width: innerWidth,
          height: 64,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCoolNeutral15.withValues(
                    alpha: 0.72,
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(tabs.length, (index) {
                    // key 부여 금지 — 위치 기반 엘리먼트 매칭이
                    // AnimatedContainer 의 암시적 애니메이션을 보존한다.
                    return Expanded(
                      child: _ShellTabItem(
                        tab: tabs[index],
                        isActive: index == currentIndex,
                        onTap: () => onTabTapped(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 개별 탭 아이템 — Figma:
/// - Active: Black background @ 35% opacity, pill shape (99px radius)
/// - Active color: #7D5EF7 (violet60) / Inactive: rgba(194, 196, 200, 0.88)
class _ShellTabItem extends StatelessWidget {
  const _ShellTabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final ShellTabData tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Colors per Figma CSS — 항상 다크 글래스 고정 (AppColorScheme 미사용)
    const activeColor = AppColor.colorGlobalViolet60; // Figma: #7D5EF7
    final inactiveColor =
        AppColor.inverseLabelNeutral; // rgba(194, 196, 200, 0.88) static getter

    final iconColor = isActive ? activeColor : inactiveColor;
    final labelColor = isActive ? activeColor : inactiveColor;

    // 선택 시 filled, 미선택 시 outline 아이콘
    final icon = isActive ? tab.iconFilled : tab.iconOutline;

    return Semantics(
      label: '${tab.label} 탭',
      selected: isActive,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56, // 64px 컨테이너 높이 대부분을 채움
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            // Figma: Active = black @ 35% opacity, pill shape
            color: isActive
                ? AppColor.colorGlobalCommon0.withValues(alpha: 0.35)
                : AppColor.transparent,
            borderRadius: BorderRadius.circular(99), // Pill shape
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(height: 2),
              // 5탭 수용: 라벨이 잘리지 않도록 줄임 + Auto-shrink
              Text(
                tab.label,
                style: AppTextStyles.caption2Medium.copyWith(color: labelColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 탭 데이터 모델 (라벨/아이콘/상단 네비 타이틀)
class ShellTabData {
  final IconData iconFilled; // 선택 상태 filled 아이콘
  final IconData iconOutline; // 미선택 상태 outline 아이콘
  final String label; // 탭바 라벨
  final String navTitle; // 상단 네비게이션 타이틀

  const ShellTabData({
    required this.iconFilled,
    required this.iconOutline,
    required this.label,
    required this.navTitle,
  });
}
