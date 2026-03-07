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

  @override
  void onInit() {
    super.onInit();
    // Handle initial tab from route arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('initialTab')) {
      final initialTab = args['initialTab'] as int;
      if (initialTab >= 0 && initialTab <= 3) {
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
    if (index >= 0 && index <= 3) {
      currentTabIndex.value = index;
    }
  }

  /// Navigate to coffee tab (index 0)
  void goToCoffee() => goToTab(0);

  /// Navigate to extraction list tab (index 1)
  void goToExtractionList() => goToTab(1);

  /// Navigate to tasting notes tab (index 2)
  void goToTastingNotes() => goToTab(2);

  /// Navigate to my planet tab (index 3)
  void goToMyPlanet() => goToTab(3);
}
