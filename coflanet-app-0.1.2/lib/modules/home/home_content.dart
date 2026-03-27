import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/home/widgets/subscribe_section.dart';
import 'package:coflanet/modules/home/widgets/recommend_section.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Home screen content - replaces SelectCoffeeContent as Tab 0 in MainShell
/// Figma: Home_Item_yes - vertical scrollable sections on black background
/// Sections are stacked with 4px gap, each with radius:40
class HomeContent extends GetView<SelectCoffeeController> {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.colorGlobalCommon0, // Black background
      child: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primaryNormal),
          );
        }
        return _buildScrollContent();
      }),
    );
  }

  Widget _buildScrollContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Section gap from top (content starts below TopNav)
          const SizedBox(height: 4),

          // Section 1: 원두 목록 (Subscribe)
          SubscribeSection(
            items: controller.visibleCoffeeItems,
            onEditTap: controller.toggleEditMode,
            onViewAllTap: () => Get.toNamed(Routes.selectCoffee),
            onEmptyTap: controller.addNewCoffee,
            onItemTap: (item) => _onCoffeeItemTap(item),
          ),

          const SizedBox(height: 4), // Section gap: 4px

          // Section 2: 추천 원두 (Recommend)
          RecommendSection(
            items: controller.visibleCoffeeItems.take(6).toList(),
            onItemTap: (item) => _onCoffeeItemTap(item),
          ),

          // Bottom safe area padding
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _onCoffeeItemTap(item) {
    Get.toNamed(Routes.beanDetail, arguments: {'bean': item});
  }
}
