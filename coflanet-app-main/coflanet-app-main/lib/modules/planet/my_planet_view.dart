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
                  style: AppTextStyles.heading1Bold.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
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
