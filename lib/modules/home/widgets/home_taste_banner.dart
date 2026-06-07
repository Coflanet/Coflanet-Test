import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.accentTasteBanner,
        borderRadius: AppRadius.xxlBorder,
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
          const SizedBox(height: 12),
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
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        typeLabel.isNotEmpty ? typeLabel : '나의 커피 취향',
                        style: AppTextStyles.body1NormalBold.copyWith(
                          color: AppColor.staticLabelBlackNormal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.swap_horiz,
                size: 22,
                color: AppColor.staticLabelBlackNeutral,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 6, children: _buildChips()),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100.withValues(alpha: 0.55),
        borderRadius: AppRadius.fullBorder,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption1Medium.copyWith(
          color: AppColor.staticLabelBlackNormal,
        ),
      ),
    );
  }
}
