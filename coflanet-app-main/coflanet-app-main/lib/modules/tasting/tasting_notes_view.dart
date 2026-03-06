import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/tasting/tasting_notes_controller.dart';

class TastingNotesView extends GetView<TastingNotesController> {
  const TastingNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed per Figma CSS: Shell screens use black bg, white text
    const titleColor = AppColor.colorGlobalCommon100; // White text on black bg

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
                    AppColor.colorGlobalOrange80,
                    AppColor.colorGlobalOrange50,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.edit_note_rounded,
                  size: 40,
                  color: AppColor.colorGlobalCommon100,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              '시음 기록',
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
                '커피의 맛과 향을 기록하고\n나만의 시음 노트를 만들어보세요',
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
