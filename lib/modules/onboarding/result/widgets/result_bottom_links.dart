import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 결과 화면 하단 액션 링크 — "추천 원두 더 보기" 아웃라인 버튼 + "취향 설문 다시하기" 링크.
class ResultBottomLinks extends StatelessWidget {
  const ResultBottomLinks({
    super.key,
    required this.onMoreTap,
    required this.onRetakeTap,
  });

  /// '추천 원두 더 보기' 탭 콜백 — [백엔드 API 연동 대기] 전체 목록 화면
  final VoidCallback onMoreTap;

  /// '취향 설문 다시하기' 탭 콜백
  final VoidCallback onRetakeTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          // "추천 원두 더 보기" — 풀폭 회색 보더 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onMoreTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: AppColor.lineNormalNeutral),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '추천 원두 더 보기',
                style: AppTextStyles.body2NormalMedium.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // "취향 설문 다시하기" 링크 (밑줄)
          TextButton(
            onPressed: onRetakeTap,
            child: Text(
              '취향 설문 다시하기',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: AppColor.labelAssistive,
                decoration: TextDecoration.underline,
                decorationColor: AppColor.labelAssistive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
