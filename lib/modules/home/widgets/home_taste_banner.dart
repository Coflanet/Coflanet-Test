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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.buttonPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppColor.accentTasteBanner,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '어떤 커피를 추천해드릴까요?',
                style: AppTextStyles.body2NormalBold.copyWith(
                  color: AppColor.staticLabelBlackNormal,
                ),
              ),
              Icon(
                Icons.help_outline,
                size: 18,
                color: AppColor.staticLabelBlackNeutral,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 가변 취향 라벨 — 긴 한국어 라벨에서 우측 아이콘과 충돌하지 않도록
              // Expanded + ellipsis 로 폭을 제한한다.
              Expanded(
                child: Row(
                  children: [
                    Text(
                      flavors.isNotEmpty ? flavors.first.emoji : '☕',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: AppSpacing.space6),
                    Flexible(
                      child: Text(
                        typeLabel.isNotEmpty ? typeLabel : '나의 커피 취향',
                        // Figma 취향 라벨(111:16033): SemiBold 18 = headline1Bold
                        style: AppTextStyles.headline1Bold.copyWith(
                          color: AppColor.staticLabelBlackNormal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.swap_horiz,
                size: 22,
                color: AppColor.staticLabelBlackNeutral,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.space6,
            runSpacing: AppSpacing.space6,
            children: _buildChips(),
          ),
        ],
      ),
    );
  }

  /// 취향 향미 칩 목록 — 최대 3개 + "외 N개"
  List<Widget> _buildChips() {
    if (flavors.isEmpty) return const [];
    final chips = <Widget>[
      for (final f in flavors.take(_maxChips)) _buildChip(f.name),
    ];
    if (flavors.length > _maxChips) {
      chips.add(_buildChip('외 ${flavors.length - _maxChips}개'));
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
        color: AppColor.staticBlack.withValues(alpha: 0.08),
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
