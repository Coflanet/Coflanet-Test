import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 선호 맛 프로필 세로 막대 차트 — 5축(산미/단맛/쓴맛/바디감/향) × 의미색 5종.
///
/// my_taste 화면 전용. 모델 통째 주입 — [profile] 이 null 이면 빈 위젯
/// (원본 null 가드 보존). 막대는 TweenAnimationBuilder 1000ms easeOutCubic
/// 진입 애니메이션. 축별 색(yellow/pink/orange/violet/green 50)은 데이터
/// 의미색이라 raw 토큰 유지.
class TasteVerticalBarChart extends StatelessWidget {
  const TasteVerticalBarChart({super.key, required this.profile});

  /// 취향 프로필 (null 이면 SizedBox.shrink 렌더)
  final TasteProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    if (profile == null) return const SizedBox.shrink();

    final colors = AppColorScheme.of(context);
    final tasteData = [
      _TasteData('산미', profile.acidity, AppColor.colorGlobalYellow50),
      _TasteData('단맛', profile.sweetness, AppColor.colorGlobalPink50),
      _TasteData('쓴맛', profile.bitterness, AppColor.colorGlobalOrange50),
      _TasteData('바디감', profile.body, AppColor.colorGlobalViolet50),
      _TasteData('향', profile.aroma, AppColor.colorGlobalGreen50),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.xxxlBorder,
        boxShadow: AppShadows.shadowBlackEmphasize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: AppRadius.lgPlusBorder,
                ),
                child: Icon(
                  Icons.coffee,
                  color: AppColor.staticLabelWhiteStrong,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선호 맛 프로필',
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: colors.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '나의 커피 취향 분석 결과',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 막대 차트
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: tasteData.map((data) {
                return Expanded(child: _buildBarItem(colors, data));
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBarItem(AppColorScheme colors, _TasteData data) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: data.value / 100),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 값 라벨
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.mdBorder,
                ),
                child: Text(
                  '${data.value}',
                  style: AppTextStyles.caption1Bold.copyWith(color: data.color),
                ),
              ),
              const SizedBox(height: 8),
              // 막대
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barHeight = constraints.maxHeight * animValue;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: math.max(barHeight, 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              data.color,
                              data.color.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: AppRadius.mdBorder,
                          boxShadow: [
                            BoxShadow(
                              color: data.color.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // 축 라벨
              Text(
                data.label,
                style: AppTextStyles.caption1Medium.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 차트 축 데이터 (라벨 / 값 / 의미색)
class _TasteData {
  final String label;
  final int value;
  final Color color;

  _TasteData(this.label, this.value, this.color);
}
