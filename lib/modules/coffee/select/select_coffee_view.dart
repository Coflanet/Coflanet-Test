import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/asset_constant.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/widgets/feedback/app_empty_state.dart';
import 'package:coflanet/widgets/navigation/app_bottom_bar.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Select Coffee Section (SC-01, SC-02)
/// 커피 원두/레시피 선택 화면 (보기 모드 / 편집 모드)
class SelectCoffeeView extends GetView<SelectCoffeeController> {
  const SelectCoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundNormalNormal,
      appBar: _buildAppBar(),
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
                    : _buildCoffeeList();
              }),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.backgroundNormalNormal,
      elevation: 0,
      leading: Obx(
        () => IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: controller.isEditing
                  ? AppColor.backgroundNormalAlternative
                  : AppColor.transparent,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AssetPath.iconArrowBack,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColor.labelNormal,
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
            color: AppColor.labelNormal,
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
                      color: AppColor.primaryNormal,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppColor.labelNormal,
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

  Widget _buildCoffeeList() {
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
            // Visible coffee items section
            if (visibleItems.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: isEditing
                      ? AppColor.backgroundNormalAlternative
                      : AppColor.transparent,
                  borderRadius: AppRadius.xlBorder,
                ),
                child: Column(
                  children: [
                    ...visibleItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _CoffeeCard(
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
                    // Add button at the bottom (only in editing mode)
                    if (isEditing)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 4),
                        child: GestureDetector(
                          onTap: controller.addNewCoffee,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColor.backgroundNormalNormal,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.lineNormalNeutral,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColor.labelAlternative,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ] else if (!isEditing) ...[
              // Show empty state for visible items
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    '표시할 커피가 없습니다',
                    style: AppTextStyles.body1NormalMedium.copyWith(
                      color: AppColor.labelAssistive,
                    ),
                  ),
                ),
              ),
            ],

            // Hidden beans section
            if (hiddenItems.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildHiddenBeansSection(hiddenItems, showHidden),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildHiddenBeansSection(
    List<CoffeeItem> hiddenItems,
    bool isExpanded,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalAlternative,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: controller.toggleHiddenBeansSection,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    color: AppColor.labelAssistive,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '숨겨진 원두 (${hiddenItems.length})',
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: AppColor.labelAlternative,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.labelAssistive,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Hidden items list
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: AppColor.lineNormalNeutral),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: hiddenItems
                        .map(
                          (item) => _HiddenCoffeeCard(
                            item: item,
                            onRestore: () => controller.unhideCoffee(item.id),
                            onDelete: () => controller.deleteCoffee(item.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // Restore all button
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: GestureDetector(
                    onTap: controller.restoreAllHiddenItems,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.lineNormalNeutral,
                          width: 1,
                        ),
                        borderRadius: AppRadius.mdBorder,
                      ),
                      child: Center(
                        child: Text(
                          '전체 복원',
                          style: AppTextStyles.body2NormalMedium.copyWith(
                            color: AppColor.labelAlternative,
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

  Widget _buildBottomBar() {
    return Obx(() {
      if (controller.isEditing) {
        return _buildEditingBottomBar();
      }
      return _buildNormalBottomBar();
    });
  }

  Widget _buildEditingBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalAlternative,
        boxShadow: AppShadows.shadowBlackHeavyBottom,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Share button
            GestureDetector(
              onTap: controller.selectedEditCount > 0
                  ? controller.shareSelectedItems
                  : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor.backgroundNormalNormal,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.ios_share,
                  color: controller.selectedEditCount > 0
                      ? AppColor.labelNormal
                      : AppColor.labelDisable,
                  size: 22,
                ),
              ),
            ),
            // Selection count
            Text(
              '${controller.selectedEditCount}개가 선택됨',
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
            // Delete button
            GestureDetector(
              onTap: controller.selectedEditCount > 0
                  ? controller.deleteSelectedItems
                  : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor.backgroundNormalNormal,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: controller.selectedEditCount > 0
                      ? AppColor.statusNegative
                      : AppColor.labelDisable,
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

/// Individual coffee card item
class _CoffeeCard extends StatelessWidget {
  final CoffeeItem item;
  final bool isEditing;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onHide;
  final VoidCallback? onDetail;
  final int index;
  final bool showHideOption;

  const _CoffeeCard({
    super.key,
    required this.item,
    required this.isEditing,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    this.onHide,
    this.onDetail,
    required this.index,
    this.showHideOption = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return _buildEditingCard(context);
    }
    return _buildNormalCard();
  }

  Widget _buildNormalCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryNormal.withOpacity(0.08)
                : AppColor.backgroundNormalNormal,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.lineNormalNeutral,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? AppShadows.shadowPrimaryNormalList : null,
          ),
          child: Row(
            children: [
              // Coffee image/icon
              _buildCoffeeIcon(),
              const SizedBox(width: 16),
              // Coffee info
              _buildCoffeeInfo(),
              // Detail button
              if (onDetail != null)
                GestureDetector(
                  onTap: onDetail,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColor.labelAssistive,
                      size: 24,
                    ),
                  ),
                ),
              // Selection indicator
              _buildSelectionIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditingCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.backgroundNormalNormal,
            borderRadius: AppRadius.lgBorder,
          ),
          child: Row(
            children: [
              // Checkbox
              _buildCheckbox(),
              const SizedBox(width: 12),
              // Coffee bag thumbnail
              _buildCoffeeThumbnail(),
              const SizedBox(width: 12),
              // Coffee info (compact)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '브랜드명',
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColor.labelAssistive,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.name,
                      style: AppTextStyles.body2NormalMedium.copyWith(
                        color: AppColor.labelNormal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Drag handle
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.drag_handle,
                    color: AppColor.labelAssistive,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
        border: Border.all(
          color: isSelected
              ? AppColor.primaryNormal
              : AppColor.interactionInactive,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16, color: AppColor.staticLabelWhiteStrong)
          : null,
    );
  }

  Widget _buildCoffeeThumbnail() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.backgroundNormalAlternative,
        borderRadius: AppRadius.mdBorder,
      ),
      child: Center(child: Icon(Icons.coffee, color: item.color, size: 24)),
    );
  }

  Widget _buildCoffeeIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [item.color.withOpacity(0.2), item.color.withOpacity(0.1)],
        ),
        borderRadius: AppRadius.lgBorder,
      ),
      child: Icon(Icons.coffee, color: item.color, size: 28),
    );
  }

  Widget _buildCoffeeInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: AppTextStyles.headline2Bold.copyWith(
              color: AppColor.labelNormal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: AppTextStyles.body2NormalRegular.copyWith(
              color: AppColor.labelAlternative,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
        border: Border.all(
          color: isSelected
              ? AppColor.primaryNormal
              : AppColor.interactionInactive,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16, color: AppColor.staticLabelWhiteStrong)
          : null,
    );
  }
}

/// Hidden coffee card with restore/delete options
class _HiddenCoffeeCard extends StatelessWidget {
  final CoffeeItem item;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _HiddenCoffeeCard({
    required this.item,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.backgroundNormalNormal.withOpacity(0.5),
          borderRadius: AppRadius.lgBorder,
        ),
        child: Row(
          children: [
            // Coffee thumbnail (faded)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.backgroundNormalAlternative,
                borderRadius: AppRadius.mdBorder,
              ),
              child: Center(
                child: Icon(
                  Icons.coffee,
                  color: item.color.withOpacity(0.5),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Coffee info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.brand != null)
                    Text(
                      item.brand!,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: AppColor.labelAssistive,
                      ),
                    ),
                  Text(
                    item.name,
                    style: AppTextStyles.body2NormalMedium.copyWith(
                      color: AppColor.labelAlternative,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Restore button
            GestureDetector(
              onTap: onRestore,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryNormal.withOpacity(0.1),
                  borderRadius: AppRadius.smBorder,
                ),
                child: Text(
                  '복원',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColor.primaryNormal,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                color: AppColor.labelAssistive,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
