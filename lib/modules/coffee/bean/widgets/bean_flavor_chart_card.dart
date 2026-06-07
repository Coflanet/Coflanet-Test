import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart';

/// 향미 차트 카드 — 향의 진함 바 + 레이더 차트 + 맛 5축 값 바.
///
/// bean 을 통째로 받아 원본의 nullable 분기
/// (aromaIntensity null 시 진함 섹션 미표시, flavorProfile null 시 기본값)를
/// 1:1 보존한다. 연속 바는 select 의 6세그먼트 게이지·온보딩 바와 토큰이
/// 달라 모듈 전용 유지. controller 미참조.
class BeanFlavorChartCard extends StatelessWidget {
  const BeanFlavorChartCard({super.key, required this.bean});

  /// 원두 데이터
  final CoffeeItem bean;

  @override
  Widget build(BuildContext context) {
    final profile = bean.flavorProfile ?? const FlavorProfile();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCoolNeutral15,
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          children: [
            // 향의 진함 (있을 때만)
            if (bean.aromaIntensity != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '향의 진함',
                    style: AppTextStyles.body2NormalMedium.copyWith(
                      color: AppColor.colorGlobalCoolNeutral60,
                    ),
                  ),
                  Text(
                    bean.aromaIntensity!.round().toString(),
                    style: AppTextStyles.body2NormalBold.copyWith(
                      color: AppColor.primaryNormal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAromaBar(bean.aromaIntensity!),
              const SizedBox(height: 24),
            ],
            // 레이더 차트
            Center(
              child: FlavorRadarChart(
                profile: profile,
                size: 220,
                showLabels: true,
                showValues: true,
                animate: true,
                fillColor: AppColor.primaryNormal.withValues(alpha: 0.15),
                strokeColor: AppColor.primaryNormal,
                gridColor: AppColor.colorGlobalCoolNeutral30,
                labelColor: AppColor.colorGlobalCommon100,
              ),
            ),
            const SizedBox(height: 24),
            // 맛 5축 값 바
            _buildFlavorValuesList(profile),
          ],
        ),
      ),
    );
  }

  /// 향의 진함 바 (그라데이션, 800ms 애니메이션)
  Widget _buildAromaBar(double value) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral25,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * (value / 100.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryNormal.withValues(alpha: 0.7),
                      AppColor.primaryNormal,
                    ],
                  ),
                  borderRadius: AppRadius.xxxlBorder,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 맛 5축 라벨 + 값 바 + 정수 점수
  Widget _buildFlavorValuesList(FlavorProfile profile) {
    final items = [
      ('산미', profile.acidity),
      ('바디감', profile.body),
      ('단맛', profile.sweetness),
      ('쓴맛', profile.bitterness),
      ('밸런스', profile.balance),
    ];

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  item.$1,
                  style: AppTextStyles.body2NormalRegular.copyWith(
                    color: AppColor.colorGlobalCoolNeutral60,
                  ),
                ),
              ),
              Expanded(child: _buildValueBar(item.$2)),
              const SizedBox(width: 12),
              SizedBox(
                width: 30,
                child: Text(
                  item.$2.round().toString(),
                  style: AppTextStyles.body2NormalMedium.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 단색 값 바 (800ms 애니메이션)
  Widget _buildValueBar(double value) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral25,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              width: constraints.maxWidth * (value / 100.0),
              decoration: BoxDecoration(
                color: AppColor.primaryNormal,
                borderRadius: AppRadius.xxxlBorder,
              ),
            ),
          );
        },
      ),
    );
  }
}
