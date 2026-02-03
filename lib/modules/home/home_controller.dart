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

  /// Navigate to coffee menu
  void navigateToCoffee() {
    Get.toNamed(Routes.coffeeMain);
  }

  /// Logout
  Future<void> logout() async {
    await _storage.clearAll();
    Get.offAllNamed(Routes.signIn);
  }
}
