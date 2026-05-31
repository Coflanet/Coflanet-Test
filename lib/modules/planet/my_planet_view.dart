import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

/// Standalone My Planet screen (with Scaffold + header).
/// Delegates body content to [MyPlanetContent] to avoid duplication.
class MyPlanetView extends GetView<MyPlanetController> {
  const MyPlanetView({super.key});

  // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
  // 색상은 Label/strong (#000000) 토큰 매핑
  // Auth 카테고리에서 통일한 페이지 헤더 스타일과 동일
  TextStyle get _screenHeaderStyle => AppTextStyles.heading1Bold.copyWith(
    fontWeight: FontWeight.w600,
    height: 1.36,
    letterSpacing: -0.4268,
    color: AppColor.labelStrong,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCoolNeutral10,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header - User name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                () => Text(
                  controller.userName,
                  style: _screenHeaderStyle,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Body content (reuses MyPlanetContent)
            const Expanded(child: MyPlanetContent()),
          ],
        ),
      ),
    );
  }
}
