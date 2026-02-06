import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/coffee/main/coffee_main_content.dart';
import 'package:coflanet/modules/extraction/extraction_list_view.dart';
import 'package:coflanet/modules/tasting/tasting_notes_view.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Dynamic theme based on taste profile state
      // Filled (hasTasteProfile=true): Black bg + White bottom nav
      // Empty (hasTasteProfile=false): Light gray bg + Dark bottom nav
      final isFilled = controller.hasTasteProfile;
      final bgColor = isFilled
          ? AppColor
                .colorGlobalCommon0 // #000000 pure black
          : AppColor.colorGlobalCoolNeutral99; // #F7F7F8 light gray

      return Scaffold(
        backgroundColor: bgColor,
        body: IndexedStack(
          index: controller.currentTabIndex.value,
          children: const [
            CoffeeMainContent(), // Tab 0: 원두
            ExtractionListView(), // Tab 1: 추출 목록
            TastingNotesView(), // Tab 2: 시음 기록
            MyPlanetContent(), // Tab 3: My 행성
          ],
        ),
        bottomNavigationBar: _buildBottomTabBar(isFilled),
      );
    });
  }

  Widget _buildBottomTabBar(bool isFilled) {
    // Filled: White bottom nav (#FFFFFF)
    // Empty: Dark bottom nav (#1C1C1E)
    final navBgColor = isFilled
        ? AppColor
              .colorGlobalCommon100 // #FFFFFF white
        : AppColor.colorGlobalCoolNeutral15; // #1B1C1E dark
    final borderColor = isFilled
        ? AppColor
              .colorGlobalCoolNeutral95 // light border for white nav
        : AppColor.colorGlobalCoolNeutral22; // dark border for dark nav
    final unselectedColor = isFilled
        ? AppColor
              .colorGlobalCoolNeutral50 // gray on white
        : AppColor.colorGlobalCoolNeutral50; // gray on dark

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: navBgColor,
          border: Border(top: BorderSide(color: borderColor, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: controller.currentTabIndex.value,
            onTap: controller.onTabTapped,
            backgroundColor: navBgColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColor.primaryNormal,
            unselectedItemColor: unselectedColor,
            selectedLabelStyle: AppTextStyles.caption2Medium,
            unselectedLabelStyle: AppTextStyles.caption2Regular,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.coffee_rounded),
                label: '원두',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: '추출 목록',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit_note_rounded),
                label: '시음 기록',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public_rounded),
                label: 'My 행성',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
