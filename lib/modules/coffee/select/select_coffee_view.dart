import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/coffee/select/widgets/hidden_coffee_card.dart';
import 'package:coflanet/modules/coffee/select/widgets/select_coffee_card.dart';
import 'package:coflanet/widgets/feedback/app_empty_state.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Select Coffee Section (SC-01, SC-02)
/// 커피 원두/레시피 선택 화면 (보기 모드 / 편집 모드)
///
/// 카드 위젯(SelectCoffeeCard/HiddenCoffeeCard)은 widgets/ 로 분리.
/// AppBar(중앙정렬 — AppHeader 비대상)/숨김 섹션/하단 바의 Obx 경계는 View 잔류.
class SelectCoffeeView extends GetView<SelectCoffeeController> {
  const SelectCoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: _buildAppBar(colors),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return controller.visibleCoffeeItems.isEmpty &&
                        controller.hiddenCoffeeItems.isEmpty
                    ? _buildEmptyState()
                    : _buildCoffeeList(colors);
              }),
            ),
            _buildBottomBar(colors),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppColorScheme colors) {
    return AppBar(
      backgroundColor: colors.backgroundNormalNormal,
      elevation: 0,
      leading: Obx(
        () => IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: controller.isEditing
                  ? colors.backgroundNormalAlternative
                  : AppColor.transparent,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AssetPath.iconArrowBack,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                colors.labelNormal,
                BlendMode.srcIn,
              ),
            ),
          ),
          onPressed: () {
            if (controller.isEditing) {
              controller.toggleEditMode();
            } else {
              Get.back();
            }
          },
        ),
      ),
      title: Obx(
        () => Text(
          controller.isEditing ? '원두 목록 편집' : '커피 선택',
          style: AppTextStyles.headline1Bold.copyWith(
            color: colors.labelNormal,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => controller.isEditing
              ? TextButton(
                  onPressed: controller.toggleEditMode,
                  child: Text(
                    '완료',
                    style: AppTextStyles.headline2Bold.copyWith(
                      color: colors.primaryNormal,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: colors.labelNormal,
                    size: 22,
                  ),
                  onPressed: controller.toggleEditMode,
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return AppEmptyState(
      icon: Icons.coffee_outlined,
      title: '저장된 커피가 없어요',
      description: '자주 마시는 커피를 추가해보세요',
      actionLabel: '커피 추가하기',
      onAction: controller.addNewCoffee,
    );
  }

  Widget _buildCoffeeList(AppColorScheme colors) {
    return Obx(() {
      final visibleItems = controller.visibleCoffeeItems;
      final hiddenItems = controller.hiddenCoffeeItems;
      final isEditing = controller.isEditing;
      final showHidden = controller.showHiddenBeans;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 표시 중인 원두 섹션
            if (visibleItems.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: isEditing
                      ? colors.backgroundNormalAlternative
                      : AppColor.transparent,
                  borderRadius: AppRadius.xlBorder,
                ),
                child: Column(
                  children: [
                    ...visibleItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return SelectCoffeeCard(
                        key: ValueKey(item.id),
                        item: item,
                        isEditing: isEditing,
                        isSelected: isEditing
                            ? controller.isSelectedForEdit(item.id)
                            : controller.selectedId == item.id,
                        onTap: isEditing
                            ? () => controller.toggleEditSelection(item.id)
                            : () => controller.selectCoffee(item.id),
                        onDelete: () => controller.deleteCoffee(item.id),
                        onHide: () => controller.hideCoffee(item.id),
                        onDetail: isEditing
                            ? null
                            : () => Get.toNamed(
                                Routes.beanDetail,
                                arguments: {'bean': item},
                              ),
                        index: index,
                        showHideOption: isEditing,
                      );
                    }),
                    // 추가 버튼 (편집 모드만)
                    if (isEditing)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 4),
                        child: GestureDetector(
                          onTap: controller.addNewCoffee,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.backgroundNormalNormal,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.lineNormalNeutral,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: colors.labelAlternative,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ] else if (!isEditing) ...[
              // 표시할 원두 없음 안내
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    '표시할 커피가 없습니다',
                    style: AppTextStyles.body1NormalMedium.copyWith(
                      color: colors.labelAssistive,
                    ),
                  ),
                ),
              ),
            ],

            // 숨겨진 원두 섹션
            if (hiddenItems.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildHiddenBeansSection(colors, hiddenItems, showHidden),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildHiddenBeansSection(
    AppColorScheme colors,
    List<CoffeeItem> hiddenItems,
    bool isExpanded,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundNormalAlternative,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Column(
        children: [
          // 헤더
          GestureDetector(
            onTap: controller.toggleHiddenBeansSection,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    color: colors.labelAssistive,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '숨겨진 원두 (${hiddenItems.length})',
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: colors.labelAlternative,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colors.labelAssistive,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 숨김 항목 리스트
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: colors.lineNormalNeutral),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: hiddenItems
                        .map(
                          (item) => HiddenCoffeeCard(
                            item: item,
                            onRestore: () => controller.unhideCoffee(item.id),
                            onDelete: () => controller.deleteCoffee(item.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // 전체 복원 버튼
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: GestureDetector(
                    onTap: controller.restoreAllHiddenItems,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colors.lineNormalNeutral,
                          width: 1,
                        ),
                        borderRadius: AppRadius.mdBorder,
                      ),
                      child: Center(
                        child: Text(
                          '전체 복원',
                          style: AppTextStyles.body2NormalMedium.copyWith(
                            color: colors.labelAlternative,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AppColorScheme colors) {
    return Obx(() {
      if (controller.isEditing) {
        return _buildEditingBottomBar(colors);
      }
      return _buildNormalBottomBar();
    });
  }

  Widget _buildEditingBottomBar(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colors.backgroundNormalAlternative,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 공유 버튼
            GestureDetector(
              onTap: controller.selectedEditCount > 0
                  ? controller.shareSelectedItems
                  : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.backgroundNormalNormal,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.ios_share,
                  color: controller.selectedEditCount > 0
                      ? colors.labelNormal
                      : colors.labelDisable,
                  size: 22,
                ),
              ),
            ),
            // 선택 카운트
            Text(
              '${controller.selectedEditCount}개가 선택됨',
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: colors.labelNormal,
              ),
            ),
            // 삭제 버튼
            GestureDetector(
              onTap: controller.selectedEditCount > 0
                  ? controller.deleteSelectedItems
                  : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.backgroundNormalNormal,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: controller.selectedEditCount > 0
                      ? colors.statusNegative
                      : colors.labelDisable,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalBottomBar() {
    return AppBottomBar.primaryButton(
      text: '선택 완료',
      onPressed: controller.confirmSelection,
      isEnabled: controller.selectedId != null,
    );
  }
}
