import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';

/// Content widget for Coffee Main screen (without Scaffold/AppBar)
/// Used inside MainShellView's IndexedStack
class CoffeeMainContent extends GetView<CoffeeController> {
  const CoffeeMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic theme based on taste profile state
    final surveyService = Get.find<SurveyService>();
    final isFilled = surveyService.hasResult;
    final headerTextColor = isFilled
        ? AppColor
              .colorGlobalCommon100 // White text on black bg
        : AppColor.labelNormal; // Black text on light bg

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              '커피 마시기',
              style: AppTextStyles.heading1Bold.copyWith(
                color: headerTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '어떤 방식으로\n커피를 즐기시겠어요?',
              style: AppTextStyles.title2Bold.copyWith(
                color: headerTextColor,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            // Coffee type cards
            _buildCoffeeTypeCard(
              type: CoffeeType.handDrip,
              title: '핸드드립',
              description: '직접 손으로 내리는 커피',
              imagePath: AssetPath.coffeeHandDrip,
              fallbackIcon: Icons.local_cafe,
              color: AppColor.colorGlobalOrange50,
            ),

            const SizedBox(height: 16),

            _buildCoffeeTypeCard(
              type: CoffeeType.espresso,
              title: '에스프레소 머신',
              description: '기계로 추출하는 진한 커피',
              imagePath: AssetPath.coffeeEspresso,
              fallbackIcon: Icons.coffee_maker,
              color: AppColor.colorGlobalViolet50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeTypeCard({
    required CoffeeType type,
    required String title,
    required String description,
    required String imagePath,
    required IconData fallbackIcon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => controller.selectType(type),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.xlBorder,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            // Coffee type image with fallback icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: AppRadius.roundBorder,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.roundBorder,
                child: Image.asset(
                  imagePath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(fallbackIcon, color: color, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.body2NormalRegular.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AssetPath.iconArrowForward,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppColor.labelAssistive,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
