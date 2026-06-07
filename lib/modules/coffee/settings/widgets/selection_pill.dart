import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';

/// 잔수/진하기 선택 필 — 보라 연배경 + 보라 보더 카드.
///
/// Figma: background Violet95, border 1px Violet80, radius 24,
/// main 18/w600/primaryStrong + sub 14/w400/labelAlternative.
///
/// [mainText] 는 호출부 Obx 클로저 안에서 평가된 문자열을 받는다 (Rx 미참조).
class SelectionPill extends StatelessWidget {
  const SelectionPill({
    super.key,
    required this.mainText,
    required this.subText,
    required this.onTap,
  });

  /// 메인 값 텍스트 (예: '2잔', '보통')
  final String mainText;

  /// 서브 라벨 (예: '잔수')
  final String subText;

  /// 탭 콜백 (선택 모달 열기)
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          // Figma: Violet95 연배경 / Violet80 보더 → 시맨틱 primary 토큰
          color: colors.primaryLight,
          border: Border.all(color: colors.primarySecondary, width: 1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 메인 텍스트 — Figma: Pretendard 18px/600, #5B35F2
            Text(
              mainText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.primaryStrong,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            // 서브 텍스트 — Figma: Pretendard 14px/400, rgba(55,56,60,0.61)
            Text(
              subText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colors.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
