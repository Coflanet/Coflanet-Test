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

  // Water temperature in °C (92°C for hand drip, 93°C for espresso)
  final _waterTemperature = 92.obs;
  int get waterTemperature => _waterTemperature.value;
  set waterTemperature(int value) =>
      _waterTemperature.value = value.clamp(85, 100);

  // Extraction time in seconds (180s for hand drip, 25s for espresso)
  final _extractionTime = 180.obs;
  int get extractionTime => _extractionTime.value;
  set extractionTime(int value) => _extractionTime.value = value.clamp(15, 600);

  // Custom coffee amount override (null means auto-calculated)
  final _customCoffeeAmount = Rxn<int>();
  int? get customCoffeeAmount => _customCoffeeAmount.value;
  set customCoffeeAmount(int? value) => _customCoffeeAmount.value = value;

  // Custom water amount override (null means auto-calculated)
  final _customWaterAmount = Rxn<int>();
  int? get customWaterAmount => _customWaterAmount.value;
  set customWaterAmount(int? value) => _customWaterAmount.value = value;

  // Water amount in ml
  int get waterAmount {
    if (_customWaterAmount.value != null) {
      return _customWaterAmount.value!;
    }
    const baseWater = 250; // ml per cup
    final strengthMultiplier = 1 - (strength / 200); // Less water = stronger
    return (baseWater * cupsCount * strengthMultiplier).round();
  }

  // Coffee amount in grams
  int get coffeeAmount {
    if (_customCoffeeAmount.value != null) {
      return _customCoffeeAmount.value!;
    }
    const baseGrams = 15; // grams per cup
    final strengthMultiplier = 1 + (strength / 200); // More coffee = stronger
    return (baseGrams * cupsCount * strengthMultiplier).round();
  }

  /// Get extraction time formatted as mm:ss
  String get extractionTimeFormatted {
    final minutes = extractionTime ~/ 60;
    final seconds = extractionTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Reset custom amounts (called when cups or strength changes)
  void _resetCustomAmounts() {
    _customCoffeeAmount.value = null;
    _customWaterAmount.value = null;
  }

  /// Select coffee type
  void selectType(CoffeeType type) {
    _selectedType.value = type;

    // Set defaults based on coffee type
    switch (type) {
      case CoffeeType.handDrip:
        _waterTemperature.value = 92;
        _extractionTime.value = 180; // 3 minutes
        Get.toNamed(Routes.handDrip);
        break;
      case CoffeeType.espresso:
        _waterTemperature.value = 93;
        _extractionTime.value = 25; // 25 seconds
        Get.toNamed(Routes.espresso);
        break;
    }
    _resetCustomAmounts();
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

  /// Update bean (coffee) amount directly
  void updateBeanAmount(int grams) {
    customCoffeeAmount = grams.clamp(10, 30);
  }

  /// Update water temperature directly
  void updateWaterTemperature(int temp) {
    waterTemperature = temp.clamp(80, 100);
  }

  /// Update extraction time directly (in seconds)
  void updateExtractionTime(int seconds) {
    extractionTime = seconds.clamp(15, 600);
  }

  /// Update water amount directly
  void updateWaterAmount(int ml) {
    customWaterAmount = ml.clamp(100, 400);
  }

  /// Get strength label
  String get strengthLabel {
    if (strength < 33) return '연하게';
    if (strength < 66) return '보통';
    return '진하게';
  }
}
