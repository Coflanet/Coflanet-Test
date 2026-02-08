import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';
import 'package:coflanet/widgets/modals/selection_modal.dart';
import 'package:coflanet/widgets/modals/time_picker_modal.dart';

/// Recipe step data model
class RecipeStep {
  final int number;
  final String title;
  final String description;

  const RecipeStep({
    required this.number,
    required this.title,
    required this.description,
  });
}

/// Dummy recipe steps data
const List<RecipeStep> _dummyRecipeSteps = [
  RecipeStep(number: 1, title: '원두 분쇄', description: '분쇄도: 800~1,000μm'),
  RecipeStep(number: 2, title: '예열', description: '서버와 드리퍼 예열'),
  RecipeStep(number: 3, title: '뜸 들이기', description: '물 30g 30초간 뜸'),
  RecipeStep(number: 4, title: '1차 추출', description: '100g 추출'),
  RecipeStep(number: 5, title: '2차 추출', description: '70g 마무리 추출'),
  RecipeStep(number: 6, title: '추출 완료', description: '드리퍼 제거하고 서버를 섞기'),
];

/// Figma-aligned colors for Recipe Settings screen
class _SettingsColors {
  // Background
  static const Color background = Color(0xFF000000);

  // Card backgrounds
  static const Color cardDark = Color(0xFF1C1C1E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F7);

  // Primary
  static Color get primary => AppColor.primaryNormal;
  static const Color primaryLight = Color(0xFFEDE9FE);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textDark = Color(0xFF000000);

  // Buttons
  static const Color buttonSecondary = Color(0xFF2C2C2E);
  static const Color buttonTertiary = Color(0xFFE5E5EA);
}

