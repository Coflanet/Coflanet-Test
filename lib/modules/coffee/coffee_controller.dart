import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

enum CoffeeType { handDrip, espresso }

/// Hand Drip Extraction Step Model
class HandDripStep {
  final String id;
  final String title;
  final int waterAmount; // ml
  final Duration duration;

  const HandDripStep({
    required this.id,
    required this.title,
    required this.waterAmount,
    required this.duration,
  });

  HandDripStep copyWith({
    String? id,
    String? title,
    int? waterAmount,
    Duration? duration,
  }) {
    return HandDripStep(
      id: id ?? this.id,
      title: title ?? this.title,
      waterAmount: waterAmount ?? this.waterAmount,
      duration: duration ?? this.duration,
    );
  }
}

class CoffeeController extends BaseController {
  // Selected coffee type
  final _selectedType = Rxn<CoffeeType>();
  CoffeeType? get selectedType => _selectedType.value;

  // Cups count (1-6 per Figma design)
  final _cupsCount = 1.obs;
  int get cupsCount => _cupsCount.value;
  set cupsCount(int value) => _cupsCount.value = value.clamp(1, 6);

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

  // Grind size in μm (microns)
  // Hand drip: 800-1200μm (medium), Espresso: 200-400μm (fine)
  final _grindSize = 1000.obs;
  int get grindSize => _grindSize.value;
  set grindSize(int value) => _grindSize.value = value.clamp(200, 1600);

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
        _grindSize.value = 1000; // Medium grind for hand drip
        Get.toNamed(Routes.handDrip);
        break;
      case CoffeeType.espresso:
        _waterTemperature.value = 93;
        _extractionTime.value = 25; // 25 seconds
        _grindSize.value = 300; // Fine grind for espresso
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
    if (_cupsCount.value < 6) {
      _cupsCount.value++;
    }
  }

  /// Decrement cups
  void decrementCups() {
    if (_cupsCount.value > 1) {
      _cupsCount.value--;
    }
  }

  /// Set cups count directly
  void setCups(int cups) {
    cupsCount = cups;
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

  /// Update grind size directly (in μm)
  void updateGrindSize(int microns) {
    grindSize = microns.clamp(200, 1600);
  }

  /// Get grind size formatted with unit
  String get grindSizeFormatted => '$grindSize μm';

  /// Get grind size label based on current value
  String get grindSizeLabel {
    if (grindSize < 400) return '에스프레소 (곱게)';
    if (grindSize < 600) return '모카포트';
    if (grindSize < 800) return '에어로프레스';
    if (grindSize < 1000) return '푸어오버 (중간)';
    if (grindSize < 1200) return '드립 (중간)';
    if (grindSize < 1400) return '프렌치프레스';
    return '콜드브루 (굵게)';
  }

  /// Get strength label
  String get strengthLabel {
    if (strength < 33) return '연하게';
    if (strength < 66) return '보통';
    return '진하게';
  }

  // ===== Selected Bean (Edit Mode) =====

  /// Selected bean ID for editing
  final _selectedBeanId = Rxn<String>();
  String? get selectedBeanId => _selectedBeanId.value;

  /// Selected bean name for editing
  final _selectedBeanName = ''.obs;
  String get selectedBeanName => _selectedBeanName.value;

  /// Set selected bean info (called when navigating from coffee list)
  void setSelectedBean({required String id, required String name}) {
    _selectedBeanId.value = id;
    _selectedBeanName.value = name;
  }

  // ===== Hand Drip Extraction Steps =====

  /// Extraction steps for hand drip recipe
  final _extractionSteps = <HandDripStep>[].obs;
  List<HandDripStep> get extractionSteps => _extractionSteps;

  /// Total water amount from all steps
  int get totalStepsWaterAmount {
    if (_extractionSteps.isEmpty) return waterAmount;
    return _extractionSteps.fold(0, (sum, step) => sum + step.waterAmount);
  }

  /// Total extraction time from all steps
  Duration get totalStepsDuration {
    if (_extractionSteps.isEmpty) return Duration(seconds: extractionTime);
    return _extractionSteps.fold(
      Duration.zero,
      (sum, step) => sum + step.duration,
    );
  }

  /// Formatted total extraction time
  String get totalStepsTimeFormatted {
    final total = totalStepsDuration;
    final minutes = total.inMinutes;
    final seconds = total.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Initialize default extraction steps for hand drip
  void initializeDefaultSteps() {
    _extractionSteps.clear();
    _extractionSteps.addAll([
      HandDripStep(
        id: '1',
        title: '뜸 들이기',
        waterAmount: 30,
        duration: const Duration(seconds: 30),
      ),
      HandDripStep(
        id: '2',
        title: '1차 추출',
        waterAmount: 100,
        duration: const Duration(seconds: 60),
      ),
      HandDripStep(
        id: '3',
        title: '2차 추출',
        waterAmount: 80,
        duration: const Duration(seconds: 90),
      ),
    ]);
  }

  /// Add new extraction step
  void addExtractionStep() {
    final stepNumber = _extractionSteps.length;
    String title;

    if (stepNumber == 0) {
      title = '뜸 들이기';
    } else {
      title = '$stepNumber차 추출';
    }

    _extractionSteps.add(
      HandDripStep(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        waterAmount: 50,
        duration: const Duration(seconds: 30),
      ),
    );
  }

  /// Delete extraction step by id
  void deleteExtractionStep(String id) {
    _extractionSteps.removeWhere((step) => step.id == id);
    // Renumber remaining steps
    _renumberSteps();
  }

  /// Renumber steps after deletion
  void _renumberSteps() {
    for (int i = 0; i < _extractionSteps.length; i++) {
      final step = _extractionSteps[i];
      String newTitle;
      if (i == 0) {
        newTitle = '뜸 들이기';
      } else {
        newTitle = '$i차 추출';
      }
      _extractionSteps[i] = step.copyWith(title: newTitle);
    }
  }

  /// Update step water amount
  void updateStepWaterAmount(String id, int amount) {
    final index = _extractionSteps.indexWhere((step) => step.id == id);
    if (index != -1) {
      _extractionSteps[index] = _extractionSteps[index].copyWith(
        waterAmount: amount.clamp(10, 500),
      );
    }
  }

  /// Update step duration
  void updateStepDuration(String id, Duration duration) {
    final index = _extractionSteps.indexWhere((step) => step.id == id);
    if (index != -1) {
      _extractionSteps[index] = _extractionSteps[index].copyWith(
        duration: duration,
      );
    }
  }

  // ===== New Recipe (Add Mode) =====

  /// Bean name for new recipe (add mode)
  final _newRecipeBeanName = ''.obs;
  String get newRecipeBeanName => _newRecipeBeanName.value;
  set newRecipeBeanName(String value) => _newRecipeBeanName.value = value;

  /// Clear new recipe form
  void clearNewRecipeForm() {
    _newRecipeBeanName.value = '';
    _cupsCount.value = 1;
    _strength.value = 50;
    _customCoffeeAmount.value = null;
    _customWaterAmount.value = null;
  }

  /// Save new recipe
  void saveNewRecipe() {
    // TODO: Implement actual save logic with repository
    // For now, just log and clear
    if (_newRecipeBeanName.value.isNotEmpty) {
      // Save recipe with current settings
      Get.snackbar(
        '저장 완료',
        '${_newRecipeBeanName.value} 레시피가 저장되었습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
      clearNewRecipeForm();
    }
  }

  /// Navigate to add recipe page
  void goToAddRecipe() {
    clearNewRecipeForm();
    Get.toNamed(Routes.recipeAdd);
  }
}
