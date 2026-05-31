import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';

class MainShellController extends BaseController {
  final SurveyService _surveyService = Get.find<SurveyService>();

  /// Current tab index
  final RxInt currentTabIndex = 0.obs;

  /// Whether user has completed taste profile survey
  /// Used for dynamic theme switching (Filled vs Empty state)
  bool get hasTasteProfile => _surveyService.hasResult;

  /// 탭 인덱스 매핑 (Figma `Home_Item_yes` 5개 탭):
  /// 0: 홈, 1: 원두, 2: 커뮤니티, 3: 쇼핑, 4: 마이
  static const int tabHome = 0;
  static const int tabBean = 1;
  static const int tabCommunity = 2;
  static const int tabShopping = 3;
  static const int tabMy = 4;
  static const int _maxTabIndex = tabMy;

  @override
  void onInit() {
    super.onInit();
    // Handle initial tab from route arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('initialTab')) {
      final initialTab = args['initialTab'] as int;
      if (initialTab >= 0 && initialTab <= _maxTabIndex) {
        currentTabIndex.value = initialTab;
      }
    }
  }

  /// Change tab
  void onTabTapped(int index) {
    currentTabIndex.value = index;
  }

  /// Navigate to specific tab by index
  void goToTab(int index) {
    if (index >= 0 && index <= _maxTabIndex) {
      currentTabIndex.value = index;
    }
  }

  /// 홈 탭으로 이동 (index 0)
  void goToHome() => goToTab(tabHome);

  /// 원두 탭으로 이동 (index 1)
  void goToCoffee() => goToTab(tabBean);

  /// 커뮤니티 탭으로 이동 (index 2)
  void goToCommunity() => goToTab(tabCommunity);

  /// 쇼핑 탭으로 이동 (index 3)
  void goToShopping() => goToTab(tabShopping);

  /// 마이 탭으로 이동 (index 4)
  void goToMyPlanet() => goToTab(tabMy);
}
