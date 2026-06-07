import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 홈 헤더용 — 반투명 회색 원 안에 SVG 아이콘 (다크 테마 헤더용).
///
/// 배경: 헤더 뒤가 단색 검정이라 BackdropFilter 블러는 시각 효과가 없고
/// 아이콘 가장자리에 뿌연 샘플링 아티팩트만 유발 → 불투명 회색 fill 로 대체.
/// 아이콘: SVG `fill="currentColor"` + Colors.white 로 확실한 흰색 tint.
/// [hasNotification] true → 우상단에 보라 점 (알림 dot).
/// [badgeCount] > 0 → 우상단에 숫자 뱃지 (장바구니 수량).
class HomeHeaderIconButton extends StatelessWidget {
  const HomeHeaderIconButton({
    super.key,
    required this.svgPath,
    required this.label,
    required this.onTap,
    this.hasNotification = false,
    this.badgeCount = 0,
  });

  /// 아이콘 SVG 에셋 경로
  final String svgPath;

  /// 접근성 라벨
  final String label;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 안 읽은 알림 dot 표시 여부
  final bool hasNotification;

  /// 숫자 뱃지 수량 (0 이면 미표시)
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 반투명 회색 원형 배경 + 아이콘
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.colorGlobalCoolNeutral60.withValues(
                    alpha: 0.8,
                  ),
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              // 알림 dot (우상단 보라 점) — 안 읽은 알림이 있을 때만
              if (hasNotification && badgeCount <= 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryNormal,
                    ),
                  ),
                ),
              // 숫자 뱃지 (장바구니 수량) — 1개 이상일 때만
              if (badgeCount > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 16),
                    height: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.primaryNormal,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: AppTextStyles.caption2Bold.copyWith(
                        color: AppColor.colorGlobalCommon100,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
