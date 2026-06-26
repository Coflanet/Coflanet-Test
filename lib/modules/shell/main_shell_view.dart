import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/modules/shell/main_shell_controller.dart';
import 'package:coflanet/modules/shell/widgets/shell_tab_bar.dart';
import 'package:coflanet/modules/shell/widgets/shell_top_navigation.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_content.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/community/community_content.dart';
import 'package:coflanet/modules/home/home_content.dart';
import 'package:coflanet/modules/planet/my_planet_content.dart';
import 'package:coflanet/modules/planet/my_planet_controller.dart';
import 'package:coflanet/modules/shopping/shopping_content.dart';

/// 메인 셸 — 5탭 콘텐츠 + 상단 네비 + 하단 글래스 탭바 (위젯은 widgets/ 분리).
///
/// Obx 3분할 입자 보존: content / topNav / tabBar 가 각각 독립 Obx 로
/// 부분 리빌드된다. currentTabIndex/isEditing/userName 등 Rx 읽기는 전부
/// 각 Positioned 의 Obx 클로저 안에서 평가해 위젯에 값/슬롯으로 주입한다.
/// isHomeTab/isEditMode 인셋·radius 분기와 슬롯 공급자(백버튼/편집버튼)는
/// 컨트롤러 결합 때문에 View 에 잔류한다.
class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final colors = AppColorScheme.of(context);

    // Layout constants
    const topNavHeight = ShellTopNavigation.navHeight;
    // Tab bar: 6px top + 64px pill + 16px bottom = 86px
    // + 시스템 네비 인셋 (ShellTabBar 가 같은 인셋을 하단 여백에 더함)
    final tabBarTotalHeight = 86.0 + bottomPadding;
    const contentTopRadius = 40.0;

    return Scaffold(
      backgroundColor: colors.backgroundNormalAlternative,
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
              final bool isEditMode = _isBeanEditMode(currentIndex);
              final bottomInset = isEditMode ? 0.0 : tabBarTotalHeight;
              // 홈 탭은 자체 헤더를 가지므로 topNavigation 영역을 비워 둔다.
              // 그 외 탭은 기존처럼 topPadding + topNavHeight 만큼 콘텐츠를 내림.
              final bool isHomeTab =
                  currentIndex == MainShellController.tabHome;
              final bool isBeanTab =
                  currentIndex == MainShellController.tabBean;
              final bool isShoppingTab =
                  currentIndex == MainShellController.tabShopping;
              final topInset = isHomeTab ? 0.0 : (topPadding + topNavHeight);

              if (currentIndex == MainShellController.tabMy) {
                // 마이 화면: Static/Black 캔버스(라이트·다크 공통, task 4 방향 B).
                // 전역 스킴은 미변경 — 이 탭만 로컬 검정. 하단 인셋은
                // MyPlanetContent 의 bottomScrollInset 가 소유하므로 여기선 미적용.
                return ColoredBox(
                  color: AppColor.staticBlack,
                  child: Padding(
                    padding: EdgeInsets.only(top: topInset),
                    child: const MyPlanetContent(),
                  ),
                );
              }

              if (isBeanTab || isShoppingTab) {
                // 원두·쇼핑 화면: Static/Black 캔버스(재디자인 카드 시스템).
                // ColoredBox 가 top:0 을 덮어 상태바 뒤까지 검정으로 채우고,
                // AnnotatedRegion 으로 검정 위 상태바 아이콘을 밝게 강제한다.
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: ColoredBox(
                    color: AppColor.staticBlack,
                    child: Padding(
                      padding: EdgeInsets.only(top: topInset),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: bottomInset),
                        child: _buildCurrentTab(currentIndex),
                      ),
                    ),
                  ),
                );
              }

              // 콘텐츠 배경 — 홈은 Static/Black 캔버스(라이트·다크 공통, task 4),
              // 미마이그레이션 탭(커뮤니티)은 기존 테마 스킴 배경(둥근 시트) 유지.
              final Color contentBgColor = isHomeTab
                  ? AppColor.staticBlack
                  : colors.backgroundNormalAlternative;
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
              final bool isEditMode = _isBeanEditMode(currentIndex);
              // 마이·원두 탭은 Static/Black 캔버스 위 — 상단 네비(카드 밖 크롬)는
              // 캔버스(다크) 스킴으로 그려 타이틀/버튼이 검정 위에서 사라지지 않게.
              final bool isDarkNav =
                  currentIndex == MainShellController.tabMy ||
                  currentIndex == MainShellController.tabBean ||
                  currentIndex == MainShellController.tabShopping;
              final navColors = isDarkNav ? AppColorScheme.canvas : colors;
              // 타이틀 계산 — 마이탭 userName(RxString) 구독 보존을 위해
              // 반드시 이 Obx 클로저 안에서 동기 평가한다.
              final title = _resolveTitle(currentIndex, isEditMode);
              final nav = ShellTopNavigation(
                topPadding: topPadding,
                title: title,
                isEditMode: isEditMode,
                // 편집모드에서만 백버튼 (isEditMode 는 원두 탭 전제 포함)
                leading: isEditMode ? _buildBackButton(navColors) : null,
                // 원두 탭에서만 편집/완료 버튼
                trailing: currentIndex == MainShellController.tabBean
                    ? _buildEditButton(navColors)
                    : null,
              );
              if (isDarkNav) {
                return Theme(
                  data: Theme.of(context).copyWith(brightness: Brightness.dark),
                  child: nav,
                );
              }
              return nav;
            }),
          ),

          // ===== TAB BAR (Obx: only tab bar rebuilds) =====
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final currentIndex = controller.currentTabIndex.value;
              final bool isEditMode = _isBeanEditMode(currentIndex);
              if (isEditMode) return const SizedBox.shrink();
              return ShellTabBar(
                currentIndex: currentIndex,
                onTabTapped: controller.onTabTapped,
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 원두 탭 편집모드 여부 — Obx 클로저 안에서 호출해 isEditing(Rx) 구독 유지.
  /// isRegistered 가드: fenix lazyPut 재초기화 타이밍에 Get.find 예외 방지.
  bool _isBeanEditMode(int currentIndex) {
    return currentIndex == MainShellController.tabBean &&
        Get.isRegistered<SelectCoffeeController>() &&
        Get.find<SelectCoffeeController>().isEditing;
  }

  /// 탭/모드별 타이틀 — Obx 클로저 안에서만 호출할 것 (userName Rx 구독).
  /// - 원두 탭 편집모드: "원두 목록 편집"
  /// - 마이 탭: 사용자명 (My 행성 별칭)
  /// - 그 외: ShellTabBar.tabs[index].navTitle
  String _resolveTitle(int currentIndex, bool isEditMode) {
    if (currentIndex == MainShellController.tabBean && isEditMode) {
      return '원두 목록 편집';
    }
    if (currentIndex == MainShellController.tabMy) {
      if (Get.isRegistered<MyPlanetController>()) {
        return Get.find<MyPlanetController>().userName;
      }
      return '커플래니터';
    }
    return ShellTabBar.tabs[currentIndex].navTitle;
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

  /// Back button for edit mode - Figma: Button/Icon/LiquidGlass
  /// Size: 40x40, 테마 반응 — 페이지 배경 위에서 대비되는 원형 fill + 라벨색 아이콘
  Widget _buildBackButton(AppColorScheme colors) {
    final selectController = Get.find<SelectCoffeeController>();

    return GestureDetector(
      onTap: selectController.toggleEditMode,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(6), // Figma: padding 6px
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.componentFillStrong,
        ),
        child: Center(
          child: Icon(
            Icons.chevron_left,
            color: colors.labelNormal,
            size: 20, // Figma: 20x20 icon
          ),
        ),
      ),
    );
  }

  /// Edit/Done pill button for 원두 tab
  /// Normal mode: "편집" - 페이지 배경 위 대비 pill (테마 반응)
  /// Edit mode: "완료" - Button/Solid/LiquidGlass Primary (48x40)
  Widget _buildEditButton(AppColorScheme colors) {
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
            borderRadius: AppRadius.fullBorder, // Figma: pill
            // Figma: Tint layer for edit mode (Violet Liquid Glass Primary)
            color: isEditing
                ? colors.primaryNormal
                : colors.componentFillStrong,
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
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15, // Slightly smaller for better fit
              fontWeight: FontWeight.w600, // Figma: 600
              height: 1.2, // Reduced line height
              letterSpacing: 0.01,
              // 완료(보라 배경): 항상 흰색 / 편집(중립 pill): 테마 라벨색
              color: isEditing
                  ? AppColor.staticLabelWhiteStrong
                  : colors.labelNormal,
            ),
          ),
        ),
      );
    });
  }
}
