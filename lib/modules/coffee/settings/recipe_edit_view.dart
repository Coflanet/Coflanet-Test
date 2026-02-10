import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';
import 'package:coflanet/widgets/modals/time_picker_modal.dart';

/// Recipe Edit Screen - Figma node 1163-55918
/// Violet header, editable sections for basic settings, detailed settings, and extraction steps
class RecipeEditView extends GetView<CoffeeController> {
  const RecipeEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.screenBg,
      body: Column(
        children: [
          _buildVioletHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildBasicSettingsSection(),
                  const SizedBox(height: 24),
                  _buildDetailedSettingsSection(),
                  const SizedBox(height: 24),
                  _buildExtractionStepsSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBottomSaveButton(),
        ],
      ),
    );
  }

  /// Violet header with X close, title, and save button
  /// Figma: violet bg (#6541F2), white text, X button left, 저장 button right
  Widget _buildVioletHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: _Colors.primary,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Close button
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close,
                  color: _Colors.textWhite,
                  size: 24,
                ),
              ),
            ),
            // Title - centered
            Expanded(
              child: Text(
                '레시피 편집',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: _Colors.textWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Save button
            GestureDetector(
              onTap: () {
                // Save and go back
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  '저장',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: _Colors.textWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Basic settings section - 기본 설정
  /// Contains: 레시피 이름, 원두 선택, 추출 방식
  Widget _buildBasicSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('기본 설정'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _Colors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildTextInputRow(
                label: '레시피 이름',
                value: '에티오피아 예가체프',
                onTap: () => _showTextInputModal('레시피 이름', '에티오피아 예가체프'),
              ),
              _buildDivider(),
              _buildTextInputRow(
                label: '원두 선택',
                value: '스타벅스 에티오피아 예가체프',
                onTap: () {
                  // Navigate to bean selection
                },
                showChevron: true,
              ),
              _buildDivider(),
              _buildTextInputRow(
                label: '추출 방식',
                value: controller.selectedType == CoffeeType.espresso
                    ? '에스프레소'
                    : '핸드드립',
                onTap: () {
                  // Show extraction method selection
                },
                showChevron: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Detailed settings section - 상세 설정
  /// Contains: 원두 양, 물 온도, 물 양, with toggles
  Widget _buildDetailedSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('상세 설정'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _Colors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Obx(
                () => _buildNumericInputRow(
                  label: '원두 양',
                  value: '${controller.coffeeAmount}',
                  unit: 'g',
                  onTap: _showCoffeeAmountModal,
                ),
              ),
              _buildDivider(),
              Obx(
                () => _buildNumericInputRow(
                  label: '물 온도',
                  value: '${controller.waterTemperature}',
                  unit: '°C',
                  onTap: _showWaterTemperatureModal,
                ),
              ),
              _buildDivider(),
              Obx(
                () => _buildNumericInputRow(
                  label: '물 양',
                  value: '${controller.waterAmount}',
                  unit: 'ml',
                  onTap: _showWaterAmountModal,
                ),
              ),
              _buildDivider(),
              Obx(
                () => _buildNumericInputRow(
                  label: '추출 시간',
                  value: controller.extractionTimeFormatted,
                  unit: '',
                  onTap: _showExtractionTimeModal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Extraction steps section - 추출 단계
  /// Contains: List of extraction steps with toggle and editing
  Widget _buildExtractionStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('추출 단계'),
            // Add step button
            GestureDetector(
              onTap: () {
                // Add new extraction step
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _Colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: _Colors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '단계 추가',
                      style: AppTextStyles.label1NormalMedium.copyWith(
                        color: _Colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Extraction step cards
        _buildExtractionStepCard(
          stepNumber: 1,
          title: '뜸 들이기',
          isEnabled: true,
          waterAmount: 30,
          duration: const Duration(seconds: 30),
        ),
        const SizedBox(height: 8),
        _buildExtractionStepCard(
          stepNumber: 2,
          title: '1차 추출',
          isEnabled: true,
          waterAmount: 100,
          duration: const Duration(seconds: 60),
        ),
        const SizedBox(height: 8),
        _buildExtractionStepCard(
          stepNumber: 3,
          title: '2차 추출',
          isEnabled: true,
          waterAmount: 70,
          duration: const Duration(seconds: 90),
        ),
      ],
    );
  }

  /// Extraction step card with toggle, water amount and time inputs
  Widget _buildExtractionStepCard({
    required int stepNumber,
    required String title,
    required bool isEnabled,
    required int waterAmount,
    required Duration duration,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: isEnabled ? null : Border.all(color: _Colors.border),
      ),
      child: Column(
        children: [
          // Header row with toggle
          Row(
            children: [
              // Step indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isEnabled ? _Colors.primary : _Colors.textSecondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _Colors.textWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: isEnabled
                        ? _Colors.textPrimary
                        : _Colors.textSecondary,
                  ),
                ),
              ),
              // Toggle switch
              _buildToggleSwitch(isEnabled),
            ],
          ),
          if (isEnabled) ...[
            const SizedBox(height: 16),
            // Input row
            Row(
              children: [
                Expanded(
                  child: _buildStepInputField(
                    label: '물 양',
                    value: '${waterAmount}ml',
                    onTap: () {
                      // Edit water amount for this step
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStepInputField(
                    label: '시간',
                    value: _formatDuration(duration),
                    onTap: () {
                      // Edit time for this step
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Step input field (smaller inline input)
  Widget _buildStepInputField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _Colors.inputBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.label2Regular.copyWith(
                color: _Colors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: _Colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle switch - iOS style
  Widget _buildToggleSwitch(bool isOn) {
    return GestureDetector(
      onTap: () {
        // Toggle the step
      },
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          color: isOn ? _Colors.primary : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: _Colors.textWhite,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom save button - full width violet
  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: _Colors.screenBg,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // Save and go back
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _Colors.primary,
              foregroundColor: _Colors.textWhite,
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
                color: _Colors.textWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== Helper Widgets =====

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.label1NormalMedium.copyWith(
        color: _Colors.textSecondary,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: _Colors.border,
    );
  }

  Widget _buildTextInputRow({
    required String label,
    required String value,
    required VoidCallback onTap,
    bool showChevron = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: _Colors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: _Colors.textPrimary,
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: _Colors.chevron, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNumericInputRow({
    required String label,
    required String value,
    required String unit,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: _Colors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '$value$unit',
              style: AppTextStyles.body2NormalMedium.copyWith(
                color: _Colors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: _Colors.chevron, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}분 ${seconds}초';
    }
    return '${seconds}초';
  }

  // ===== Modal Handlers =====

  Future<void> _showTextInputModal(String title, String currentValue) async {
    final result = await InputModal.show(
      title: '$title 입력',
      message: '$title을 입력하세요',
      hint: currentValue,
      initialValue: currentValue,
    );
    if (result != null) {
      // Update recipe name
    }
  }

  Future<void> _showCoffeeAmountModal() async {
    final result = await InputModal.show(
      title: '원두 양 설정',
      message: '원두량을 그램 단위로 입력하세요',
      hint: '예: 18',
      initialValue: controller.coffeeAmount.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '값을 입력하세요';
        final amount = int.tryParse(value);
        if (amount == null || amount < 5 || amount > 100) {
          return '5~100g 사이의 값을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.customCoffeeAmount = int.parse(result);
    }
  }

  Future<void> _showWaterTemperatureModal() async {
    final result = await InputModal.show(
      title: '물 온도 설정',
      message: '물 온도를 섭씨 단위로 입력하세요',
      hint: '예: 93',
      initialValue: controller.waterTemperature.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '값을 입력하세요';
        final temp = int.tryParse(value);
        if (temp == null || temp < 85 || temp > 100) {
          return '85~100°C 사이의 값을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.waterTemperature = int.parse(result);
    }
  }

  Future<void> _showWaterAmountModal() async {
    final result = await InputModal.show(
      title: '물 양 설정',
      message: '물 양을 ml 단위로 입력하세요',
      hint: '예: 210',
      initialValue: controller.waterAmount.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '값을 입력하세요';
        final amount = int.tryParse(value);
        if (amount == null || amount < 30 || amount > 1000) {
          return '30~1000ml 사이의 값을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.customWaterAmount = int.parse(result);
    }
  }

  Future<void> _showExtractionTimeModal() async {
    final initialDuration = Duration(seconds: controller.extractionTime);
    final result = await TimePickerModal.show(
      title: '추출 시간 설정',
      initialDuration: initialDuration,
      maxMinutes: 10,
      maxSeconds: 59,
    );
    if (result != null) {
      controller.extractionTime = result.inSeconds;
    }
  }
}

/// Figma-aligned colors for Recipe Edit screen - node 1163-55918
class _Colors {
  // Background
  static const Color screenBg = Color(0xFFF5F5F5); // Light gray
  static const Color cardBg = Color(0xFFFFFFFF); // White
  static const Color inputBg = Color(0xFFF8F8F8); // Input background

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A); // Near black
  static const Color textSecondary = Color(0xFF888888); // Gray
  static const Color textWhite = Color(0xFFFFFFFF);

  // Primary
  static const Color primary = Color(0xFF6541F2); // Violet

  // Misc
  static const Color chevron = Color(0xFFCCCCCC);
  static const Color border = Color(0xFFE5E5E5);
}
