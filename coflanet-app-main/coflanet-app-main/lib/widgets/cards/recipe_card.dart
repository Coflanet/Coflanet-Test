import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Reusable recipe card widget for displaying coffee recipe information.
/// Used in HandDripView and EspressoView.
class RecipeCard extends StatelessWidget {
  /// Recipe items to display (e.g., cups, coffee amount, water amount)
  final List<RecipeItem> items;

  /// Gradient colors for the card background
  final List<Color> gradientColors;

  /// Optional info text to display below items
  final String? infoText;

  const RecipeCard({
    super.key,
    required this.items,
    required this.gradientColors,
    this.infoText,
  });

  /// Factory for hand drip style (orange gradient)
  factory RecipeCard.handDrip({
    Key? key,
    required List<RecipeItem> items,
    String? infoText,
  }) {
    return RecipeCard(
      key: key,
      items: items,
      gradientColors: [
        AppColor.colorGlobalOrange50,
        AppColor.colorGlobalOrange60,
      ],
      infoText: infoText,
    );
  }

  /// Factory for espresso style (violet gradient)
  factory RecipeCard.espresso({
    Key? key,
    required List<RecipeItem> items,
    String? infoText,
  }) {
    return RecipeCard(
      key: key,
      items: items,
      gradientColors: [
        AppColor.colorGlobalViolet50,
        AppColor.colorGlobalViolet60,
      ],
      infoText: infoText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: AppRadius.xlBorder,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) => _buildRecipeItem(item)).toList(),
          ),
          if (infoText != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColor.staticLabelWhiteStrong,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    infoText!,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.staticLabelWhiteStrong.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecipeItem(RecipeItem item) {
    return Column(
      children: [
        Text(
          item.value,
          style: AppTextStyles.heading1Bold.copyWith(
            color: AppColor.staticLabelWhiteStrong,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: AppTextStyles.caption1Regular.copyWith(
            color: AppColor.staticLabelWhiteStrong.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

/// Model for a single recipe item (e.g., "18g" for "원두")
class RecipeItem {
  final String label;
  final String value;

  const RecipeItem({required this.label, required this.value});
}
