import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/modules/home/widgets/home_header_icon_button.dart';

/// 홈 상단 헤더 — 좌측 보라 로고 SVG + 우측 검색/알림/장바구니 아이콘.
///
/// 페이지 배경 위에 보라 로고, 우측 액션은 반투명 회색 원 안의 아이콘 (테마 반응).
/// 반응형 값([hasUnread], [cartBadgeCount])은 호출부에서 Obx 로 풀어 주입한다.
/// [백엔드 API 연동 대기] 각 액션의 실제 동작 (검색, 알림 카운트, 장바구니 카운트)
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.onSearchTap,
    required this.onNotificationTap,
    required this.onCartTap,
    this.hasUnread = false,
    this.cartBadgeCount = 0,
  });

  /// 검색 아이콘 탭 콜백
  final VoidCallback onSearchTap;

  /// 알림 아이콘 탭 콜백
  final VoidCallback onNotificationTap;

  /// 장바구니 아이콘 탭 콜백
  final VoidCallback onCartTap;

  /// 안 읽은 알림 존재 여부 (알림 dot)
  final bool hasUnread;

  /// 장바구니에 담긴 상품 종류 수 (숫자 뱃지)
  final int cartBadgeCount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 로고 — assets/images/logo_main.svg 의 상단 아이콘 부분만 표시.
          // SVG ViewBox 150x126 중 아이콘은 위쪽 ~88px, "Coflanet" 텍스트는 아래쪽.
          // OverflowBox 로 SVG 자유 크기 + ClipRect 로 상단 28px 영역만 노출.
          // SVG width 48 → 자동 height = 48 * 126/150 = 40.32px, 그 중 28px (≈ 아이콘 88/126) 만 보임.
          Semantics(
            label: 'Coflanet',
            image: true,
            child: SizedBox(
              width: 48,
              height: 28,
              child: ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/logo_main.svg',
                    width: 48,
                    // 페이지 배경 위 보라 로고 (Figma) — SVG 원본 색 무시하고 틴트
                    colorFilter: ColorFilter.mode(
                      colors.primaryNormal,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              HomeHeaderIconButton(
                svgPath: 'assets/icons/ic_search.svg',
                label: '검색',
                onTap: onSearchTap,
              ),
              const SizedBox(width: 8),
              HomeHeaderIconButton(
                svgPath: 'assets/icons/ic_bell.svg',
                label: '알림',
                hasNotification: hasUnread,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 8),
              HomeHeaderIconButton(
                svgPath: 'assets/icons/ic_bag.svg',
                label: '장바구니',
                badgeCount: cartBadgeCount,
                onTap: onCartTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
