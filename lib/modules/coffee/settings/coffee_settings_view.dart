import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/settings/widgets/parameter_item.dart';
import 'package:coflanet/modules/coffee/settings/widgets/recipe_step_item.dart';
import 'package:coflanet/modules/coffee/settings/widgets/selection_pill.dart';
import 'package:coflanet/routes/app_pages.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';
import 'package:coflanet/widgets/modals/selection_modal.dart';
import 'package:coflanet/widgets/modals/time_picker_modal.dart';

/// 레시피 설정 화면 — 원두 프로필 / 추출 설정 / 진행 트래커 / 하단 CTA.
///
/// 표시용 위젯(SelectionPill/ParameterItem/RecipeStepItem)은 widgets/ 로 분리.
/// 파일이 400줄 임계값을 초과하지만, 잔여 코드는 모달 핸들러 7종
/// (controller 직접 쓰기)과 Obx 경계를 가진 섹션 빌더라
/// controller 미참조 위젯으로 추출할 수 없어 View 잔류가 정당한 예외다.
class CoffeeSettingsView extends GetView<CoffeeController> {
  const CoffeeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // 카드 안 콘텐츠용(활성 스킴) / 카드 밖 크롬용(캔버스=다크 스킴) 분리.
    final colors = AppColorScheme.of(context);
    final canvasColors = AppColorScheme.canvas;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // 검정 캔버스 → 상태바 아이콘 밝게.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // 캔버스: Figma POC 레시피 = Static/Black (라이트·다크 공통, 카드 밖 검정).
        backgroundColor: AppColor.staticBlack,
        body: Column(
          children: [
            _buildTopNavigation(context, canvasColors),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                // Figma: 카드는 풀폭(좌우 마진 0), 카드 사이 간격 4.
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.space16),
                    _buildProfileCard(colors),
                    const SizedBox(height: AppSpacing.cardGap),
                    _buildSettingsCard(colors),
                    const SizedBox(height: AppSpacing.cardGap),
                    _buildProgressTracker(colors),
                    const SizedBox(height: AppSpacing.space16),
                  ],
                ),
              ),
            ),
            _buildBottomCTA(canvasColors),
          ],
        ),
      ),
    );
  }

  /// Top Navigation — 테마 반응 (페이지 배경색 + 대비 fill 버튼)
  /// Figma: height 110px (54px status + 56px nav)
  Widget _buildTopNavigation(BuildContext context, AppColorScheme colors) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: statusBarHeight + 56,
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: AppSpacing.space16,
        right: AppSpacing.space16,
      ),
      // 캔버스(검정) 위 — 배경 투명, 크롬은 canvas(다크) 스킴.
      color: AppColor.transparent,
      child: Row(
        children: [
          // Back button - Figma: 40x40px, pill
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.componentFillStrong,
                borderRadius: AppRadius.fullBorder,
              ),
              child: Icon(
                Icons.chevron_left,
                color: colors.labelNormal,
                size: 24,
              ),
            ),
          ),
          // Centered title - Figma: Pretendard 17px/600 (Headline 2/Bold)
          Expanded(
            child: Text(
              '레시피',
              style: AppTextStyles.headline2Bold.copyWith(
                color: colors.labelStrong,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Edit button - Figma: Pretendard 16px/600, 대비 pill 배경
          GestureDetector(
            onTap: () => Get.toNamed(Routes.recipeEdit),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space16,
                vertical: AppSpacing.space8,
              ),
              decoration: BoxDecoration(
                color: colors.componentFillStrong,
                borderRadius: AppRadius.fullBorder,
              ),
              child: Text(
                '편집',
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: colors.labelNormal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile Card (Coffee Bean)
  /// Figma: 카드 surfaceCard, border-radius 40px, padding 16px, gap 12px, height 112px
  Widget _buildProfileCard(AppColorScheme colors) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Row(
        children: [
          // Thumbnail - Figma: 64x64px, border-radius 20px
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surfaceCardStrong,
              borderRadius: AppRadius.xxlBorder,
            ),
            child: Center(
              child: Icon(Icons.coffee, size: 32, color: colors.labelAssistive),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          // Bean info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand text - Figma: Label 1/Normal-Regular (14/400)
                Text(
                  '스페셜티 로스터스',
                  style: AppTextStyles.label1NormalRegular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
                const SizedBox(height: AppSpacing.space6),
                // Bean name - Figma: Headline 1/Bold (18/600)
                Obx(() {
                  final beanName = controller.selectedBeanName;
                  return Text(
                    beanName.isNotEmpty ? beanName : '에티오피아 예가체프',
                    style: AppTextStyles.headline1Bold.copyWith(
                      color: colors.labelNormal,
                    ),
                  );
                }),
              ],
            ),
          ),
          // Chevron
          Icon(Icons.chevron_right, color: colors.labelAlternative, size: 24),
        ],
      ),
    );
  }

  /// Settings Card (Background+Shadow)
  /// Figma: 카드 surfaceCard, border-radius 40px, padding 16px, gap 8px, height 324px
  Widget _buildSettingsCard(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.sectionRadiusBorder,
      ),
      child: Column(
        children: [
          _buildExtractionDeviceSection(colors),
          const SizedBox(height: AppSpacing.space8),
          _buildSelectionPillsRow(),
          const SizedBox(height: AppSpacing.space8),
          _buildParametersGrid(colors),
        ],
      ),
    );
  }

  /// Extraction Device Section (Contents)
  /// Figma: 옅은 회색 fill, border-radius 24px, padding 24px, gap 12px, height 104px
  Widget _buildExtractionDeviceSection(AppColorScheme colors) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(AppSpacing.space24),
      decoration: BoxDecoration(
        color: colors.componentFillNormal,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label - Figma: Body 1/Normal-Regular (16/400)
                Text(
                  '추출 기기',
                  style: AppTextStyles.body1NormalRegular.copyWith(
                    color: colors.labelAlternative,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                // Value - Figma: Body 1/Normal-Regular (16/400)
                Obx(
                  () => Text(
                    controller.selectedType == CoffeeType.espresso
                        ? '에스프레소'
                        : '핸드드립',
                    style: AppTextStyles.body1NormalRegular.copyWith(
                      color: colors.labelNormal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Change button - Figma: fill/alternative(0.08), pill, padding 7×10, 66×32
          GestureDetector(
            onTap: _showDeviceSelectionModal,
            child: Container(
              width: 66,
              height: 32,
              decoration: BoxDecoration(
                // Figma: rgba(112,115,124,0.08) → fill/alternative (박스보다 옅게)
                color: colors.componentFillAlternative,
                borderRadius: AppRadius.fullBorder,
              ),
              child: Center(
                // Button text - Figma: Label 2/Bold (13/600)
                child: Text(
                  '변경하기',
                  style: AppTextStyles.label2Bold.copyWith(
                    color: colors.labelAlternative,
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
      // mainText 평가(cupsCount read + strength 라벨 계산)는
      // 이 Obx 클로저 안에서 동기 실행되어야 반응성이 유지된다.
      return Row(
        children: [
          // Cups pill
          Expanded(
            child: SelectionPill(
              mainText: '${controller.cupsCount}잔',
              subText: '잔수',
              onTap: _showCupsSelectionModal,
            ),
          ),
          const SizedBox(width: AppSpacing.space4),
          // Strength pill
          Expanded(
            child: SelectionPill(
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
  /// Figma: fill/normal, border-radius 32px, padding px-8 py-24
  Widget _buildParametersGrid(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space8,
        vertical: AppSpacing.space24,
      ),
      decoration: BoxDecoration(
        color: colors.componentFillNormal,
        borderRadius: AppRadius.roundBorder,
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: ParameterItem(
                value: '${controller.coffeeAmount}g',
                label: '원두',
                onTap: _showCoffeeAmountModal,
              ),
            ),
            _buildVerticalDivider(colors),
            Expanded(
              child: ParameterItem(
                value: '${controller.waterTemperature}°C',
                label: '물 온도',
                onTap: _showWaterTemperatureModal,
              ),
            ),
            _buildVerticalDivider(colors),
            Expanded(
              child: ParameterItem(
                value: controller.extractionTimeFormatted,
                label: '추출 시간',
                onTap: _showExtractionTimeModal,
              ),
            ),
            _buildVerticalDivider(colors),
            Expanded(
              child: ParameterItem(
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
  /// Figma: width 1px, height 24px, line/normal/neutral (rgba(112,115,124,0.16))
  Widget _buildVerticalDivider(AppColorScheme colors) {
    return Container(width: 1, height: 24, color: colors.lineNormalNeutral);
  }

  /// Progress Tracker (Recipe Steps)
  /// Figma: 카드 surfaceCard, border-radius 40px, padding 32px 24px, gap 16px, height 324px
  Widget _buildProgressTracker(AppColorScheme colors) {
    return Obx(() {
      // Obx 반응성 트래킹을 위해 length 접근
      final steps = controller.extractionSteps;
      steps.length;

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
        final timeStr = minutes > 0 ? '$minutes분 $seconds초' : '$seconds초';
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space24,
          vertical: AppSpacing.space32,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: AppRadius.sectionRadiusBorder,
        ),
        child: Column(
          children: [
            for (int i = 0; i < displaySteps.length; i++)
              RecipeStepItem(
                step: displaySteps[i],
                isLast: i == displaySteps.length - 1,
              ),
          ],
        ),
      );
    });
  }

  /// Bottom CTA
  /// Figma: 보라 solid 버튼, border-radius 99px, width 328px, height 52px, padding 12px 28px
  Widget _buildBottomCTA(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space16,
        AppSpacing.space12,
        AppSpacing.space16,
        AppSpacing.space16,
      ),
      // 캔버스(검정) 위 — CTA 영역 배경도 Static/Black.
      color: AppColor.staticBlack,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(Routes.timerActive),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryNormal,
              foregroundColor: AppColor.staticLabelWhiteStrong,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.fullBorder),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space28,
                vertical: AppSpacing.space12,
              ),
            ),
            child: Text(
              '원두 레시피 시작',
              style: AppTextStyles.body1NormalBold.copyWith(
                color: AppColor.staticLabelWhiteStrong,
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
