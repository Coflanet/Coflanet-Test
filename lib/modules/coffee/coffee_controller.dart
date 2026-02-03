import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

enum CoffeeType { handDrip, espresso }

class CoffeeController extends BaseController {
  // Selected coffee type
  final _selectedType = Rxn<CoffeeType>();
  CoffeeType? get selectedType => _selectedType.value;

  // Cups count
  final _cupsCount = 1.obs;
  int get cupsCount => _cupsCount.value;
  set cupsCount(int value) => _cupsCount.value = value.clamp(1, 4);

  // Strength (0-100)
  final _strength = 50.obs;
  int get strength => _strength.value;
  set strength(int value) => _strength.value = value.clamp(0, 100);

  // Water amount in ml
  int get waterAmount {
    const baseWater = 250; // ml per cup
    final strengthMultiplier = 1 - (strength / 200); // Less water = stronger
    return (baseWater * cupsCount * strengthMultiplier).round();
  }

  // Coffee amount in grams
  int get coffeeAmount {
    const baseGrams = 15; // grams per cup
    final strengthMultiplier = 1 + (strength / 200); // More coffee = stronger
    return (baseGrams * cupsCount * strengthMultiplier).round();
  }

  /// Select coffee type
  void selectType(CoffeeType type) {
    _selectedType.value = type;

    switch (type) {
      case CoffeeType.handDrip:
        Get.toNamed(Routes.handDrip);
        break;
      case CoffeeType.espresso:
        Get.toNamed(Routes.espresso);
        break;
    }
  }

  /// Navigate to settings
  void goToSettings() {
    Get.toNamed(Routes.coffeeSettings);
  }

  /// Increment cups
  void incrementCups() {
    if (_cupsCount.value < 4) {
      _cupsCount.value++;
    }
  }

  /// Decrement cups
  void decrementCups() {
    if (_cupsCount.value > 1) {
      _cupsCount.value--;
    }
  }

  /// Get strength label
  String get strengthLabel {
    if (strength < 33) return '연하게';
    if (strength < 66) return '보통';
    return '진하게';
  }
}
