import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/widgets/modals/input_modal.dart';

/// 원두 레시피 추가/편집 폼 (Figma: 원두 레시피 추가 / 원두 레시피 편집)
///
/// - add 모드: 레시피 이름 + 원두 이름 입력 (원두 목록 "직접 추가하기" 진입)
/// - edit 모드: 레시피 이름 카드 숨김, 원두 이름 읽기전용(선택된 원두)
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

  /// 섹션 제목 (기본 설정 / 상세 설정 / 추출 설정)
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headline1Bold.copyWith(color: AppColor.labelNormal),
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
          Obx(
            () => _buildInputField(
              value: controller.recipeName,
              placeholder: '레시피 이름을 입력해주세요.',
              onTap: _showRecipeNameModal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRecipeNameModal() async {
    final result = await InputModal.show(
      title: '레시피 이름',
      message: '레시피 이름을 입력해주세요.',
      hint: '예: 주말 아침 핸드드립',
      initialValue: controller.recipeName,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '레시피 이름을 입력하세요';
        }
        return null;
      },
    );
    if (result != null) {
      controller.recipeName = result.trim();
    }
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
          Obx(
            () => _buildInputField(
              value: controller.selectedBeanName,
              placeholder: '선택한 원두의 이름이 자동으로 들어갑니다',
              onTap: null,
            ),
          )
        else
          Obx(
            () => _buildInputField(
              value: controller.newRecipeBeanName,
              placeholder: '원두 이름을 입력해주세요.',
              onTap: _showBeanNameModal,
            ),
          ),
      ],
    );
  }

  Future<void> _showBeanNameModal() async {
    final result = await InputModal.show(
      title: '원두 이름',
      message: '레시피에 사용할 원두 이름을 입력하세요',
      hint: '예: 에티오피아 예가체프',
      initialValue: controller.newRecipeBeanName,
    );
    if (result != null) {
      controller.newRecipeBeanName = result.trim();
    }
  }

  /// 입력 필드 (탭하면 InputModal, onTap null이면 읽기전용)
  Widget _buildInputField({
    required String value,
    required String placeholder,
    required VoidCallback? onTap,
  }) {
    final hasValue = value.isNotEmpty;
    final field = Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasValue ? value : placeholder,
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: hasValue
                    ? AppColor.labelNormal
                    : AppColor.labelAssistive,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(Icons.edit_outlined, size: 18, color: AppColor.labelAlternative),
          ],
        ],
      ),
    );

    if (onTap == null) return field;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: field,
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

  Widget _buildCupChip(int cups) {
    return _buildSelectableChip(
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

  Widget _buildIntensityChip(String label, int intensity) {
    final strength = controller.strength;
    final isSelected =
        (intensity == 0 && strength < 30) ||
        (intensity == 1 && strength >= 30 && strength <= 60) ||
        (intensity == 2 && strength > 60);

    return _buildSelectableChip(
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

  /// 선택형 칩 공통 (회색 fill + 선택 시 보라 테두리·텍스트)
  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required double height,
    required double radius,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        width: fullWidth ? double.infinity : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2NormalMedium.copyWith(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.labelAlternative,
          ),
        ),
      ),
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

  /// 라벨 + 스테퍼 행
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
        _buildStepper(
          text: text,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }

  /// 스테퍼 컨트롤 (Figma: [+] 값 [−])
  Widget _buildStepper({
    required String text,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.mdBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepperButton(Icons.add, onIncrement),
          Container(
            height: 32,
            constraints: const BoxConstraints(minWidth: 64),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.backgroundNormalNormal,
              borderRadius: AppRadius.smBorder,
            ),
            child: Text(
              text,
              style: AppTextStyles.body2NormalBold.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
          _buildStepperButton(Icons.remove, onDecrement),
        ],
      ),
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32,
        height: 40,
        child: Icon(icon, size: 18, color: AppColor.labelAlternative),
      ),
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
                  _buildExtractionStep(step),
                  if (index < steps.length - 1) const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  /// 총 물의 양 / 총 추출시간 요약
  Widget _buildExtractionSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryBox(
            value: '${controller.totalStepsWaterAmount}ml',
            label: '총 물의 양',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryBox(
            value: controller.totalStepsTimeFormatted,
            label: '총 추출시간',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox({required String value, required String label}) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: AppRadius.xxlBorder,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.labelNeutral,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.label1NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
          ),
        ],
      ),
    );
  }

  /// 추출 스텝 항목 (타이틀 + 삭제 + 물의 양 + 시간)
  Widget _buildExtractionStep(HandDripStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                step.title,
                style: AppTextStyles.body1NormalBold.copyWith(
                  color: AppColor.labelNormal,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => controller.deleteExtractionStep(step.id),
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColor.labelAlternative,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 물의 양
        Row(
          children: [
            Expanded(
              child: Text(
                '물의 양',
                style: AppTextStyles.label1NormalRegular.copyWith(
                  color: AppColor.labelAlternative,
                ),
              ),
            ),
            _buildStepper(
              text: '${step.waterAmount}ml',
              onIncrement: () => controller.updateStepWaterAmount(
                step.id,
                step.waterAmount + 10,
              ),
              onDecrement: () => controller.updateStepWaterAmount(
                step.id,
                step.waterAmount - 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 시간
        Row(
          children: [
            Row(
              children: [
                Text(
                  '시간',
                  style: AppTextStyles.label1NormalRegular.copyWith(
                    color: AppColor.labelAlternative,
                  ),
                ),
                const SizedBox(width: 4),
                Tooltip(
                  message: '물을 붓는 시간과 기다리는 시간을 포함해요.',
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColor.labelAlternative,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildStepper(
              text: _formatDuration(step.duration),
              onIncrement: () => controller.updateStepDuration(
                step.id,
                step.duration + const Duration(seconds: 5),
              ),
              onDecrement: () {
                if (step.duration.inSeconds > 5) {
                  controller.updateStepDuration(
                    step.id,
                    step.duration - const Duration(seconds: 5),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
