import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/onboarding/survey_controller.dart';

class SurveyIntroView extends GetView<SurveyController> {
  const SurveyIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPath.iconArrowBack,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColor.labelNormal,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header text
              Text(
                '${controller.userName}님의 취향을',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              Text(
                '찾으러 가볼까요?',
                style: AppTextStyles.heading1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                '원하는 분석 방식을 선택해주세요',
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
              const SizedBox(height: 32),

              // Option cards
              Expanded(
                child: Row(
                  children: [
                    // Left card - 일반 설문
                    Expanded(
                      child: _buildOptionCard(
                        label: '일반 설문',
                        description: '커피 맛과 향을\n직접 선택해요',
                        iconWidget: Image.asset(
                          AssetPath.emojiCoffee,
                          width: 72,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                        isSelected: true,
                        onTap: () => controller.startSurvey(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Right card - 라이프스타일 분석
                    Expanded(
                      child: _buildOptionCard(
                        label: '라이프스타일 분석',
                        description: '일상 습관으로\n취향을 파악해요',
                        iconWidget: Image.asset(
                          AssetPath.emojiBeach,
                          width: 72,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                        isSelected: false,
                        onTap: () => _showComingSoonSnackbar(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  /// Build an option card for survey type selection
  Widget _buildOptionCard({
    required String label,
    required String description,
    required Widget iconWidget,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColor.primaryNormal, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selection indicator
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColor.statusPositive
                        : AppColor.transparent,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColor.lineNormalNormal,
                            width: 1.5,
                          ),
                  ),
                  child: isSelected
                      ? Center(
                          child: SvgPicture.asset(
                            AssetPath.iconCheck,
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              AppColor.staticLabelWhiteNormal,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.label1NormalMedium.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description text
            Text(
              description,
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: AppColor.labelNormal,
                height: 1.4,
              ),
            ),
            const Spacer(),
            // Icon
            Align(alignment: Alignment.bottomRight, child: iconWidget),
          ],
        ),
      ),
    );
  }

  /// Show coming soon message for lifestyle analysis
  void _showComingSoonSnackbar() {
    Get.snackbar(
      '준비 중',
      '라이프스타일 분석 기능은 곧 출시될 예정이에요!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.componentFillStrong,
      colorText: AppColor.staticLabelWhiteNormal,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
