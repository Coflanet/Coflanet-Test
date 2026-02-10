import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';

/// Recipe Add Screen - Figma node 1163-55839
/// 새 레시피 추가 화면 - 원두 이름을 직접 입력할 수 있음
class RecipeAddView extends GetView<CoffeeController> {
  const RecipeAddView({super.key});

  // ===== Figma Color Constants (LIGHT Theme) =====
  static const Color _screenBg = Color(0xFFF5F5F5);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF171719); // Figma: #171719
  static const Color _textSecondary = Color(
    0x9C37383C,
  ); // Figma: rgba(55, 56, 60, 0.61)
  static const Color _textValue = Color(
    0xE02E2F33,
  ); // Figma: rgba(46, 47, 51, 0.88)
  static const Color _textMuted = Color(0xFF666666);
  static const Color _textPlaceholder = Color(0xFFAAAAAA);
  static const Color _border = Color(0xFFE0E0E0);
  static const Color _stepperBg = Color(
    0x1F70737C,
  ); // Figma: rgba(112, 115, 124, 0.12)
  static const Color _grayBg = Color(
    0x1F70737C,
  ); // Figma: rgba(112, 115, 124, 0.12)
  static const Color _divider = Color(
    0x2970737C,
  ); // Figma: rgba(112, 115, 124, 0.16)
  static const Color _primary = Color(0xFF6541F2);

  @override
  Widget build(BuildContext context) {
    // Initialize extraction steps if empty
    if (controller.extractionSteps.isEmpty) {
      controller.initializeDefaultSteps();
    }

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Calculate total bottom area needed: button height (56) + padding (32) + safe area
    final bottomAreaHeight = 56 + 32 + bottomPadding;

    return Scaffold(
      backgroundColor: _screenBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                // Scrollable content
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildBasicSettingsCard(),
                      const SizedBox(height: 16),
                      _buildDetailedSettingsCard(),
                      const SizedBox(height: 16),
                      _buildExtractionSettingsCard(),
                      const SizedBox(height: 20),
                      // + button separated outside the card per Figma
                      _buildAddStepButton(),
                      // Extra padding for bottom button area
                      SizedBox(height: bottomAreaHeight + 20),
                    ],
                  ),
                ),
                // Fixed bottom save button
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottomSaveButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Header - Light background with black text
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: _screenBg,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: _textPrimary,
                  size: 20,
                ),
              ),
            ),
            // Title - centered
            const Expanded(
              child: Text(
                '레시피 추가',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Spacer for symmetry
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  /// 기본 설정 section - Bean name (editable), then cups and intensity
  Widget _buildBasicSettingsCard() {
    return Column(
      children: [
        // 원두 이름 section - editable input for add mode
        _buildBeanNameInputRow(),
        const SizedBox(height: 16),
        // 잔수 and 진하기 section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 잔수 row
              _buildCupsRow(),
              const SizedBox(height: 24),
              // 진하기 정도 row
              _buildIntensityRow(),
            ],
          ),
        ),
      ],
    );
  }

  /// 원두 이름 section - 추가 모드에서는 직접 입력 가능
  Widget _buildBeanNameInputRow() {
    return GestureDetector(
      onTap: _showBeanNameModal,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label: 원두 이름
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '원두 이름',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.0057 * 16,
                  color: _textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Value: editable text with tap to edit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() {
                final beanName = controller.newRecipeBeanName;
                final hasName = beanName.isNotEmpty;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasName ? beanName : '원두 이름을 입력하세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          letterSpacing: 0.0057 * 16,
                          color: hasName ? _textPrimary : _textPlaceholder,
                        ),
                      ),
                    ),
                    Icon(Icons.edit_outlined, size: 20, color: _textSecondary),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Show bean name input modal
  Future<void> _showBeanNameModal() async {
    final result = await InputModal.show(
      title: '원두 이름',
      message: '레시피에 사용할 원두 이름을 입력하세요',
      hint: '예: 에티오피아 예가체프',
      initialValue: controller.newRecipeBeanName,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '원두 이름을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.newRecipeBeanName = result.trim();
    }
  }

  /// 잔수 row with chip buttons - 2x2 grid layout per Figma
  Widget _buildCupsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '잔수',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: [
              // First row: 1잔, 2잔
              Row(
                children: [
                  Expanded(child: _buildCupChip('1잔', 1)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip('2잔', 2)),
                ],
              ),
              const SizedBox(height: 8),
              // Second row: 3잔, 4잔
              Row(
                children: [
                  Expanded(child: _buildCupChip('3잔', 3)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip('4잔', 4)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Cup chip button - border style when selected, full-width pill shape
  Widget _buildCupChip(String label, int cups) {
    final isSelected = controller.cupsCount == cups;
    return GestureDetector(
      onTap: () => controller.cupsCount = cups,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? _primary : _border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? _primary : _textMuted,
          ),
        ),
      ),
    );
  }

  /// 진하기 정도 row with chip buttons - vertical full-width layout per Figma
  Widget _buildIntensityRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '진하기 정도',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: [
              _buildIntensityChip('가벼운 맛', 0),
              const SizedBox(height: 8),
              _buildIntensityChip('균형 잡힌 맛', 1),
              const SizedBox(height: 8),
              _buildIntensityChip('진한 맛', 2),
            ],
          ),
        ),
      ],
    );
  }

  /// Intensity chip button - full-width, filled style when selected
  Widget _buildIntensityChip(String label, int intensity) {
    // Map intensity levels: 0=light(<30), 1=balanced(30-60), 2=strong(>60)
    final currentStrength = controller.strength;
    final isSelected =
        (intensity == 0 && currentStrength < 30) ||
        (intensity == 1 && currentStrength >= 30 && currentStrength <= 60) ||
        (intensity == 2 && currentStrength > 60);

    return GestureDetector(
      onTap: () {
        if (intensity == 0) {
          controller.strength = 20;
        } else if (intensity == 1) {
          controller.strength = 50;
        } else {
          controller.strength = 80;
        }
      },
      child: Container(
        width: double.infinity,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? _primary : _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? _primary : _border, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  /// 상세 설정 Card
  Widget _buildDetailedSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text(
            '상세 설정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          // 추출 기기 row
          _buildDeviceRow(),
          const SizedBox(height: 20),
          // 원두 row
          Obx(
            () => _buildSettingRowWithStepper(
              label: '원두',
              value: controller.coffeeAmount,
              unit: 'g',
              onIncrement: () => controller.customCoffeeAmount =
                  (controller.coffeeAmount + 1).clamp(5, 50),
              onDecrement: () => controller.customCoffeeAmount =
                  (controller.coffeeAmount - 1).clamp(5, 50),
            ),
          ),
          const SizedBox(height: 20),
          // 물 온도 row
          Obx(
            () => _buildSettingRowWithStepper(
              label: '물 온도',
              value: controller.waterTemperature,
              unit: '°C',
              onIncrement: () =>
                  controller.waterTemperature = controller.waterTemperature + 1,
              onDecrement: () =>
                  controller.waterTemperature = controller.waterTemperature - 1,
            ),
          ),
          const SizedBox(height: 20),
          // 분쇄도 row
          _buildGrindSizeRow(),
        ],
      ),
    );
  }

  /// 추출 기기 row with change button
  Widget _buildDeviceRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '추출 기기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '핸드드립',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Show device selection modal
          },
          child: const Text(
            '변경하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _primary,
            ),
          ),
        ),
      ],
    );
  }

  /// Setting row with stepper control (no change button)
  Widget _buildSettingRowWithStepper({
    required String label,
    required int value,
    required String unit,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        // Label
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _textSecondary,
            ),
          ),
        ),
        // Stepper control
        _buildStepper(
          value: value,
          unit: unit,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }

  /// 분쇄도 row with stepper
  Widget _buildGrindSizeRow() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            '분쇄도',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _textSecondary,
            ),
          ),
        ),
        _buildStepper(
          value: 1000,
          unit: 'μm',
          onIncrement: () {},
          onDecrement: () {},
        ),
      ],
    );
  }

  /// Stepper control widget
  Widget _buildStepper({
    required int value,
    required String unit,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: _stepperBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(Icons.remove, size: 20, color: _textMuted),
            ),
          ),
          // Value display
          Container(
            constraints: const BoxConstraints(minWidth: 70),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '$value$unit',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ),
          ),
          // Plus button
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 20, color: _textMuted),
            ),
          ),
        ],
      ),
    );
  }

  /// Time stepper for duration values
  Widget _buildTimeStepper({
    required Duration duration,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final timeString = '$minutes:$seconds';

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: _stepperBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(Icons.remove, size: 20, color: _textMuted),
            ),
          ),
          // Value display
          Container(
            constraints: const BoxConstraints(minWidth: 70),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                timeString,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ),
          ),
          // Plus button
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 20, color: _textMuted),
            ),
          ),
        ],
      ),
    );
  }

  /// 추출 설정 Card with summary stats and extraction steps INSIDE
  Widget _buildExtractionSettingsCard() {
    return Obx(() {
      final steps = controller.extractionSteps;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            const Text(
              '추출 설정',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // Summary container - Figma: gray background, border-radius 32px
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: _grayBg,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  // 총 물의 양
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${controller.totalStepsWaterAmount}ml',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.445,
                            letterSpacing: -0.0002 * 18,
                            color: _textValue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '총 물의 양',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.0057 * 16,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vertical divider
                  Container(width: 1, height: 32, color: _divider),
                  // 총 추출 시간
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.totalStepsTimeFormatted,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.445,
                            letterSpacing: -0.0002 * 18,
                            color: _textValue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '총 추출 시간',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.0057 * 16,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Dynamic extraction steps
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Column(
                children: [
                  _buildExtractionStep(
                    step: step,
                    onWaterAmountChanged: (amount) =>
                        controller.updateStepWaterAmount(step.id, amount),
                    onDurationChanged: (duration) =>
                        controller.updateStepDuration(step.id, duration),
                    onDelete: () => controller.deleteExtractionStep(step.id),
                  ),
                  if (index < steps.length - 1) const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  /// Extraction step item (inside the white card)
  Widget _buildExtractionStep({
    required HandDripStep step,
    required Function(int) onWaterAmountChanged,
    required Function(Duration) onDurationChanged,
    required VoidCallback onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with title and delete button
        Row(
          children: [
            Expanded(
              child: Text(
                step.title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.delete_outline,
                size: 20,
                color: _textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 물의 양 row
        Row(
          children: [
            const Expanded(
              child: Text(
                '물의 양',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textSecondary,
                ),
              ),
            ),
            _buildStepper(
              value: step.waterAmount,
              unit: 'ml',
              onIncrement: () => onWaterAmountChanged(step.waterAmount + 10),
              onDecrement: () => onWaterAmountChanged(step.waterAmount - 10),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 시간 row with info tooltip
        Row(
          children: [
            Row(
              children: const [
                Text(
                  '시간',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _textSecondary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.info_outline, size: 16, color: _textSecondary),
              ],
            ),
            const Spacer(),
            _buildTimeStepper(
              duration: step.duration,
              onIncrement: () =>
                  onDurationChanged(step.duration + const Duration(seconds: 5)),
              onDecrement: () {
                if (step.duration.inSeconds > 5) {
                  onDurationChanged(step.duration - const Duration(seconds: 5));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Add step button - Figma: gray circular background with plus icon
  Widget _buildAddStepButton() {
    return GestureDetector(
      onTap: () => controller.addExtractionStep(),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: _grayBg, shape: BoxShape.circle),
          child: const Icon(Icons.add, size: 20, color: _textPrimary),
        ),
      ),
    );
  }

  /// Bottom save button
  Widget _buildBottomSaveButton(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      decoration: const BoxDecoration(color: _screenBg),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Validate and save
            if (controller.newRecipeBeanName.isEmpty) {
              Get.snackbar(
                '알림',
                '원두 이름을 입력해주세요',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade100,
              );
              return;
            }
            // Save and go back
            controller.saveNewRecipe();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '저장하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
