import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 결과 화면 하단 액션 링크 — "추천 원두 더 보기" 아웃라인 버튼 +
/// "취향 설문 다시하기" / "원두 선택 없이 홈으로" 링크.
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space20,
        AppSpacing.space16,
        AppSpacing.space20,
        0,
      ),
      child: Column(
        children: [
          // "추천 원두 더 보기" — 풀폭 회색 보더 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onMoreTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.space14,
                ),
                side: BorderSide(color: colors.lineNormalNeutral),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '추천 원두 더 보기',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space12),

          // "취향 설문 다시하기" 링크 (밑줄)
          TextButton(
            onPressed: onRetakeTap,
            child: Text(
              '취향 설문 다시하기',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelAssistive,
                decoration: TextDecoration.underline,
                decorationColor: colors.labelAssistive,
              ),
            ),
          ),

          // "원두 선택 없이 홈으로" 링크 (밑줄) — 선택 없이도 시작 가능한 탈출구
          TextButton(
            onPressed: onSkipTap,
            child: Text(
              '원두 선택 없이 홈으로',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelAssistive,
                decoration: TextDecoration.underline,
                decorationColor: colors.labelAssistive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
