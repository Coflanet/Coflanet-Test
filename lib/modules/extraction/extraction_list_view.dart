import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/extraction/extraction_list_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';

class ExtractionListView extends GetView<ExtractionListController> {
  const ExtractionListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic theme based on taste profile state
    final surveyService = Get.find<SurveyService>();
    final isFilled = surveyService.hasResult;
    final titleColor = isFilled
        ? AppColor
              .colorGlobalCommon100 // White on black
        : AppColor.labelNormal; // Black on light

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with gradient background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.colorGlobalViolet80,
                    AppColor.colorGlobalViolet50,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.list_alt_rounded,
                  size: 40,
                  color: AppColor.colorGlobalCommon100,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              '추출 목록',
              style: AppTextStyles.title2Bold.copyWith(color: titleColor),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Text(
              '준비 중입니다',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral50,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                '나만의 추출 기록을 확인하고\n관리할 수 있는 기능이 곧 추가됩니다',
                style: AppTextStyles.caption1Regular.copyWith(
                  color: AppColor.colorGlobalCoolNeutral50,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