class CoffeeSettingsView extends GetView<CoffeeController> {
  const CoffeeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _SettingsColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildCoffeeBeanCard(),
                    const SizedBox(height: 16),
                    _buildBrewingSettingsCard(),
                    const SizedBox(height: 16),
                    _buildRecipeStepsCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  /// AppBar with circular back button, centered title, and edit pill button
  Widget _buildAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Back button - circular dark
          _CircularIconButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Get.back(),
          ),
          // Centered title
          Expanded(
            child: Text(
              '레시피',
              style: AppTextStyles.headline1Bold.copyWith(
                color: _SettingsColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Edit button - pill
          _PillButton(
            text: '편집',
            onTap: () {
              // TODO: Edit mode
            },
          ),
        ],
      ),
    );
  }

  /// Coffee bean info card - white background
  Widget _buildCoffeeBeanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _SettingsColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _SettingsColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.coffee,
                size: 32,
                color: _SettingsColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Bean info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '스타벅스',
                  style: AppTextStyles.label2Regular.copyWith(
                    color: _SettingsColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '에티오피아 예가체프',
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: _SettingsColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          // Chevron
          Icon(
            Icons.chevron_right,
            color: _SettingsColors.textSecondary,
            size: 24,
          ),
        ],
      ),
    );
  }

  /// Brewing settings card - dark background with sections
  Widget _buildBrewingSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _SettingsColors.cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Extraction device section
          _buildExtractionDeviceSection(),
          // Selection pills row
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSelectionPillsRow(),
          ),
          // Parameters grid
          _buildParametersGrid(),
        ],
      ),
    );
  }

  /// Extraction device section with light background
  Widget _buildExtractionDeviceSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _SettingsColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '추출 기기',
                  style: AppTextStyles.label2Regular.copyWith(
                    color: _SettingsColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.selectedType == CoffeeType.espresso
                        ? '에스프레소'
                        : '핸드드립',
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: _SettingsColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Change button
          GestureDetector(
            onTap: _showDeviceSelectionModal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _SettingsColors.buttonTertiary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '변경하기',
                style: AppTextStyles.label2Medium.copyWith(
                  color: _SettingsColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Selection pills row for cups and strength
  Widget _buildSelectionPillsRow() {
    return Row(
      children: [
        // Cups pill
        Expanded(
          child: Obx(
            () => _SelectionPill(
              label: '잔수',
              value: '${controller.cupsCount}잔',
              onTap: _showCupsSelectionModal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Strength pill
        Expanded(
          child: Obx(
            () => _SelectionPill(
              label: '진하기',
              value: _getStrengthDisplayLabel(),
              onTap: _showStrengthSelectionModal,
            ),
          ),
        ),
      ],
    );
  }

  String _getStrengthDisplayLabel() {
    if (controller.strength < 33) return '가벼운 맛';
    if (controller.strength < 66) return '보통';
    return '진한 맛';
  }

  /// Parameters grid with 4 items
  Widget _buildParametersGrid() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _SettingsColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _ParameterItem(
                label: '원두',
                value: '${controller.coffeeAmount}g',
                onTap: _showCoffeeAmountModal,
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _ParameterItem(
                label: '물 온도',
                value: '${controller.waterTemperature}°C',
                onTap: _showWaterTemperatureModal,
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _ParameterItem(
                label: '추출 시간',
                value: controller.extractionTimeFormatted,
                onTap: _showExtractionTimeModal,
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _ParameterItem(
                label: '물의 양',
                value: '${controller.waterAmount}ml',
                onTap: _showWaterAmountModal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: _SettingsColors.buttonTertiary,
    );
  }

  /// Recipe steps card - dark background
  Widget _buildRecipeStepsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _SettingsColors.cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '레시피 단계',
            style: AppTextStyles.headline1Bold.copyWith(
              color: _SettingsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ..._dummyRecipeSteps.map((step) => _RecipeStepItem(step: step)),
        ],
      ),
    );
  }

  /// Bottom CTA button
  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(Routes.timerActive),
          style: ElevatedButton.styleFrom(
            backgroundColor: _SettingsColors.primary,
            foregroundColor: _SettingsColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            '원두 레시피 시작',
            style: AppTextStyles.headline1Bold.copyWith(
              color: _SettingsColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  // ===== Modal Handlers =====

  void _showDeviceSelectionModal() async {
    final options = ['핸드드립', '에스프레소'];
    final currentIndex = controller.selectedType == CoffeeType.espresso ? 1 : 0;

    final result = await SelectionModal.show(
      title: '추출 기기 선택',
      options: options,
      selectedIndex: currentIndex,
    );

    if (result != null && result is int) {
      // Don't navigate, just update the type visually
      if (result == 0 && controller.selectedType != CoffeeType.handDrip) {
        controller.waterTemperature = 92;
        controller.extractionTime = 180;
      } else if (result == 1 &&
          controller.selectedType != CoffeeType.espresso) {
        controller.waterTemperature = 93;
        controller.extractionTime = 25;
      }
    }
  }

  void _showCupsSelectionModal() async {
    final options = List.generate(6, (i) => '${i + 1}잔');
    final result = await SelectionModal.show(
      title: '잔수 선택',
      options: options,
      selectedIndex: controller.cupsCount - 1,
    );

    if (result != null && result is int) {
      controller.cupsCount = result + 1;
    }
  }

  void _showStrengthSelectionModal() async {
    final options = ['가벼운 맛', '보통', '진한 맛'];
    int currentIndex;
    if (controller.strength < 33) {
      currentIndex = 0;
    } else if (controller.strength < 66) {
      currentIndex = 1;
    } else {
      currentIndex = 2;
    }

    final result = await SelectionModal.show(
      title: '진하기 선택',
      options: options,
      selectedIndex: currentIndex,
    );

    if (result != null && result is int) {
      switch (result) {
        case 0:
          controller.strength = 16;
          break;
        case 1:
          controller.strength = 50;
          break;
        case 2:
          controller.strength = 83;
          break;
      }
    }
  }

  Future<void> _showCoffeeAmountModal() async {
    final result = await InputModal.show(
      title: '원두량 설정',
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
}

/// Circular icon button for AppBar
class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: _SettingsColors.buttonSecondary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _SettingsColors.textPrimary, size: 18),
      ),
    );
  }
}

/// Pill button for AppBar
class _PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _SettingsColors.buttonSecondary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: AppTextStyles.label2Medium.copyWith(
            color: _SettingsColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Selection pill with violet background
class _SelectionPill extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SelectionPill({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _SettingsColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: _SettingsColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: _SettingsColors.primary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: _SettingsColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// Parameter item in grid
class _ParameterItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ParameterItem({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.caption1Regular.copyWith(
                color: _SettingsColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.body2NormalBold.copyWith(
                color: _SettingsColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Recipe step item with number badge
class _RecipeStepItem extends StatelessWidget {
  final RecipeStep step;

  const _RecipeStepItem({required this.step});

  @override
  Widget build(BuildContext context) {
    final isLast = step.number == 6;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _SettingsColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${step.number}',
                style: AppTextStyles.label2Bold.copyWith(
                  color: _SettingsColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Step content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.body2NormalMedium.copyWith(
                    color: _SettingsColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.description,
                  style: AppTextStyles.label1NormalRegular.copyWith(
                    color: _SettingsColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
