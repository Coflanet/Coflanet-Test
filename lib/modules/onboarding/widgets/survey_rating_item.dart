import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// Survey rating item for taste preference questions (산미 선호도 등)
/// Displays 3 options in a row: dislike / neutral / like
///
/// ```
/// 👎        😐        👍
/// 싫어요    보통      좋아요
/// [선택]   [선택]    [선택]
/// ```
class SurveyRatingItem extends StatelessWidget {
  final String label;
  final int? selectedValue; // -1: dislike, 0: neutral, 1: like, null: none
  final ValueChanged<int> onValueChanged;

  const SurveyRatingItem({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColor.lineNormalNeutral, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question label
          Text(
            label,
            style: AppTextStyles.headline2Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 20),

          // Rating options row
          Row(
            children: [
              Expanded(
                child: _RatingOption(
                  emoji: '👎',
                  text: '싫어요',
                  value: -1,
                  isSelected: selectedValue == -1,
                  onTap: () => onValueChanged(-1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RatingOption(
                  emoji: '😐',
                  text: '보통',
                  value: 0,
                  isSelected: selectedValue == 0,
                  onTap: () => onValueChanged(0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RatingOption(
                  emoji: '👍',
                  text: '좋아요',
                  value: 1,
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

/// Individual rating option button
class _RatingOption extends StatelessWidget {
  final String emoji;
  final String text;
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatingOption({
    required this.emoji,
    required this.text,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryLight
              : AppColor.componentFillNormal,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji
            Text(emoji, style: AppTextStyles.emojiLarge.copyWith(fontSize: 32)),
            const SizedBox(height: 8),

            // Label text
            Text(
              text,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.labelNormal,
              ),
            ),
            const SizedBox(height: 12),

            // Selection button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryNormal
                    : AppColor.backgroundNormalNormal,
                borderRadius: AppRadius.fullBorder,
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryNormal
                      : AppColor.lineNormalNeutral,
                  width: 1,
                ),
              ),
              child: Text(
                isSelected ? '선택됨' : '선택',
                style: AppTextStyles.caption1Medium.copyWith(
                  color: isSelected
                      ? AppColor.staticLabelWhiteStrong
                      : AppColor.labelAlternative,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
