import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/routes/app_pages.dart';

class HomeController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  // Tab navigation
  final _currentTab = 0.obs;
  int get currentTab => _currentTab.value;
  set currentTab(int value) => _currentTab.value = value;

  // User info
  String get userName => _storage.getUserName() ?? '사용자';

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    await executeWithLoading(() async {
      // Load home data - for now just simulate delay
      await Future.delayed(const Duration(milliseconds: 500));
    });
  }

  /// Navigate to coffee menu (via main shell)
  void navigateToCoffee() {
    Get.toNamed(Routes.mainShell, arguments: {'initialTab': 0});
  }

  /// Navigate to my taste screen
  void navigateToMyTaste() {
    Get.toNamed(Routes.myTaste);
  }

  /// Navigate to my planet screen (via main shell)
  void navigateToMyPlanet() {
    Get.toNamed(Routes.mainShell, arguments: {'initialTab': 3});
  }

  /// Navigate to main shell
  void navigateToMainShell({int initialTab = 0}) {
    Get.toNamed(Routes.mainShell, arguments: {'initialTab': initialTab});
  }

  /// Logout
  Future<void> logout() async {
    await _storage.clearAll();
    Get.offAllNamed(Routes.signIn);
  }

  /// [DEV] Reset onboarding to test survey flow
  Future<void> devResetOnboarding() async {
    await _storage.setOnboardingComplete(false);
    Get.offAllNamed(Routes.surveyIntro);
  }
}
