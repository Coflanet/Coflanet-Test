import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
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

class CoffeeSettingsView extends GetView<CoffeeController> {
  const CoffeeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorGlobalCommon0, // Figma: #000000 (BLACK)
      body: Column(
        children: [
          _buildTopNavigation(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileCard(),
                  const SizedBox(height: 12),
                  _buildSettingsCard(),
                  const SizedBox(height: 12),
                  _buildProgressTracker(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  /// Top Navigation - Dark with glass effect
  /// Figma: height 110px (54px status + 56px nav), background #000000
  Widget _buildTopNavigation(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: statusBarHeight + 56,
      padding: EdgeInsets.only(top: statusBarHeight, left: 16, right: 16),
      color: AppColor.colorGlobalCommon0,
      child: Row(
        children: [
          // Back button - Figma: 40x40px, rgba(77,77,77,0.6), border-radius 99px
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.componentFillScroll,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          // Centered title - Figma: Pretendard 17px/600, color #FFFFFF
          const Expanded(
            child: Text(
              '레시피',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColor.colorGlobalCommon100,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Edit button - Figma: Pretendard 16px/600, color #F7F7F8, glass background
          GestureDetector(
            onTap: () => Get.toNamed(Routes.recipeEdit),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.componentFillScroll,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text(
                '편집',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.colorGlobalCoolNeutral99,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile Card (Coffee Bean)
  /// Figma: background #FFFFFF, border-radius 40px, padding 16px, gap 12px, height 112px
  Widget _buildProfileCard() {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          // Thumbnail - Figma: 64x64px, border-radius 20px
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColor.colorGlobalCoolNeutral98,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.coffee,
                size: 32,
                color: AppColor.colorGlobalNeutral60,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Bean info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand text - Figma: Pretendard 14px/400, color rgba(55,56,60,0.61)
                Text(
                  '스페셜티 로스터스',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(height: 4),
                // Bean name - Figma: Pretendard 18px/600, color #171719
                Obx(() {
                  final beanName = controller.selectedBeanName;
                  return Text(
                    beanName.isNotEmpty ? beanName : '에티오피아 예가체프',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.labelNormal,
                    ),
                  );
                }),
              ],
            ),
          ),
          // Chevron
          Icon(Icons.chevron_right, color: AppColor.labelAlternative, size: 24),
        ],
      ),
    );
  }

  /// Settings Card (Background+Shadow)
  /// Figma: background #FFFFFF, border-radius 40px, padding 16px, gap 8px, height 324px
  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCommon100,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          _buildExtractionDeviceSection(),
          const SizedBox(height: 8),
          _buildSelectionPillsRow(),
          const SizedBox(height: 8),
          _buildParametersGrid(),
        ],
      ),
    );
  }

  /// Extraction Device Section (Contents)
  /// Figma: background rgba(112,115,124,0.12), border-radius 24px, padding 24px, gap 12px, height 104px
  Widget _buildExtractionDeviceSection() {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral50.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label - Figma: Pretendard 16px/400, color rgba(55,56,60,0.61)
                Text(
                  '추출 기기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(height: 4),
                // Value - Figma: Pretendard 16px/400, color #171719
                Obx(
                  () => Text(
                    controller.selectedType == CoffeeType.espresso
                        ? '에스프레소'
                        : '핸드드립',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.labelNormal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Change button - Figma: background rgba(112,115,124,0.08), border-radius 99px, padding 7px 10px, width 66px, height 32px
          GestureDetector(
            onTap: _showDeviceSelectionModal,
            child: Container(
              width: 66,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColor.componentFillNormal,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Center(
                // Button text - Figma: Pretendard 13px/600, color rgba(55,56,60,0.61)
                child: Text(
                  '변경하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.labelAlternative,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Selection Pills Row (Cups/Strength)
  /// Figma: gap 4px, height 80px
  Widget _buildSelectionPillsRow() {
    return Obx(() {
      return Row(
        children: [
          // Cups pill
          Expanded(
            child: _SelectionPill(
              mainText: '${controller.cupsCount}잔',
              subText: '잔수',
              onTap: _showCupsSelectionModal,
            ),
          ),
          const SizedBox(width: 4),
          // Strength pill
          Expanded(
            child: _SelectionPill(
              mainText: _getStrengthDisplayLabel(),
              subText: '진하기 정도',
              onTap: _showStrengthSelectionModal,
            ),
          ),
        ],
      );
    });
  }

  String _getStrengthDisplayLabel() {
    if (controller.strength < 33) return '가벼운 맛';
    if (controller.strength < 66) return '보통';
    return '진한 맛';
  }

  /// Parameters Grid
  /// Figma: background rgba(112,115,124,0.12), border-radius 32px, padding 24px 8px, height 92px
  Widget _buildParametersGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.colorGlobalCoolNeutral50.withOpacity(0.12),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _ParameterItem(
                value: '${controller.coffeeAmount}g',
                label: '원두',
                onTap: _showCoffeeAmountModal,
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _ParameterItem(
                value: '${controller.waterTemperature}°C',
                label: '물 온도',
                onTap: _showWaterTemperatureModal,
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _ParameterItem(
                value: controller.extractionTimeFormatted,
                label: '추출 시간',
                onTap: _showExtractionTimeModal,
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _ParameterItem(
                value: '${controller.waterAmount}ml',
                label: '물의 양',
                onTap: _showWaterAmountModal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vertical Divider between parameter columns
  /// Figma: width 1px, height 24px, color rgba(112,115,124,0.16)
  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 24, color: AppColor.componentFillStrong);
  }

  /// Progress Tracker (Recipe Steps)
  /// Figma: background #FFFFFF, border-radius 40px, padding 32px 24px, gap 16px, height 324px
  Widget _buildProgressTracker() {
    return Obx(() {
      // Force Obx to track list changes by accessing length
      final steps = controller.extractionSteps;
      final stepCount = steps.length;

      // Always build from controller state - don't fall back to dummy data
      List<RecipeStep> displaySteps = [];

      // Add preparation steps (always shown)
      displaySteps.add(
        const RecipeStep(
          number: 1,
          title: '원두 분쇄',
          description: '분쇄도: 800~1,000μm',
        ),
      );
      displaySteps.add(
        const RecipeStep(number: 2, title: '예열', description: '서버와 드리퍼 예열'),
      );

      // Add extraction steps from controller (if any)
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i];
        final minutes = step.duration.inMinutes;
        final seconds = step.duration.inSeconds % 60;
        final timeStr = minutes > 0 ? '${minutes}분 ${seconds}초' : '${seconds}초';
        displaySteps.add(
          RecipeStep(
            number: i + 3,
            title: step.title,
            description: '물 ${step.waterAmount}g $timeStr',
          ),
        );
      }

      // Add final step (always shown)
      displaySteps.add(
        RecipeStep(
          number: displaySteps.length + 1,
          title: '추출 완료',
          description: '드리퍼 제거하고 서버를 섞기',
        ),
      );

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          children: [
            for (int i = 0; i < displaySteps.length; i++)
              _RecipeStepItem(
                step: displaySteps[i],
                isLast: i == displaySteps.length - 1,
              ),
          ],
        ),
      );
    });
  }

  /// Bottom CTA
  /// Figma: background #6541F2, border-radius 99px, width 328px, height 52px, padding 12px 28px
  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: AppColor.colorGlobalCommon0,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(Routes.timerActive),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryNormal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text(
              '원두 레시피 시작',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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

/// Selection Pill
/// Figma: background #F0ECFE, border 1px solid #C0B0FF, border-radius 24px, width 162px, height 80px, padding 16px, gap 2px
class _SelectionPill extends StatelessWidget {
  final String mainText;
  final String subText;
  final VoidCallback onTap;

  const _SelectionPill({
    required this.mainText,
    required this.subText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalViolet95,
          border: Border.all(color: AppColor.colorGlobalViolet80, width: 1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main text - Figma: Pretendard 18px/600, color #5B35F2
            Text(
              mainText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryStrong,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            // Sub text - Figma: Pretendard 14px/400, color rgba(55,56,60,0.61)
            Text(
              subText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Parameter Item
/// Value: Figma: Pretendard 15px/500, color rgba(46,47,51,0.88)
/// Label: Figma: Pretendard 14px/400, color rgba(55,56,60,0.61)
class _ParameterItem extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback onTap;

  const _ParameterItem({
    required this.value,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Value - Figma: Pretendard 15px/500, color rgba(46,47,51,0.88)
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColor.labelNeutral,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Label - Figma: Pretendard 14px/400, color rgba(55,56,60,0.61)
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.labelAlternative,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Recipe Step Item with numbered badge (vertical stepper)
/// Badge: 20x20px circle, background #E1E2E4, border-radius 1000px
/// Badge number: Pretendard 12px/600, color #FFFFFF
/// Vertical divider line: 1px width, 28px height, background #E1E2E4
/// Step title: Pretendard 16px/500, color rgba(55,56,60,0.61), width 100px
/// Step description: Pretendard 14px/400, color rgba(55,56,60,0.35), aligned right
class _RecipeStepItem extends StatelessWidget {
  final RecipeStep step;
  final bool isLast;

  const _RecipeStepItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: badge + vertical line
        Column(
          children: [
            // Badge - Figma: 20x20px, background #E1E2E4, border-radius 1000px
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColor.colorGlobalCoolNeutral96,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Center(
                // Badge number - Figma: Pretendard 12px/600, color #FFFFFF
                child: Text(
                  '${step.number}',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.colorGlobalCommon100,
                  ),
                ),
              ),
            ),
            // Vertical divider line - Figma: 1px width, 28px height, background #E1E2E4
            if (!isLast)
              Container(
                width: 1,
                height: 28,
                color: AppColor.colorGlobalCoolNeutral96,
              ),
          ],
        ),
        const SizedBox(width: 12),
        // Step title - Figma: Pretendard 16px/500, color rgba(55,56,60,0.61), width 100px
        SizedBox(
          width: 100,
          child: Text(
            step.title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.labelAlternative,
            ),
          ),
        ),
        const Spacer(),
        // Step description - Figma: Pretendard 14px/400, color rgba(55,56,60,0.35), aligned right
        Text(
          step.description,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.labelAssistive,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
