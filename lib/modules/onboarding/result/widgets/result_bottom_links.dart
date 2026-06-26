import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 결과 화면 Preference_List 하단 — "추천 원두 더 보기" 회색 버튼 +
/// "취향 설문 다시하기" / "원두 선택 없이 홈으로" 링크.
///
/// Figma: 더 보기 = 풀폭 회색 솔리드 버튼. 다시하기 링크는 회색 텍스트.
/// 홈으로 링크는 Figma 미존재 — 선택 0개 탈출구로 기능 유지(의도 유지).
class ResultBottomLinks extends StatelessWidget {
  const ResultBottomLinks({
    super.key,
    required this.onMoreTap,
    required this.onRetakeTap,
    required this.onSkipTap,
  });

  /// '추천 원두 더 보기' 탭 콜백 — [백엔드 API 연동 대기] 전체 목록 화면
  final VoidCallback onMoreTap;

  /// '취향 설문 다시하기' 탭 콜백
  final VoidCallback onRetakeTap;

  /// '원두 선택 없이 홈으로' 탭 콜백 — 추천 원두를 담지 않고 온보딩 완료
  final VoidCallback onSkipTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    return Column(
      children: [
        // "추천 원두 더 보기" — 풀폭 회색 솔리드 버튼
        GestureDetector(
          onTap: onMoreTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space14),
            decoration: BoxDecoration(
              color: colors.componentFillStrong,
              borderRadius: AppRadius.xlBorder,
            ),
            child: Center(
              child: Text(
                '추천 원두 더 보기',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space16),

        // "취향 설문 다시하기" 링크
        GestureDetector(
          onTap: onRetakeTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            '취향 설문 다시하기',
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: colors.labelAlternative,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space12),

        // "원두 선택 없이 홈으로" 링크 — 선택 0개 탈출구(의도 유지)
        GestureDetector(
          onTap: onSkipTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            '원두 선택 없이 홈으로',
            style: AppTextStyles.caption1Regular.copyWith(
              color: colors.labelAssistive,
            ),
          ),
        ),
      ],
    );
  }
}
