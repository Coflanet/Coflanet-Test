import 'package:flutter/material.dart';
import 'package:coflanet/modules/onboarding/widgets/survey_rating_chip.dart';

/// 설문 레이팅 행 — ternary(싫어요/보통/좋아요) 또는 binary(싫어요/좋아요).
///
/// [selectedValue]: -1(싫어요) / 0(보통) / 1(좋아요) / null(미선택).
/// 호출부(View)의 Obx 클로저 안에서 selectedValue 를 계산해 주입해야
/// 선택 상태 변경이 반응형으로 반영된다 (위젯은 controller 미참조).
class SurveyRatingRow extends StatelessWidget {
  const SurveyRatingRow({
    super.key,
    required this.hasNeutral,
    required this.selectedValue,
    required this.onSelect,
  });

  /// true 면 3분할(보통 포함, large), false 면 2분할(xlarge)
  final bool hasNeutral;

  /// 현재 선택 값 (-1/0/1, 미선택 null)
  final int? selectedValue;

  /// 옵션 선택 콜백 — 옵션 id ('dislike' | 'neutral' | 'like')
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final size = hasNeutral ? RatingChipSize.large : RatingChipSize.xlarge;
    // 칩 사이 간격: ternary 12 / binary 16 (원본 1:1)
    final double gap = hasNeutral ? 12 : 16;

    return Row(
      children: [
        Expanded(
          child: SurveyRatingChip(
            emoji: '👎',
            label: '싫어요',
            sentiment: RatingSentiment.dislike,
            isSelected: selectedValue == -1,
            onTap: () => onSelect('dislike'),
            size: size,
          ),
        ),
        if (hasNeutral) ...[
          SizedBox(width: gap),
          Expanded(
            child: SurveyRatingChip(
              emoji: '😐',
              label: '보통',
              sentiment: RatingSentiment.neutral,
              isSelected: selectedValue == 0,
              onTap: () => onSelect('neutral'),
              size: size,
            ),
          ),
        ],
        SizedBox(width: gap),
        Expanded(
          child: SurveyRatingChip(
            emoji: '👍',
            label: '좋아요',
            sentiment: RatingSentiment.like,
            isSelected: selectedValue == 1,
            onTap: () => onSelect('like'),
            size: size,
          ),
        ),
      ],
    );
  }
}
