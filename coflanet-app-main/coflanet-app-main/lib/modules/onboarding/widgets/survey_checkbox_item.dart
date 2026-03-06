import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

/// Survey checkbox item matching storyboard design
/// - Step 0 (10-survey-reason.png): Text-only, no icons (showIcon=false)
/// - Other steps: Emoji on left + label + description + checkmark (showIcon=true)
/// - Selected: violet border + violet checkmark
/// - Unselected: light gray border + gray checkmark
class SurveyCheckboxItem extends StatelessWidget {
  final String label;
  final String? icon;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showIcon;

  const SurveyCheckboxItem({
    super.key,
    required this.label,
    this.icon,
    this.description,
    required this.isSelected,
    required this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Figma: 선택됨 = 흰색 배경, 미선택 = 연한 회색 배경
          color: isSelected
              ? AppColor.backgroundNormalNormal
              : AppColor.componentFillNormal,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(
            // Figma: 선택됨 = Violet 테두리 2px, 미선택 = 테두리 없음
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji icon (only when showIcon=true and icon is provided)
            if (showIcon && icon != null) ...[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Text(icon!, style: AppTextStyles.emojiNormal),
              ),
              const SizedBox(width: 12),
            ],

            // Label and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    // Storyboard: 선택됨 = Violet 텍스트, 미선택 = 검정 텍스트
                    style: AppTextStyles.body1NormalMedium.copyWith(
                      color: isSelected
                          ? AppColor.primaryNormal
                          : AppColor.labelNormal,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: isSelected
                            ? AppColor.primarySecondary
                            : AppColor.labelAlternative,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Checkmark indicator (storyboard: simple checkmark, no box)
            Icon(
              Icons.check,
              size: 24,
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.interactionInactive,
            ),
          ],
        ),
      ),
    );
  }
}
