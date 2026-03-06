import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_content.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/extraction/extraction_list_view.dart';
import 'package:coflanet/modules/tasting/tasting_notes_view.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  /// Tab data structure for cleaner code
  /// Figma: 원두 목록, 추출 목록, 시음 기록, My 행성
  /// Icons: filled for selected, outline for unselected
  static const List<_TabData> _tabs = [
    _TabData(
      iconFilled: Icons.coffee_rounded,
      iconOutline: Icons.coffee_outlined,
      label: '원두',
      navTitle: '원두 목록',
    ),
    _TabData(
      iconFilled: Icons.laptop_mac_rounded,
      iconOutline: Icons.laptop_mac_outlined,
      label: '추출 목록',
      navTitle: '추출 목록',
    ),
    _TabData(
      iconFilled: Icons.edit_note_rounded,
      iconOutline: Icons.edit_note,
      label: '시음 기록',
      navTitle: '시음 기록',
    ),
    _TabData(
      iconFilled: Icons.person_rounded,
      iconOutline: Icons.person_outline_rounded,
      label: 'My 행성',
      navTitle: 'My 행성',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Layout constants
    const topNavHeight = 64.0;
    // Tab bar: 6px top + 64px pill + 16px bottom = 86px
    const tabBarTotalHeight = 86.0;
    const contentTopRadius = 40.0;

    return Scaffold(
      backgroundColor: AppColor.colorGlobalCommon0,
      body: Stack(
        children: [
          // ===== CONTENT AREA (Obx: only content rebuilds on tab switch) =====
          Positioned(
            top: topPadding + topNavHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              final currentIndex = controller.currentTabIndex.value;
              final bool isEditMode =
                  currentIndex == 0 &&
                  Get.isRegistered<SelectCoffeeController>() &&
                  Get.find<SelectCoffeeController>().isEditing;
              final bottomInset = isEditMode ? 0.0 : tabBarTotalHeight;

              if (currentIndex == 3) {
                return Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: const MyPlanetContent(),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCoolNeutral98,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(contentTopRadius),
                    topRight: Radius.circular(contentTopRadius),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(contentTopRadius),
                    topRight: Radius.circular(contentTopRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: _buildCurrentTab(currentIndex),
                  ),
                ),
              );
            }),
          ),

          // ===== TOP NAVIGATION (Obx: only title/buttons rebuild) =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              height: topPadding + topNavHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.7, 1.0],
                  colors: [
                    AppColor.colorGlobalCommon0.withValues(alpha: 0.0),
                    AppColor.colorGlobalCommon0.withValues(alpha: 0.1),
                    AppColor.colorGlobalCommon0.withValues(alpha: 0.3),
                    AppColor.colorGlobalCommon0.withValues(alpha: 0.5),
                  ],
                ),
              ),
              child: Obx(() => _buildTopNavigation()),
            ),
          ),

          // ===== TAB BAR (Obx: only tab bar rebuilds) =====
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final currentIndex = controller.currentTabIndex.value;
              final bool isEditMode =
                  currentIndex == 0 &&
                  Get.isRegistered<SelectCoffeeController>() &&
                  Get.find<SelectCoffeeController>().isEditing;
              if (isEditMode) return const SizedBox.shrink();
              return _buildTabBar();
            }),
          ),
        ],
      ),
    );
  }

  /// Only renders the active tab (replaces IndexedStack that kept all 4 tabs alive)
  Widget _buildCurrentTab(int index) {
    switch (index) {
      case 0:
        return const SelectCoffeeContent();
      case 1:
        return const ExtractionListView();
      case 2:
        return const TastingNotesView();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Custom top navigation (NOT AppBar) - Figma: Top Navigation/Top Navigation
  /// Height: 56px, title LEFT-ALIGNED per Figma design
  /// Edit mode: Back button + centered title + violet "완료" button
  Widget _buildTopNavigation() {
    final currentIndex = controller.currentTabIndex.value;

    // Get edit mode state for 원두 tab title
    final bool isEditMode =
        currentIndex == 0 &&
        Get.isRegistered<SelectCoffeeController>() &&
        Get.find<SelectCoffeeController>().isEditing;

    // Title changes based on tab and mode per Figma
    // Tab 0 Normal: "원두 목록", Tab 0 Edit: "원두 목록 편집"
    // Tab 3 (My 행성): Show username only (not "My 행성")
    String title;
    if (currentIndex == 0 && isEditMode) {
      title = '원두 목록 편집'; // Edit mode title
    } else if (currentIndex == 3) {
      // For My 행성 tab, show username from MyPlanetController
      if (Get.isRegistered<MyPlanetController>()) {
        title = Get.find<MyPlanetController>().userName;
      } else {
        title = '커플래니터'; // Fallback
      }
    } else {
      title = _tabs[currentIndex].navTitle; // Use navTitle for other tabs
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Leading: Back button in edit mode only
          // Figma: In normal mode, title is flush left (no spacer)
          if (currentIndex == 0 && isEditMode) _buildBackButton(),

          // Title - Centered in edit mode, Left aligned (flush) in normal mode
          // Figma Edit Mode: Headline 2/Bold - 17px, weight 600, line-height 141.2%
          Expanded(
            child: isEditMode
                ? Center(
                    child: Text(
                      title,
                      style: AppTextStyles.headline2Bold.copyWith(
                        color: AppColor.colorGlobalCommon100,
                      ),
                    ),
                  )
                : Text(
                    title,
                    style: AppTextStyles.title3Bold.copyWith(
                      color: AppColor.colorGlobalCommon100,
                      letterSpacing: -0.023,
                    ),
                  ),
          ),

          // Trailing action button (only for 원두 tab)
          if (currentIndex == 0) _buildEditButton(),
        ],
      ),
    );
  }

  /// Back button for edit mode - Figma: Button/Icon/LiquidGlass
  /// Size: 40x40, Liquid Glass effect with Fill layer, icon #F7F7F8 (20x20)
  Widget _buildBackButton() {
    final selectController = Get.find<SelectCoffeeController>();

    return GestureDetector(
      onTap: selectController.toggleEditMode,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(6), // Figma: padding 6px
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Figma: Fill layer - complex gradient with opacity 0.67
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.colorGlobalCommon100.withValues(alpha: 0.25 * 0.67),
              AppColor.colorGlobalCommon0.withValues(alpha: 0.6 * 0.67),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Figma: Glass Effect - rgba(0,0,0,0.2)
            color: AppColor.colorGlobalCommon0.withValues(alpha: 0.2),
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_left,
              color: AppColor.colorGlobalCoolNeutral99, // Figma: #F7F7F8
              size: 20, // Figma: 20x20 icon
            ),
          ),
        ),
      ),
    );
  }

  /// Edit/Done pill button for 원두 tab
  /// Normal mode: "편집" - Glass effect button
  /// Edit mode: "완료" - Button/Solid/LiquidGlass Primary (48x40)
  Widget _buildEditButton() {
    // Get SelectCoffeeController for edit mode state
    // Use isRegistered check to avoid errors during lazy initialization
    if (!Get.isRegistered<SelectCoffeeController>()) {
      return const SizedBox(width: 48);
    }
    final selectController = Get.find<SelectCoffeeController>();

    return Obx(() {
      final isEditing = selectController.isEditing;

      return GestureDetector(
        onTap: selectController.toggleEditMode,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ), // Adjusted padding for text visibility
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99), // Figma: 99px pill
            // Figma: Tint layer for edit mode (Violet Liquid Glass Primary)
            color: isEditing
                ? AppColor
                      .colorGlobalViolet60 // Figma: #7D5EF7 violet
                : AppColor.colorGlobalCommon100.withValues(alpha: 0.25),
            // Figma: box-shadow: 0px 0px 2px rgba(0,0,0,0.1), 0px 1px 8px rgba(0,0,0,0.12)
            boxShadow: isEditing
                ? [
                    BoxShadow(
                      color: AppColor.colorGlobalCommon0.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: Offset.zero,
                    ),
                    BoxShadow(
                      color: AppColor.colorGlobalCommon0.withValues(
                        alpha: 0.12,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            isEditing ? '완료' : '편집',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15, // Slightly smaller for better fit
              fontWeight: FontWeight.w600, // Figma: 600
              height: 1.2, // Reduced line height
              letterSpacing: 0.01,
              color: AppColor.colorGlobalCoolNeutral99, // Figma: #F7F7F8
            ),
          ),
        ),
      );
    });
  }

  /// Custom tab bar - Figma: Dark background with pill-shaped tab container inside
  /// Outer: Dark charcoal background with rounded top corners
  /// Inner: 328x64px pill-shaped glass effect container
  Widget _buildTabBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Container(
        // Dark background area - Figma: #1C1C1E
        decoration: BoxDecoration(color: AppColor.colorGlobalCoolNeutral15),
        padding: const EdgeInsets.only(top: 6, bottom: 16),
        child: Center(
          child: Container(
            width: 328,
            height: 64,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              // Figma: rgba(112, 115, 124, 0.22) - glass effect
              color: AppColor.lineNormalNormal,
              borderRadius: BorderRadius.circular(99), // Pill shape
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_tabs.length, (index) {
                return Expanded(child: _buildTabItem(index));
              }),
            ),
          ),
        ),
      ),
    );
  }

  /// Individual tab item - Figma design:
  /// - Active: Black background @ 35% opacity, pill shape (99px radius)
  /// - Active color: #7D5EF7 (violet)
  /// - Inactive color: rgba(194, 196, 200, 0.88) (light gray)
  Widget _buildTabItem(int index) {
    final isActive = controller.currentTabIndex.value == index;
    final tab = _tabs[index];

    // Colors per Figma CSS
    final activeColor = AppColor.colorGlobalViolet60; // Figma: #7D5EF7
    final inactiveColor =
        AppColor.inverseLabelNeutral; // rgba(194, 196, 200, 0.88)

    // Selected: violet, Unselected: light gray
    final iconColor = isActive ? activeColor : inactiveColor;
    final labelColor = isActive ? activeColor : inactiveColor;

    // Use filled icon for selected, outline for unselected
    final icon = isActive ? tab.iconFilled : tab.iconOutline;

    return GestureDetector(
      onTap: () => controller.onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56, // Fill most of the 64px container height
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          // Figma: Active = black @ 35% opacity, pill shape
          color: isActive
              ? AppColor.colorGlobalCommon0.withOpacity(0.35)
              : AppColor.transparent,
          borderRadius: BorderRadius.circular(99), // Pill shape
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 2),
            // Label - Figma: Caption 2/Medium, 11px, 500 weight, letter-spacing 0.0311em
            Text(
              tab.label,
              style: AppTextStyles.caption2Medium.copyWith(
                color: labelColor,
                letterSpacing: 0.0311 * 11, // 0.0311em at 11px
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab data model
class _TabData {
  final IconData iconFilled; // Filled icon for selected state
  final IconData iconOutline; // Outline icon for unselected state
  final String label; // Tab bar label
  final String navTitle; // Top navigation title

  const _TabData({
    required this.iconFilled,
    required this.iconOutline,
    required this.label,
    required this.navTitle,
  });
}
