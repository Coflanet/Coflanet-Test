import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_content.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/community/community_content.dart';
import 'package:coflanet/modules/home/home_content.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/modules/shopping/shopping_content.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  /// Tab data structure for cleaner code
  /// Figma `Home_Item_yes` 기준 5개 탭: 홈, 원두, 커뮤니티, 쇼핑, 마이
  /// Icons: filled for selected, outline for unselected
  static const List<_TabData> _tabs = [
    _TabData(
      iconFilled: Icons.home_rounded,
      iconOutline: Icons.home_outlined,
      label: '홈',
      navTitle: '홈',
    ),
    _TabData(
      iconFilled: Icons.coffee_rounded,
      iconOutline: Icons.coffee_outlined,
      label: '원두',
      navTitle: '원두 목록',
    ),
    _TabData(
      iconFilled: Icons.forum_rounded,
      iconOutline: Icons.forum_outlined,
      label: '커뮤니티',
      navTitle: '커뮤니티',
    ),
    _TabData(
      iconFilled: Icons.shopping_bag_rounded,
      iconOutline: Icons.shopping_bag_outlined,
      label: '쇼핑',
      navTitle: '쇼핑',
    ),
    _TabData(
      iconFilled: Icons.person_rounded,
      iconOutline: Icons.person_outline_rounded,
      label: '마이',
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
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              final currentIndex = controller.currentTabIndex.value;
              final bool isEditMode =
                  currentIndex == MainShellController.tabBean &&
                  Get.isRegistered<SelectCoffeeController>() &&
                  Get.find<SelectCoffeeController>().isEditing;
              final bottomInset = isEditMode ? 0.0 : tabBarTotalHeight;
              // 홈 탭은 자체 헤더를 가지므로 topNavigation 영역을 비워 둔다.
              // 그 외 탭은 기존처럼 topPadding + topNavHeight 만큼 콘텐츠를 내림.
              final bool isHomeTab = currentIndex == MainShellController.tabHome;
              final topInset = isHomeTab ? 0.0 : (topPadding + topNavHeight);

              if (currentIndex == MainShellController.tabMy) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: topInset,
                    bottom: bottomInset,
                  ),
                  child: const MyPlanetContent(),
                );
              }
              // 홈 탭은 다크 테마 → 배경 검은색
              // 그 외 탭은 기존 밝은 배경 유지
              final Color contentBgColor = isHomeTab
                  ? AppColor.colorGlobalCommon0
                  : AppColor.backgroundNormalAlternative;
              return Padding(
                padding: EdgeInsets.only(top: topInset),
                child: Container(
                  decoration: BoxDecoration(
                    color: contentBgColor,
                    borderRadius: isHomeTab
                        ? BorderRadius.zero
                        : BorderRadius.only(
                            topLeft: Radius.circular(contentTopRadius),
                            topRight: Radius.circular(contentTopRadius),
                          ),
                  ),
                  child: ClipRRect(
                    borderRadius: isHomeTab
                        ? BorderRadius.zero
                        : BorderRadius.only(
                            topLeft: Radius.circular(contentTopRadius),
                            topRight: Radius.circular(contentTopRadius),
                          ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: _buildCurrentTab(currentIndex),
                    ),
                  ),
                ),
              );
            }),
          ),

          // ===== TOP NAVIGATION (Obx: only title/buttons rebuild) =====
          // 홈 탭에서는 자체 헤더가 있으므로 topNavigation 영역을 비워 둔다.
          // Stack 의 직접 자식이 Positioned 여야 하므로 Obx 는 안쪽에 둔다.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final currentIndex = controller.currentTabIndex.value;
              if (currentIndex == MainShellController.tabHome) {
                return const SizedBox.shrink();
              }
              return Container(
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
                child: _buildTopNavigation(),
              );
            }),
          ),

          // ===== TAB BAR (Obx: only tab bar rebuilds) =====
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final currentIndex = controller.currentTabIndex.value;
              final bool isEditMode =
                  currentIndex == MainShellController.tabBean &&
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

  /// Only renders the active tab (replaces IndexedStack that kept all 5 tabs alive)
  Widget _buildCurrentTab(int index) {
    switch (index) {
      case MainShellController.tabHome:
        return const HomeContent();
      case MainShellController.tabBean:
        return const SelectCoffeeContent();
      case MainShellController.tabCommunity:
        return const CommunityContent();
      case MainShellController.tabShopping:
        return const ShoppingContent();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Custom top navigation (NOT AppBar) - Figma: Top Navigation/Top Navigation
  /// Height: 56px, title LEFT-ALIGNED per Figma design
  /// Edit mode: Back button + centered title + violet "완료" button
  Widget _buildTopNavigation() {
    final currentIndex = controller.currentTabIndex.value;

    // 원두 탭 (index 1) 의 편집 모드 여부
    final bool isEditMode =
        currentIndex == MainShellController.tabBean &&
        Get.isRegistered<SelectCoffeeController>() &&
        Get.find<SelectCoffeeController>().isEditing;

    // 탭/모드별 타이틀 결정
    // - 원두 탭 편집모드: "원두 목록 편집"
    // - 마이 탭: 사용자명 (My 행성 별칭)
    // - 그 외: _tabs[index].navTitle
    String title;
    if (currentIndex == MainShellController.tabBean && isEditMode) {
      title = '원두 목록 편집';
    } else if (currentIndex == MainShellController.tabMy) {
      if (Get.isRegistered<MyPlanetController>()) {
        title = Get.find<MyPlanetController>().userName;
      } else {
        title = '커플래니터';
      }
    } else {
      title = _tabs[currentIndex].navTitle;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Leading: Back button in edit mode only
          // Figma: In normal mode, title is flush left (no spacer)
          if (currentIndex == MainShellController.tabBean && isEditMode)
            _buildBackButton(),

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
          if (currentIndex == MainShellController.tabBean) _buildEditButton(),
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

  /// Custom tab bar - Figma `Home_Item_yes` 기준 5탭
  /// 배경 패널 없이 투명 — pill-shaped glass 컨테이너만 화면 위에 떠 있다.
  /// Liquid Glass: BackdropFilter 블러 + 어두운 틴트.
  /// 밝은 콘텐츠(원두/커뮤니티/쇼핑)가 탭바 뒤로 깔려도 항상 다크 글래스로 보이도록
  /// 배경 의존적인 반투명 회색 대신 어두운 틴트를 고정 사용한다.
  Widget _buildTabBar() {
    return Builder(
      builder: (context) {
        // 5개 탭을 수용하기 위해 화면 너비에서 좌우 16px 여백을 뺀 폭 사용.
        final screenWidth = MediaQuery.of(context).size.width;
        final innerWidth = (screenWidth - 32).clamp(280.0, 400.0);

        return Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 16),
          child: Center(
            child: SizedBox(
              width: innerWidth,
              height: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.colorGlobalCoolNeutral15.withValues(
                        alpha: 0.72,
                      ),
                      borderRadius: BorderRadius.circular(99),
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
            ),
          ),
        );
      },
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

    return Semantics(
      label: '${tab.label} 탭',
      selected: isActive,
      button: true,
      child: GestureDetector(
        onTap: () => controller.onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56, // Fill most of the 64px container height
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            // Figma: Active = black @ 35% opacity, pill shape
            color: isActive
                ? AppColor.colorGlobalCommon0.withValues(alpha: 0.35)
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
              // Label - 5탭 수용: 라벨이 잘리지 않도록 줄임 + Auto-shrink
              Text(
                tab.label,
                style: AppTextStyles.caption2Medium.copyWith(
                  color: labelColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
