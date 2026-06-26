import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// 홈 취향 배너 (노랑) — 설문 완료 시 표시. 풀폭 + 둥근 코너 카드.
///
/// 취향 타입 라벨 + 향미 칩 (최대 3개 + "외 N개").
/// 배너가 노랑 고정색이므로 텍스트는 테마 무관 static 검정 토큰을 쓴다.
class HomeTasteBanner extends StatelessWidget {
  const HomeTasteBanner({
    super.key,
    required this.typeLabel,
    required this.flavors,
  });

  /// 향미 칩 최대 표시 개수
  static const int _maxChips = 3;

  /// 커피 타입 라벨 (예: '시트러스 러버') — 비어 있으면 기본 문구
  final String typeLabel;

  /// 향미 설명 목록 (이름/이모지)
  final List<FlavorDescriptionModel> flavors;

  @override
  Widget build(BuildContext context) {
    // Figma Select/Select(83:13166): yellow radius40, py24, gap20(타이틀칩↔콘텐츠),
    // 콘텐츠 내부 gap12, 모든 행 px24.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space24),
      decoration: BoxDecoration(
        color: AppColor.accentTasteBanner,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 타이틀 칩 (Figma 113:15869): component/fill/strong pill + chevron-down
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: _buildTitleChip(),
          ),
          const SizedBox(height: AppSpacing.space20),
          // 취향 라벨 행 (Figma 111:16026): emoji+라벨 + swap 아이콘
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    typeLabel.isNotEmpty
                        ? '${flavors.isNotEmpty ? '${flavors.first.emoji} ' : ''}$typeLabel'
                        : '나의 커피 취향',
                    // Figma 취향 라벨(111:16033): SemiBold 18 = headline1Bold
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: AppColor.staticLabelBlackNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.swap_horiz,
                  size: AppSpacing.space24,
                  color: AppColor.staticLabelBlackAlternative,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // 향미 칩 (Figma Tag_List 111:16043): px24, flex-wrap gap4
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space24,
            ),
            child: Wrap(
              spacing: AppSpacing.space4,
              runSpacing: AppSpacing.space4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: _buildChips(),
            ),
          ),
        ],
      ),
    );
  }

  /// 타이틀 칩 — 회색 pill + 우측 chevron-down (Figma 113:15869).
  Widget _buildTitleChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space6,
      ),
      decoration: BoxDecoration(
        // Figma component/fill/strong: cool-neutral/50 #70737C @28%
        color: AppColor.colorGlobalCoolNeutral50.withValues(alpha: 0.28),
        borderRadius: AppRadius.fullBorder,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '어떤 커피를 추천해드릴까요?',
              // Figma 83:13169: Medium 14 = label1NormalMedium
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: AppColor.staticLabelBlackAlternative,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.keyboard_arrow_down,
            size: AppSpacing.space24,
            color: AppColor.staticLabelBlackAssistive,
          ),
        ],
      ),
    );
  }

  /// 취향 향미 칩 목록 — 최대 3개 + "외 N개"(칩 아님, 평문)
  List<Widget> _buildChips() {
    if (flavors.isEmpty) return const [];
    final chips = <Widget>[
      for (final f in flavors.take(_maxChips)) _buildChip(f.name),
    ];
    if (flavors.length > _maxChips) {
      chips.add(
        Text(
          '외 ${flavors.length - _maxChips}개',
          style: AppTextStyles.label1NormalMedium.copyWith(
            color: AppColor.staticLabelBlackNormal,
          ),
        ),
      );
    }
    return chips;
  }

  Widget _buildChip(String label) {
    // Figma Chip/Action(113:15685): px8 py6, radius 8, static black @8%, Medium 14
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space8,
        vertical: AppSpacing.space6,
      ),
      decoration: BoxDecoration(
        color: AppColor.staticLabelBlackNormal.withValues(alpha: 0.08),
        borderRadius: AppRadius.mdBorder,
      ),
      child: Text(
        label,
        style: AppTextStyles.label1NormalMedium.copyWith(
          color: AppColor.staticLabelBlackNormal,
        ),
      ),
    );
  }
}
