import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// 맛 프로필 6세그먼트 게이지 — Figma: Coffee Profile/Attributes/Resource/Gauge.
///
/// 라벨 40px + 세그먼트 바(6칸, 1px divider) + 점수 28px (0-5 스케일).
/// 온보딩 RecommendationCard 의 연속 바와 디자인이 달라 공통화하지 않는다.
/// [임시] 2번째 세그먼트 게이지 사용처 발견 시 lib/widgets/gauge/ 승격 후보.
class TasteProgressBar extends StatelessWidget {
  const TasteProgressBar({super.key, required this.label, required this.value});

  /// 라벨 (예: '산미')
  final String label;

  /// 값 (0-5 스케일, 내부에서 clamp)
  final double value;

  /// 최대값 (5점 스케일)
  static const double _maxValue = 5.0;
  static const int _segmentCount = 6; // 0~1, 1~2, 2~3, 3~4, 4~5, 5+

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    final clampedValue = value.clamp(0.0, _maxValue);
    // 채울 세그먼트 수 (6칸 기준)
    final filledSegments = (clampedValue / _maxValue * _segmentCount).ceil();

    // Figma: 게이지 행 높이 20px
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          // 라벨 — Figma: width 40px, Label 1/Normal - Medium, #171719
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: colors.labelNormal,
                letterSpacing: 0.0145,
              ),
            ),
          ),
          const SizedBox(width: 12), // Figma: gap 12px
          // 세그먼트 바 — Figma: 8px height
          // 구조: [세그먼트][divider][세그먼트]...[세그먼트] (6칸 + 5 divider)
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                // Figma: rgba(112, 115, 124, 0.12) → 시맨틱 fill
                color: colors.componentFillNormal,
                borderRadius: AppRadius.fullBorder,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.fullBorder,
                child: Row(
                  children: _buildSegmentsWithDividers(colors, filledSegments),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), // Figma: gap after indicator
          // 점수 — Figma: width 28px, Label 1/Normal - Regular
          SizedBox(
            width: 28,
            child: Text(
              clampedValue.toStringAsFixed(1),
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: colors.labelAlternative,
                letterSpacing: 0.0145,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// 세그먼트 + 1px divider 인라인 구성 (Figma 스펙)
  List<Widget> _buildSegmentsWithDividers(
    AppColorScheme colors,
    int filledSegments,
  ) {
    final List<Widget> children = [];
    // 세그먼트 사이 1px divider — Figma rgba(112,115,124,0.16) → 시맨틱 보더
    final dividerColor = colors.lineNormalNeutral;

    for (int i = 0; i < _segmentCount; i++) {
      final isFilled = i < filledSegments;

      // 세그먼트 (Expanded 로 균등 분할) — 채움색은 브랜드 보라(의미색) raw 유지
      children.add(
        Expanded(
          child: Container(
            color: isFilled
                ? AppColor
                      .colorGlobalViolet70 // #9E86FC per Figma
                : AppColor.transparent,
          ),
        ),
      );

      // 세그먼트 사이 divider (마지막 뒤에는 없음)
      if (i < _segmentCount - 1) {
        children.add(
          Container(
            width: 1, // Figma: 1px divider
            height: 8,
            color: dividerColor,
          ),
        );
      }
    }

    return children;
  }
}
