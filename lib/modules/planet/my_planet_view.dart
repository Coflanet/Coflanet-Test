import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

/// Standalone My Planet screen (with Scaffold + header).
/// Delegates body content to [MyPlanetContent] to avoid duplication.
/// 이전에는 다크 배경(cn10) + 검정 헤더 텍스트가 섞여 깨져 있었다 —
/// 테마 스킴 기반으로 통일.
class MyPlanetView extends GetView<MyPlanetController> {
  const MyPlanetView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);

    // Figma 사양: Pretendard SemiBold 22 / lineHeight 1.36 / letterSpacing -0.4268
    // Auth 카테고리에서 통일한 페이지 헤더 스타일과 동일
    final screenHeaderStyle = AppTextStyles.heading1Bold.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.36,
      letterSpacing: -0.4268,
      color: colors.labelStrong,
    );

    return Scaffold(
      backgroundColor: colors.backgroundNormalAlternative,
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
                () => Text(controller.userName, style: screenHeaderStyle),
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
