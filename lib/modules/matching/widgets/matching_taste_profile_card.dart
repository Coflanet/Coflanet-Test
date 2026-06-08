import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/widgets/gauge/app_animated_taste_bar.dart';

/// 매칭 결과 맛 프로필 카드 — 헤더 + AppAnimatedTasteBar 5축.
///
/// [profile] 은 비-null 주입 — SurveyResultModel.tasteProfile 이 required
/// 비-null 필드라 가드 불필요 (호출부의 hasResult 체크 이후 경로).
/// 5축 의미색(산미=Yellow/단맛=Pink/쓴맛=Orange/바디감=Violet/향=Green 50)은
/// my_taste 의 세로 막대 차트와 값이 동일하나 소비 형태(가로 바 위젯 인자 vs
/// 세로 막대 튜플)가 달라 공유 상수로 합치지 않는다.
class MatchingTasteProfileCard extends StatelessWidget {
  const MatchingTasteProfileCard({super.key, required this.profile});

  /// 취향 프로필 (비-null)
  final TasteProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.xxlBorder,
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 — 시맨틱 primary 토큰 (추천 원두 헤더의 raw orange 와 다른 체계)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(
                  Icons.equalizer_rounded,
                  color: colors.primaryNormal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '맛 프로필',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 맛 바 5축 — 색은 데이터 의미색 raw 토큰 유지
          AppAnimatedTasteBar(
            label: '산미',
            value: profile.acidity,
            color: AppColor.colorGlobalYellow50,
          ),
          AppAnimatedTasteBar(
            label: '단맛',
            value: profile.sweetness,
            color: AppColor.colorGlobalPink50,
          ),
          AppAnimatedTasteBar(
            label: '쓴맛',
            value: profile.bitterness,
            color: AppColor.colorGlobalOrange50,
          ),
          AppAnimatedTasteBar(
            label: '바디감',
            value: profile.body,
            color: AppColor.colorGlobalViolet50,
          ),
          AppAnimatedTasteBar(
            label: '향',
            value: profile.aroma,
            color: AppColor.colorGlobalGreen50,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
