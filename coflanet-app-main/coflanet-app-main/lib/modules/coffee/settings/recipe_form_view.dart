import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';

/// Unified Recipe Form Screen - handles both edit and add modes
/// Edit mode: Figma node 1163-55918 (원두 이름 읽기전용)
/// Add mode: Figma node 1163-55839 (원두 이름 입력 가능)
class RecipeFormView extends GetView<CoffeeController> {
  final bool isEditMode;

  const RecipeFormView({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalAlternative,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                  _buildAddStepButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomSaveButton(context),
        ],
      ),
    );
  }

  /// Header with back button and centered title
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: AppColor.backgroundNormalAlternative,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.labelNormal,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: Text(
                isEditMode ? '레시피 편집' : '레시피 추가',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.labelNormal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  /// 기본 설정 section - Bean name + cups + intensity
  Widget _buildBasicSettingsCard() {
    return Column(
      children: [
        isEditMode ? _buildBeanNameDisplay() : _buildBeanNameInput(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCupsRow(),
              const SizedBox(height: 24),
              _buildIntensityRow(),
            ],
          ),
        ),
      ],
    );
  }

  /// 원두 이름 - 편집 모드 (읽기전용)
  Widget _buildBeanNameDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                color: AppColor.labelAlternative,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(() {
              final beanName = controller.selectedBeanName;
              return Text(
                beanName.isNotEmpty ? beanName : '원두를 선택해주세요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0.0057 * 16,
                  color: beanName.isNotEmpty
                      ? AppColor.labelNormal
                      : AppColor.labelAlternative,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 원두 이름 - 추가 모드 (편집 가능)
  Widget _buildBeanNameInput() {
    return GestureDetector(
      onTap: _showBeanNameModal,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  color: AppColor.labelAlternative,
                ),
              ),
            ),
            const SizedBox(height: 8),
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
                          color: hasName
                              ? AppColor.labelNormal
                              : AppColor.labelAssistive,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppColor.labelAlternative,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Bean name input modal (add mode only)
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

  /// 잔수 row - 2x2 grid layout
  Widget _buildCupsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '잔수',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColor.labelAlternative,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildCupChip('1잔', 1)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip('2잔', 2)),
                ],
              ),
              const SizedBox(height: 8),
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

  /// Cup chip button - pill shape with border highlight
  Widget _buildCupChip(String label, int cups) {
    final isSelected = controller.cupsCount == cups;
    return GestureDetector(
      onTap: () => controller.cupsCount = cups,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.lineSolidNormal,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.colorGlobalCoolNeutral40,
          ),
        ),
      ),
    );
  }

  /// 진하기 정도 row
  Widget _buildIntensityRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '진하기 정도',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColor.labelAlternative,
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

  /// Intensity chip - filled when selected
  Widget _buildIntensityChip(String label, int intensity) {
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
          color: isSelected
              ? AppColor.primaryNormal
              : AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.lineSolidNormal,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColor.colorGlobalCoolNeutral40,
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
        color: AppColor.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상세 설정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 24),
          _buildDeviceRow(),
          const SizedBox(height: 20),
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
          _buildGrindSizeRow(),
        ],
      ),
    );
  }

  /// 추출 기기 row
  Widget _buildDeviceRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '추출 기기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.labelAlternative,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '핸드드립',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.labelNormal,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // 추출 기구 선택 모달 (추후 구현)
          },
          child: Text(
            '변경하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.primaryNormal,
            ),
          ),
        ),
      ],
    );
  }

  /// Setting row with stepper
  Widget _buildSettingRowWithStepper({
    required String label,
    required int value,
    required String unit,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.labelAlternative,
            ),
          ),
        ),
        _buildStepper(
          value: value,
          unit: unit,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }

  /// 분쇄도 row
  Widget _buildGrindSizeRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '분쇄도',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.labelAlternative,
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
        color: AppColor.componentFillNormal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: 20,
                color: AppColor.colorGlobalCoolNeutral40,
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 70),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '$value$unit',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.labelNormal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: 20,
                color: AppColor.colorGlobalCoolNeutral40,
              ),
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
        color: AppColor.componentFillNormal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: 20,
                color: AppColor.colorGlobalCoolNeutral40,
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 70),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                timeString,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.labelNormal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: 20,
                color: AppColor.colorGlobalCoolNeutral40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 추출 설정 Card with summary and extraction steps
  Widget _buildExtractionSettingsCard() {
    return Obx(() {
      final steps = controller.extractionSteps;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '추출 설정',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.labelNormal,
              ),
            ),
            const SizedBox(height: 20),
            // Summary container
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.componentFillNormal,
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
                            color: AppColor.labelNeutral,
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
                            color: AppColor.labelAlternative,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColor.lineNormalNeutral,
                  ),
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
                            color: AppColor.labelNeutral,
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
                            color: AppColor.labelAlternative,
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

  /// Extraction step item
  Widget _buildExtractionStep({
    required HandDripStep step,
    required Function(int) onWaterAmountChanged,
    required Function(Duration) onDurationChanged,
    required VoidCallback onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                step.title,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.labelNormal,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColor.labelAlternative,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 물의 양 row
        Row(
          children: [
            Expanded(
              child: Text(
                '물의 양',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.labelAlternative,
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
        // 시간 row
        Row(
          children: [
            Row(
              children: [
                Text(
                  '시간',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColor.labelAlternative,
                ),
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

  /// Add step button
  Widget _buildAddStepButton() {
    return GestureDetector(
      onTap: () => controller.addExtractionStep(),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColor.componentFillNormal,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, size: 20, color: AppColor.labelNormal),
        ),
      ),
    );
  }

  /// Bottom save button
  Widget _buildBottomSaveButton(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      decoration: BoxDecoration(color: AppColor.backgroundNormalAlternative),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            if (isEditMode) {
              await _saveExisting();
            } else {
              await _saveNew();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryNormal,
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

  /// Save existing recipe (edit mode)
  Future<void> _saveExisting() async {
    final success = await controller.saveCurrentRecipe();
    if (success) {
      Get.back();
      Get.snackbar(
        '저장 완료',
        '${controller.selectedBeanName} 레시피가 저장되었습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Save new recipe (add mode)
  Future<void> _saveNew() async {
    if (controller.newRecipeBeanName.isEmpty) {
      Get.snackbar(
        '알림',
        '원두 이름을 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return;
    }
    final success = await controller.saveNewRecipe();
    if (success) {
      Get.back();
      Get.snackbar(
        '저장 완료',
        '${controller.newRecipeBeanName} 레시피가 저장되었습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
