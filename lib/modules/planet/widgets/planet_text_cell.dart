import 'package:flutter/material.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 마이플래닛 탭 가능 텍스트 셀 — height 48, 좌측 정렬 단일 라벨.
///
/// 계정 셀(계정 연결/로그아웃/회원탈퇴)과 법적 링크(개인정보처리방침/이용약관)가
/// 공유한다. 테마 셀(우측 모드 라벨 + chevron 구조)은 골격이 달라 이 셀을 쓰지
/// 않는다. lib/widgets/ 승격은 두 번째 화면 사용처 확정 전까지 보류 (planet 전용).
class PlanetTextCell extends StatelessWidget {
  const PlanetTextCell({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  /// 셀 라벨
  final String text;

  /// 라벨 색 (항목별 의미색 — 호출부 주입)
  final Color color;

  /// 탭 콜백
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48, // Figma: 48px
        padding: const EdgeInsets.symmetric(vertical: 12), // Figma: 12px 0
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: AppTextStyles.body1NormalRegular.copyWith(color: color),
        ),
      ),
    );
  }
}
