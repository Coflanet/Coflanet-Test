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

                return controller.coffeeItems.isEmpty
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
      final items = controller.coffeeItems;
      final isEditing = controller.isEditing;

      return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEditing
              ? AppColor.backgroundNormalAlternative
              : AppColor.transparent,
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          children: [
            Expanded(
              child: ReorderableListView.builder(
                padding: EdgeInsets.all(isEditing ? 12 : 4),
                itemCount: items.length,
                buildDefaultDragHandles: false,
                onReorder: controller.reorderItems,
                itemBuilder: (context, index) {
                  final item = items[index];
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
                    index: index,
                  );
                },
              ),
            ),
            // Add button at the bottom (only in editing mode)
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
      );
    });
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
  final int index;

  const _CoffeeCard({
    super.key,
    required this.item,
    required this.isEditing,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.index,
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
