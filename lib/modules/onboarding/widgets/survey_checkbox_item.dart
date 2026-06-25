import 'package:flutter/material.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
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
    final colors = AppColorScheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Figma Check Box(937:45574): padding px20/py24, radius 40
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space20,
          vertical: AppSpacing.space24,
        ),
        decoration: BoxDecoration(
          // Figma: 선택 = violet 틴트(#fbfaff), 미선택 = component/fill/alternative(0.05)
          color: isSelected
              ? colors.primaryLight
              : colors.componentFillAlternative,
          borderRadius: AppRadius.sectionRadiusBorder,
          // Figma: 보더는 선택 시에만 1px primary. 미선택은 보더 없음.
          border: isSelected
              ? Border.all(color: colors.primaryNormal, width: 1)
              : null,
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
              const SizedBox(width: AppSpacing.space12),
            ],

            // Label and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    // Figma: 선택/미선택 모두 label/neutral — 선택해도 라벨색 불변(체크만 violet)
                    style: AppTextStyles.label1NormalBold.copyWith(
                      color: colors.labelNeutral,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      description!,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: isSelected
                            ? colors.primarySecondary
                            : colors.labelAlternative,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space8),

            // Checkmark indicator (Figma: Control/Check 20px, 선택=violet/미선택=회색)
            Icon(
              Icons.check,
              size: 20,
              color: isSelected
                  ? colors.primaryNormal
                  : colors.interactionInactive,
            ),
          ],
        ),
      ),
    );
  }
}
