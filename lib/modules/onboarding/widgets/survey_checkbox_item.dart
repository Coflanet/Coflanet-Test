import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';

class SurveyCheckboxItem extends StatelessWidget {
  final String label;
  final String? icon;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;

  const SurveyCheckboxItem({
    super.key,
    required this.label,
    this.icon,
    this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryLight
              : AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.lineNormalNeutral,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            if (icon != null) ...[
              Text(
                icon!,
                style: const TextStyle(fontSize: 24),
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
                        color: AppColor.labelAlternative,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Checkbox indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryNormal
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryNormal
                      : AppColor.lineNormalNormal,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
