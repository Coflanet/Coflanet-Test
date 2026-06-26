import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 마이플래닛 pill 액션 버튼 — 옅은 fill + 보라 텍스트, 풀폭 알약형.
///
/// '취향 설문 하기'(빈 상태 CTA)와 '취향 설문 다시 하기'(재설문)가 공유한다.
/// 원본 CTA 의 horizontal 28 패딩은 풀폭 + 단일 줄 중앙 정렬에서 렌더 차이가
/// 없어 제거했다. PrimaryButton 과는 색 반전(옅은 fill/보라 텍스트)·radius·
/// 상태 체계가 달라 통합하지 않는다 (planet 전용).
class PlanetPillButton extends StatelessWidget {
  const PlanetPillButton({super.key, required this.text, required this.onTap});

  /// 버튼 라벨
  final String text;

  /// 탭 콜백
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        // Figma(1341:15093): py12, h52, component/fill/alternative, pill
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.componentFillNormal,
          borderRadius: AppRadius.fullBorder, // pill
        ),
        child: Text(
          text,
          // Figma: Body 1/Normal Bold 16px, primary/normal
          style: AppTextStyles.body1NormalBold.copyWith(
            color: colors.primaryNormal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
