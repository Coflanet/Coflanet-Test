import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 매칭 결과 히어로 카드 — 오렌지 그라데이션 배경 + 사용자 뱃지 + 커피 타입.
///
/// 전부 고정 브랜드색(orange 그라데이션 + 흰 텍스트) — 라이트/다크 공통 고정이
/// 원본 의도라 AppColorScheme 을 사용하지 않는다. my_taste 의 TasteSummaryCard
/// (옅은 그라데이션 + 뱃지 + 화살표 버튼)와는 합성 구조가 달라 통합하지 않는다.
class MatchingHeroCard extends StatelessWidget {
  const MatchingHeroCard({
    super.key,
    required this.userName,
    required this.coffeeType,
    required this.description,
  });

  /// 사용자 이름 ('○○님의 커피 매칭' 뱃지)
  final String userName;

  /// 커피 타입명
  final String coffeeType;

  /// 커피 타입 설명
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.colorGlobalOrange50, AppColor.colorGlobalOrange70],
        ),
        borderRadius: AppRadius.xxxlBorder,
        boxShadow: [
          BoxShadow(
            color: AppColor.colorGlobalOrange50.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 배경 패턴 원 2개
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.staticLabelWhiteStrong.withValues(alpha: 0.08),
              ),
            ),
          ),

          // 본문
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사용자 뱃지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.staticLabelWhiteStrong.withValues(
                      alpha: 0.2,
                    ),
                    borderRadius: AppRadius.xxlBorder,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: AppColor.staticLabelWhiteStrong,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$userName님의 커피 매칭',
                        style: AppTextStyles.caption1Medium.copyWith(
                          color: AppColor.staticLabelWhiteStrong,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 커피 타입
                Text(
                  coffeeType,
                  style: AppTextStyles.display2Bold.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // 설명
                Text(
                  description,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.staticLabelWhiteStrong.withValues(
                      alpha: 0.9,
                    ),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
