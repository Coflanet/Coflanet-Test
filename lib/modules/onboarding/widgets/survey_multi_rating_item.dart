import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/survey_question_model.dart';

/// 멀티레이팅 카드 1행 — 질문 + 설명 + 레이팅 버튼 행.
///
/// 내부 버튼은 의미색(빨강/파랑)이 아닌 **보라 단색 선택 강조** 체계로,
/// SurveyRatingChip(의미색)과 디자인 언어가 달라 별도 유지한다.
///
/// 주의: [selectedValue] 가 매 빌드 달라지므로 호출부에서 const 인스턴스화 금지.
/// 호출부 Obx 클로저 안에서 selectedValue 를 읽어 주입해야 반응형이 유지된다.
class SurveyMultiRatingItem extends StatelessWidget {
  const SurveyMultiRatingItem({
    super.key,
    required this.item,
    required this.selectedValue,
    required this.onValueChanged,
  });

  /// 멀티레이팅 항목 데이터
  final MultiRatingItem item;

  /// 현재 선택 값 — -1(싫어요) / 0(보통) / 1(좋아요) / null(미선택)
  final int? selectedValue;

  /// 값 변경 콜백
  final ValueChanged<int> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColor.lineNormalNeutral, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 질문 텍스트
          Text(
            item.question,
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 4),

          // 설명 텍스트
          if (item.description.isNotEmpty) ...[
            Text(
              item.description,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.labelAlternative,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 레이팅 버튼 행
          Row(
            children: [
              // 싫어요
              Expanded(
                child: _RatingButton(
                  emoji: '👎',
                  label: '싫어요',
                  isSelected: selectedValue == -1,
                  onTap: () => onValueChanged(-1),
                ),
              ),

              // 보통 (hasNeutral 일 때만)
              if (item.hasNeutral) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _RatingButton(
                    emoji: '😐',
                    label: '보통',
                    isSelected: selectedValue == 0,
                    onTap: () => onValueChanged(0),
                  ),
                ),
              ],

              // 좋아요
              const SizedBox(width: 8),
              Expanded(
                child: _RatingButton(
                  emoji: '👍',
                  label: '좋아요',
                  isSelected: selectedValue == 1,
                  onTap: () => onValueChanged(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 멀티레이팅 내부 단일 버튼 — 보라 단색 선택 강조 (이모지 24px, caption1Medium)
class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryLight
              : AppColor.componentFillNormal,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption1Medium.copyWith(
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.labelNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
