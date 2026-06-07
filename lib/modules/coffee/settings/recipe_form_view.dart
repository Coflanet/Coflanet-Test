import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/settings/widgets/extraction_step_tile.dart';
import 'package:coflanet/modules/coffee/settings/widgets/selectable_chip.dart';
import 'package:coflanet/modules/coffee/settings/widgets/summary_box.dart';
import 'package:coflanet/modules/coffee/settings/widgets/value_stepper.dart';
import 'package:coflanet/widgets/typography/section_title.dart';

/// 원두 레시피 추가/편집 폼 (Figma: 원두 레시피 추가 / 원두 레시피 편집)
///
/// - add 모드: 레시피 이름 + 원두 이름 입력 (원두 목록 "직접 추가하기" 진입)
/// - edit 모드: 레시피 이름 카드 숨김, 원두 이름 읽기전용(선택된 원두)
///
/// 표시용 위젯(SelectableChip/ValueStepper/SummaryBox/ExtractionStepTile)은
/// widgets/ 로 분리. 파일이 400줄 임계값을 초과하지만, 잔여 코드는 Obx 경계가
/// 산재한 카드 빌더와 저장 플로우(controller 직접 쓰기)라 controller 미참조
/// 위젯으로 추출할 수 없어 View 잔류가 정당한 예외다.
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
                  if (!isEditMode) ...[
                    _buildRecipeNameCard(),
                    const SizedBox(height: 16),
                  ],
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

  // ===== 공통 위젯 =====

  /// 섹션 카드 (흰 배경, 둥근 모서리)
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalNormal,
        borderRadius: AppRadius.xxxlBorder,
      ),
      child: child,
    );
  }

  /// 섹션 제목 (기본 설정 / 상세 설정 / 추출 설정) — 공통 SectionTitle 재사용
  Widget _buildSectionTitle(String title) {
    return SectionTitle(
      title: title,
      titleStyle: AppTextStyles.headline1Bold.copyWith(
        color: AppColor.labelNormal,
      ),
    );
  }

  /// 필드 라벨 (원두 이름 / 잔수 / 진하기 정도 ...)
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.label1NormalRegular.copyWith(
        color: AppColor.labelAlternative,
      ),
    );
  }

  /// 헤더 - 뒤로가기 + 중앙 타이틀
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: AppColor.backgroundNormalAlternative,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.labelNormal,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: Text(
                isEditMode ? '원두 레시피 편집' : '원두 레시피 추가',
                style: AppTextStyles.headline1Bold.copyWith(
                  color: AppColor.labelNormal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }

  // ===== 레시피 이름 (add 모드 전용) =====

  Widget _buildRecipeNameCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "기본 설정"과 동일한 섹션 타이틀 스타일
          _buildSectionTitle('레시피 이름'),
          const SizedBox(height: 20),
          _buildTextField(
            initialValue: controller.recipeName,
            hint: '레시피 이름을 입력해주세요.',
            onChanged: (value) => controller.recipeName = value,
          ),
        ],
      ),
    );
  }

  // ===== 기본 설정 =====

  Widget _buildBasicSettingsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('기본 설정'),
          const SizedBox(height: 20),
          _buildBeanNameRow(),
          const SizedBox(height: 24),
          _buildCupsSection(),
          const SizedBox(height: 24),
          _buildIntensitySection(),
        ],
      ),
    );
  }

  /// 원두 이름 행 (add=입력 / edit=읽기전용)
  Widget _buildBeanNameRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('원두 이름'),
        const SizedBox(height: 8),
        if (isEditMode)
          Obx(() => _buildReadOnlyField(value: controller.selectedBeanName))
        else
          _buildTextField(
            initialValue: controller.newRecipeBeanName,
            hint: '원두 이름을 입력해주세요.',
            onChanged: (value) => controller.newRecipeBeanName = value,
          ),
      ],
    );
  }

  /// 인라인 텍스트 입력 필드 (Figma: 흰 배경 + 얇은 테두리, 포커스 시 보라 테두리)
  Widget _buildTextField({
    required String initialValue,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      maxLines: 1,
      style: AppTextStyles.body1NormalMedium.copyWith(
        color: AppColor.labelNormal,
      ),
      cursorColor: AppColor.primaryNormal,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body1NormalMedium.copyWith(
          color: AppColor.labelAssistive,
        ),
        isDense: true,
        filled: true,
        fillColor: AppColor.backgroundNormalNormal,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.fullBorder,
          borderSide: BorderSide(color: AppColor.lineNormalNormal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.fullBorder,
          borderSide: BorderSide(color: AppColor.primaryNormal, width: 1.5),
        ),
      ),
    );
  }

  /// 읽기전용 필드 (edit 모드 — 선택된 원두 이름 표시)
  Widget _buildReadOnlyField({required String value}) {
    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.fullBorder,
      ),
      child: Text(
        value.isNotEmpty ? value : '선택한 원두의 이름이 자동으로 들어갑니다',
        style: AppTextStyles.body1NormalMedium.copyWith(
          color: value.isNotEmpty
              ? AppColor.labelNormal
              : AppColor.labelAssistive,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 잔수 섹션 (1~6잔, 2x3 grid)
  Widget _buildCupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('잔수'),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildCupChip(1)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip(2)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip(3)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildCupChip(4)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip(5)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCupChip(6)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 잔수 칩 — isSelected 평가는 호출부 Obx 클로저 안에서 수행 (반응성 유지)
  Widget _buildCupChip(int cups) {
    return SelectableChip(
      label: '$cups잔',
      isSelected: controller.cupsCount == cups,
      height: 44,
      radius: AppRadius.lgPlus,
      onTap: () => controller.cupsCount = cups,
    );
  }

  /// 진하기 정도 섹션
  Widget _buildIntensitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('진하기 정도'),
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

  /// 진하기 칩 — strength 임계값(30/60) 평가는 호출부 Obx 클로저 안에서 수행
  Widget _buildIntensityChip(String label, int intensity) {
    final strength = controller.strength;
    final isSelected =
        (intensity == 0 && strength < 30) ||
        (intensity == 1 && strength >= 30 && strength <= 60) ||
        (intensity == 2 && strength > 60);

    return SelectableChip(
      label: label,
      isSelected: isSelected,
      height: 48,
      radius: AppRadius.xxxl,
      fullWidth: true,
      onTap: () {
        if (intensity == 0) {
          controller.strength = 20;
        } else if (intensity == 1) {
          controller.strength = 50;
        } else {
          controller.strength = 80;
        }
      },
    );
  }

  // ===== 상세 설정 =====

  Widget _buildDetailedSettingsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('상세 설정'),
          const SizedBox(height: 20),
          _buildDeviceRow(),
          const SizedBox(height: 20),
          Obx(
            () => _buildStepperRow(
              label: '원두',
              text: '${controller.coffeeAmount}g',
              onIncrement: () => controller.customCoffeeAmount =
                  (controller.coffeeAmount + 1).clamp(5, 50),
              onDecrement: () => controller.customCoffeeAmount =
                  (controller.coffeeAmount - 1).clamp(5, 50),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => _buildStepperRow(
              label: '물 온도',
              text: '${controller.waterTemperature}°C',
              onIncrement: () =>
                  controller.waterTemperature = controller.waterTemperature + 1,
              onDecrement: () =>
                  controller.waterTemperature = controller.waterTemperature - 1,
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => _buildStepperRow(
              label: '분쇄도',
              text: '${controller.grindSize}μm',
              onIncrement: () =>
                  controller.grindSize = controller.grindSize + 100,
              onDecrement: () =>
                  controller.grindSize = controller.grindSize - 100,
            ),
          ),
        ],
      ),
    );
  }

  /// 추출 기기 행
  Widget _buildDeviceRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('추출 기기'),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  controller.selectedType == CoffeeType.espresso
                      ? '에스프레소'
                      : '핸드드립',
                  style: AppTextStyles.body1NormalMedium.copyWith(
                    color: AppColor.labelNormal,
                  ),
                ),
              ),
            ],
          ),
        ),
        // [추출 기기 변경 모달 연동 예정]
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.componentFillNormal,
            borderRadius: AppRadius.fullBorder,
          ),
          child: Text(
            '변경하기',
            style: AppTextStyles.label2Medium.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ),
      ],
    );
  }

  /// 라벨 + 스테퍼 행 — text 평가는 호출부 Obx 클로저 안에서 수행
  Widget _buildStepperRow({
    required String label,
    required String text,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ),
        ValueStepper(
          text: text,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }

  // ===== 추출 설정 =====

  Widget _buildExtractionSettingsCard() {
    return Obx(() {
      final steps = controller.extractionSteps;

      return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('추출 설정'),
            const SizedBox(height: 20),
            _buildExtractionSummary(),
            const SizedBox(height: 20),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Column(
                children: [
                  ExtractionStepTile(
                    step: step,
                    onDelete: () => controller.deleteExtractionStep(step.id),
                    onWaterIncrement: () => controller.updateStepWaterAmount(
                      step.id,
                      step.waterAmount + 10,
                    ),
                    onWaterDecrement: () => controller.updateStepWaterAmount(
                      step.id,
                      step.waterAmount - 10,
                    ),
                    onDurationIncrement: () => controller.updateStepDuration(
                      step.id,
                      step.duration + const Duration(seconds: 5),
                    ),
                    // 최소 5초 가드 — 원본 동작 1:1 보존
                    onDurationDecrement: () {
                      if (step.duration.inSeconds > 5) {
                        controller.updateStepDuration(
                          step.id,
                          step.duration - const Duration(seconds: 5),
                        );
                      }
                    },
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

  /// 총 물의 양 / 총 추출시간 요약 — 값 평가는 부모 Obx 클로저 안에서 수행
  Widget _buildExtractionSummary() {
    return Row(
      children: [
        Expanded(
          child: SummaryBox(
            value: '${controller.totalStepsWaterAmount}ml',
            label: '총 물의 양',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SummaryBox(
            value: controller.totalStepsTimeFormatted,
            label: '총 추출시간',
          ),
        ),
      ],
    );
  }

  /// 스텝 추가 버튼
  Widget _buildAddStepButton() {
    return Center(
      child: GestureDetector(
        onTap: () => controller.addExtractionStep(),
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

  // ===== 하단 확인 버튼 =====

  Widget _buildBottomSaveButton(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      color: AppColor.backgroundNormalAlternative,
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
            foregroundColor: AppColor.staticLabelWhiteStrong,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.xlBorder),
          ),
          child: Text(
            '확인',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.staticLabelWhiteStrong,
            ),
          ),
        ),
      ),
    );
  }

  /// 편집 모드 저장
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

  /// 추가 모드 저장 — 새 원두 생성 + 레시피 저장 후 목록으로 반환
  Future<void> _saveNew() async {
    if (controller.recipeName.trim().isEmpty) {
      Get.snackbar(
        '알림',
        '레시피 이름을 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.colorGlobalRed95,
      );
      return;
    }

    final CoffeeItem? bean = await controller.saveNewRecipe();
    if (bean != null) {
      Get.back(result: bean);
      Get.snackbar(
        '저장 완료',
        '${bean.name} 레시피가 저장되었습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
