import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 취향 요약 카드 — 커피 타입 뱃지 + '○○님은' + 타입명 + 설명 (오렌지 그라데이션).
///
/// my_taste 화면 전용. 컨트롤러 미참조 — 값/콜백 주입.
/// 오렌지 계열은 브랜드 의미색이라 raw 토큰(AppColor.colorGlobalOrange*) 유지.
class TasteSummaryCard extends StatelessWidget {
  const TasteSummaryCard({
    super.key,
    required this.userName,
    required this.coffeeType,
    required this.description,
    required this.onViewDetail,
  });

  /// 사용자 이름 ('○○님은' 표기)
  final String userName;

  /// 커피 타입명
  final String coffeeType;

  /// 커피 타입 설명
  final String description;

  /// 상세 보기(화살표 버튼) 탭 콜백
  final VoidCallback onViewDetail;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.colorGlobalOrange95, colors.surfaceCard],
        ),
        borderRadius: AppRadius.xxxlBorder,
        border: Border.all(
          color: AppColor.colorGlobalOrange50.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 헤더 (뱃지 + 이름/타입 + 상세 버튼)
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // 커피 타입 뱃지
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.colorGlobalOrange50,
                        AppColor.colorGlobalOrange70,
                      ],
                    ),
                    borderRadius: AppRadius.xxlBorder,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.colorGlobalOrange50.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.coffee,
                    color: AppColor.staticLabelWhiteStrong,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$userName님은',
                        style: AppTextStyles.label1NormalMedium.copyWith(
                          color: colors.labelAlternative,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coffeeType,
                        style: AppTextStyles.title3Bold.copyWith(
                          color: AppColor.colorGlobalOrange50,
                        ),
                      ),
                    ],
                  ),
                ),
                // 상세 보기 버튼
                GestureDetector(
                  onTap: onViewDetail,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: AppRadius.lgBorder,
                      boxShadow: AppShadows.shadowBlackNormal,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colors.labelAlternative,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 구분선
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: colors.lineNormalAlternative,
          ),

          // 설명
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              description,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelNeutral,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
