import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Select Coffee Content (SC-01, SC-02) - For Shell Tab 0 "원두"
/// Black background with white/light text per Figma CSS
class SelectCoffeeContent extends GetView<SelectCoffeeController> {
  const SelectCoffeeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryNormal,
                  ),
                );
              }

              return controller.coffeeItems.isEmpty
                  ? _buildEmptyState()
                  : _buildCoffeeList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Edit button (title moved to AppBar)
            GestureDetector(
              onTap: controller.toggleEditMode,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.colorGlobalCoolNeutral20,
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Text(
                  controller.isEditing ? '완료' : '편집',
                  style: AppTextStyles.label1NormalMedium.copyWith(
                    color: controller.isEditing
                        ? AppColor.primaryNormal
                        : AppColor.colorGlobalCommon100,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.colorGlobalCoolNeutral20,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.coffee_outlined,
                size: 40,
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '저장된 원두가 없어요',
              style: AppTextStyles.title2Bold.copyWith(
                color: AppColor.colorGlobalCommon100,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '자주 마시는 원두를 추가해보세요',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral60,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: controller.addNewCoffee,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryNormal,
                  borderRadius: AppRadius.lgPlusBorder,
                ),
                child: Text(
                  '원두 추가하기',
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: AppColor.colorGlobalCommon100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeList() {
    return Obx(() {
      final items = controller.coffeeItems;
      final isEditing = controller.isEditing;

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount:
                  items.length + (isEditing ? 1 : 0), // +1 for add button
              itemBuilder: (context, index) {
                if (isEditing && index == items.length) {
                  return _buildAddButton();
                }
                final item = items[index];
                return _CoffeeCard(
                  item: item,
                  isEditing: isEditing,
                  isSelected: isEditing
                      ? controller.isSelectedForEdit(item.id)
                      : controller.selectedId == item.id,
                  onTap: isEditing
                      ? () => controller.toggleEditSelection(item.id)
                      : () => _onCoffeeTap(item),
                  index: index,
                );
              },
            ),
          ),
          // Bottom action bar in edit mode
          if (isEditing) _buildEditingBottomBar(),
        ],
      );
    });
  }

  void _onCoffeeTap(CoffeeItem item) {
    controller.selectCoffee(item.id);
    // Navigate to Recipe Setting
    Get.toNamed(Routes.coffeeSettings, arguments: {'coffeeId': item.id});
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: controller.addNewCoffee,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.colorGlobalCoolNeutral20,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(
              color: AppColor.colorGlobalCoolNeutral30,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: AppColor.colorGlobalCoolNeutral60,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                '원두 추가',
                style: AppTextStyles.headline2Bold.copyWith(
                  color: AppColor.colorGlobalCoolNeutral60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditingBottomBar() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCoolNeutral15,
          border: Border(
            top: BorderSide(
              color: AppColor.colorGlobalCoolNeutral25,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
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
                    color: AppColor.colorGlobalCoolNeutral20,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.ios_share,
                    color: controller.selectedEditCount > 0
                        ? AppColor.colorGlobalCommon100
                        : AppColor.colorGlobalCoolNeutral50,
                    size: 22,
                  ),
                ),
              ),
              // Selection count
              Text(
                '${controller.selectedEditCount}개 선택됨',
                style: AppTextStyles.body1NormalMedium.copyWith(
                  color: AppColor.colorGlobalCommon100,
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
                    color: AppColor.colorGlobalCoolNeutral20,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: controller.selectedEditCount > 0
                        ? AppColor.statusNegative
                        : AppColor.colorGlobalCoolNeutral50,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Coffee card for black background
class _CoffeeCard extends StatelessWidget {
  final CoffeeItem item;
  final bool isEditing;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _CoffeeCard({
    required this.item,
    required this.isEditing,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.primaryNormal.withOpacity(0.15)
                : AppColor.colorGlobalCoolNeutral15,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.colorGlobalCoolNeutral25,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Checkbox in edit mode
              if (isEditing) ...[_buildCheckbox(), const SizedBox(width: 12)],
              // Coffee icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withOpacity(0.3),
                      item.color.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: AppRadius.lgBorder,
                ),
                child: Icon(Icons.coffee, color: item.color, size: 28),
              ),
              const SizedBox(width: 16),
              // Coffee info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.headline2Bold.copyWith(
                        color: AppColor.colorGlobalCommon100,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: AppTextStyles.body2NormalRegular.copyWith(
                        color: AppColor.colorGlobalCoolNeutral60,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow indicator (non-edit mode)
              if (!isEditing)
                Icon(
                  Icons.chevron_right,
                  color: AppColor.colorGlobalCoolNeutral50,
                  size: 24,
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
              : AppColor.colorGlobalCoolNeutral50,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16, color: AppColor.colorGlobalCommon100)
          : null,
    );
  }
}
