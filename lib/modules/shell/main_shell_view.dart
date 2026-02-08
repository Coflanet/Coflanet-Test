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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Layout constants
    const topNavHeight = 56.0;
    const tabBarContentHeight =
        96.0; // Dark bg (16px) + pill (64px) + margin (16px)
    const contentTopRadius = 40.0;

    return Obx(() {
      // Check if we're in edit mode (for 원두 tab)
      final currentIndex = controller.currentTabIndex.value;
      final bool isEditMode =
          currentIndex == 0 &&
          Get.isRegistered<SelectCoffeeController>() &&
          Get.find<SelectCoffeeController>().isEditing;

      // In edit mode, hide tab bar
      final showTabBar = !isEditMode;

      return Scaffold(
        backgroundColor: AppColor.colorGlobalCommon0, // Pure black
        body: Stack(
          children: [
            // ===== CONTENT AREA =====
            // Content extends from top nav to ABOVE tab bar (or to bottom in edit mode)
            Positioned(
              top: topPadding + topNavHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  // Figma: Light gray background #F5F5F5 for both normal and edit mode
                  color: AppColor.colorGlobalCoolNeutral98, // Figma: #F4F4F5
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
                  // Add bottom padding for tab bar space (only when tab bar is visible)
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: showTabBar
                          ? (tabBarContentHeight + bottomPadding)
                          : 0,
                    ),
                    child: IndexedStack(
                      index: currentIndex,
                      children: const [
                        SelectCoffeeContent(), // Tab 0: 원두
                        ExtractionListView(), // Tab 1: 추출 목록
                        TastingNotesView(), // Tab 2: 시음 기록
                        MyPlanetContent(), // Tab 3: My 행성
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ===== TOP NAVIGATION =====
            // Figma: Top Navigation with gradient mask background
            // Height: 110px (54px status + 56px nav), gradient from transparent to semi-black
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(top: topPadding),
                height: topPadding + topNavHeight,
                decoration: BoxDecoration(
                  // Figma gradient mask: fades from transparent at top to semi-black at bottom
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 0.7, 1.0],
                    colors: [
                      AppColor.colorGlobalCommon0.withValues(
                        alpha: 0.0,
                      ), // Transparent
                      AppColor.colorGlobalCommon0.withValues(alpha: 0.1), // 10%
                      AppColor.colorGlobalCommon0.withValues(alpha: 0.3), // 30%
                      AppColor.colorGlobalCommon0.withValues(
                        alpha: 0.5,
                      ), // 50% - Figma: opacity 0.5
                    ],
                  ),
                ),
                child: _buildTopNavigation(),
              ),
            ),

            // ===== TAB BAR ===== (hidden in edit mode)
            if (showTabBar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildTabBar(bottomPadding, tabBarContentHeight),
              ),
          ],
        ),
      );
    });
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

    // Title changes based on edit mode per Figma
    // Normal: "원두 목록", Edit: "원두 목록 편집"
    final String title = currentIndex == 0 && isEditMode
        ? '원두 목록 편집' // Edit mode title
        : _tabs[currentIndex].navTitle; // Use navTitle for top nav

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Leading: Back button in edit mode, empty otherwise
          if (currentIndex == 0 && isEditMode)
            _buildBackButton()
          else
            const SizedBox(width: 40),

          // Title - Centered in edit mode, Left aligned in normal mode
          Expanded(
            child: isEditMode
                ? Center(
                    child: Text(
                      title,
                      style: AppTextStyles.title3Bold.copyWith(
                        color: AppColor.colorGlobalCommon100,
                        letterSpacing: -0.023,
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

  /// Back button for edit mode - Figma: Circular dark gray button with arrow
  Widget _buildBackButton() {
    final selectController = Get.find<SelectCoffeeController>();

    return GestureDetector(
      onTap: selectController.toggleEditMode,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E), // Dark gray circle
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColor.colorGlobalCommon100,
          size: 18,
        ),
      ),
    );
  }

  /// Edit/Done pill button for 원두 tab
  /// Normal mode: "편집" - Glass effect button
  /// Edit mode: "완료" - Violet pill button per Figma
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
          height: 40,
          constraints: const BoxConstraints(minWidth: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            // Figma: Violet for edit mode, glass effect for normal mode
            color: isEditing
                ? AppColor
                      .colorGlobalViolet50 // Violet pill in edit mode
                : AppColor.colorGlobalCommon100.withValues(
                    alpha: 0.25,
                  ), // Glass effect
            borderRadius: AppRadius.fullBorder, // 99px pill
          ),
          child: Center(
            child: Text(
              isEditing ? '완료' : '편집',
              style: AppTextStyles.body2NormalBold.copyWith(
                color: AppColor.colorGlobalCommon100, // White text
                letterSpacing: 0.0057,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Custom tab bar - Figma: Dark background with pill-shaped tab container inside
  /// Outer: Dark charcoal background with rounded top corners
  /// Inner: 328x64px pill-shaped glass effect container
  Widget _buildTabBar(double bottomPadding, double contentHeight) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: Container(
        // Dark background area - Figma: #1C1C1E
        decoration: const BoxDecoration(color: Color(0xFF1C1C1E)),
        padding: EdgeInsets.only(top: 16, bottom: bottomPadding + 16),
        child: Center(
          child: Container(
            width: 328,
            height: 64,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              // Figma: rgba(112, 115, 124, 0.22) - glass effect
              color: const Color(0xFF70737C).withOpacity(0.22),
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
    final activeColor = const Color(0xFF7D5EF7); // Figma: #7D5EF7
    final inactiveColor = const Color(
      0xFFC2C4C8,
    ).withOpacity(0.88); // Figma: rgba(194, 196, 200, 0.88)

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
          color: isActive ? Colors.black.withOpacity(0.35) : Colors.transparent,
          borderRadius: BorderRadius.circular(99), // Pill shape
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 2),
            // Label
            Text(
              tab.label,
              style: AppTextStyles.caption2Regular.copyWith(
                color: labelColor,
                fontSize: 10,
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
