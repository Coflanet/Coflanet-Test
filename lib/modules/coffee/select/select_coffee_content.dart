import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/modules/coffee/select/widgets/bean_add_button.dart';
import 'package:coflanet/modules/coffee/select/widgets/coffee_accordion_card.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Select Coffee Content (SC-01, SC-02) — Shell 탭 0 "원두"
/// 검은 배경 + 아코디언 원두 카드 (Figma)
///
/// 아코디언 카드/맛 게이지/추가 버튼은 widgets/ 로 분리.
/// Obx 경계(루트/편집 per-item/편집 바텀바)와 네비게이션·컨트롤러 등록 가드는
/// 이 View 에 잔류한다 (추출 위젯은 값/콜백만 받음).
/// 잔여 분량이 400줄 임계값 부근이지만, 남은 빌더는 전부 controller 직접
/// 호출(toggleEditSelection/addNewCoffee 등)과 per-item Obx 에 결합되어 있어
/// controller 미참조 위젯으로 추출할 수 없는 정당한 예외다.
class SelectCoffeeContent extends GetView<SelectCoffeeController> {
  const SelectCoffeeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // Scaffold/SafeArea 는 MainShellView 가 담당.
    // SizedBox.expand 로 가용 공간 전체 채움. 배경: Figma #F4F4F5
    return SizedBox.expand(
      child: Container(
        color: colors.backgroundNormalAlternative,
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.primaryNormal),
            );
          }

          return controller.coffeeItems.isEmpty
              ? _buildEmptyState(colors)
              : _buildCoffeeList(colors);
        }),
      ),
    );
  }

  /// 빈 상태 — Figma 'Home_Item_yes' 시안 기준
  /// 보라색 박스 카드 + 안내 텍스트 (좌) + 원두 일러스트 placeholder (우)
  /// 탭하면 원두 추가 화면으로 진입
  Widget _buildEmptyState(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.addNewCoffee,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: BoxDecoration(
                color: colors.primaryNormal, // Figma 보라 #6541F2
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  // 좌측 안내 텍스트 2줄
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '원두를 구독하시거나',
                          style: AppTextStyles.body1NormalBold.copyWith(
                            color: AppColor.colorGlobalCommon100,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '레시피를 등록해보세요',
                          style: AppTextStyles.body1NormalBold.copyWith(
                            color: AppColor.colorGlobalCommon100,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 우측 일러스트 자리 — 반투명 박스 + 이미지 아이콘
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColor.colorGlobalCommon100.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      size: 28,
                      color: AppColor.colorGlobalCommon100.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeList(AppColorScheme colors) {
    final items = controller.coffeeItems;
    final isEditing = controller.isEditing;

    return Column(
      children: [
        Expanded(
          child: isEditing
              ? _buildEditModeList(colors, items)
              : _buildNormalModeList(items),
        ),
        // 편집 모드 하단 액션 바
        if (isEditing) _buildEditingBottomBar(),
      ],
    );
  }

  /// 일반 모드 — 아코디언 카드 리스트
  Widget _buildNormalModeList(List<CoffeeItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _buildListAddButton(false);
        }
        final item = items[index];
        return CoffeeAccordionCard(
          item: item,
          isEditing: false,
          isSelected: false,
          initiallyExpanded: index == 0,
          onTap: null,
          onDetailPressed: () => _onDetailPressed(item),
          onRecipePressed: () => _onRecipePressed(item),
        );
      },
    );
  }

  /// 편집 모드 — 순서 변경 가능 리스트
  Widget _buildEditModeList(AppColorScheme colors, List<CoffeeItem> items) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            itemCount: items.length,
            onReorderItem: (oldIndex, newIndex) {
              controller.reorderItems(oldIndex, newIndex);
            },
            proxyDecorator: (child, index, animation) {
              return Material(
                elevation: 4,
                color: AppColor.transparent,
                borderRadius: BorderRadius.circular(20),
                child: child,
              );
            },
            itemBuilder: (context, index) {
              final item = items[index];

              // per-item Obx — ReorderableListView.builder 는 itemBuilder 를
              // 부모 Obx 범위 밖에서 lazy 호출하므로, 항목별 Obx 가 없으면
              // _selectedIdsForEdit 변경이 체크박스 UI 리빌드를 트리거하지 못한다.
              return Obx(key: ValueKey(item.id), () {
                final isSelected = controller.isSelectedForEdit(item.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 체크박스 (카드 밖 좌측)
                        GestureDetector(
                          onTap: () => controller.toggleEditSelection(item.id),
                          child: _buildEditCheckbox(colors, isSelected),
                        ),
                        const SizedBox(width: 12),
                        // 카드
                        Expanded(
                          child: _buildEditModeCard(colors, item, isSelected),
                        ),
                        const SizedBox(width: 12),
                        // 드래그 핸들
                        ReorderableDragStartListener(
                          index: index,
                          child: Icon(
                            Icons.drag_handle,
                            color: colors.labelNormal,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
        // 추가 버튼 (ReorderableListView 밖)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildListAddButton(true),
        ),
      ],
    );
  }

  /// 리스트 끝 추가 버튼 — 버튼 본체는 BeanAddButton 위젯
  Widget _buildListAddButton(bool isEditing) {
    return Padding(
      padding: EdgeInsets.only(
        top: isEditing ? 4 : 8, // Figma: 편집 모드는 더 좁은 간격
        bottom: isEditing ? 8 : 16,
      ),
      child: Center(
        child: BeanAddButton(
          isEditing: isEditing,
          onTap: controller.addNewCoffee,
        ),
      ),
    );
  }

  Future<void> _onDetailPressed(CoffeeItem item) async {
    final result = await Get.toNamed(
      Routes.beanDetail,
      arguments: {'bean': item},
    );
    if (result is CoffeeItem) {
      // 원두가 수정됨 — 목록 갱신
      controller.refreshList();
    }
  }

  Future<void> _onRecipePressed(CoffeeItem item) async {
    controller.selectCoffee(item.id);
    // CoffeeController 등록 보장 + 선택 원두 설정
    if (!Get.isRegistered<CoffeeController>()) {
      Get.put<CoffeeController>(CoffeeController(), permanent: true);
    }
    // 레시피 로드 완료 후 이동
    await Get.find<CoffeeController>().setSelectedBean(
      id: item.id,
      name: item.name,
    );
    Get.toNamed(Routes.coffeeSettings, arguments: {'coffeeId': item.id});
  }

  /// 편집 모드 카드 — Figma: List/Coffee List/Accordion
  /// Height 80, 흰 배경, radius 20, padding 16
  Widget _buildEditModeCard(
    AppColorScheme colors,
    CoffeeItem item,
    bool isSelected,
  ) {
    final displayImage = item.displayImageUrl;

    return GestureDetector(
      onTap: () => controller.toggleEditSelection(item.id),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceCard, // Figma: #FFFFFF (다크: coolNeutral15)
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: colors.primaryNormal, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColor.colorGlobalCommon0.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 썸네일 — Figma: 48x48, radius 12. 네이버 이미지 우선
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.componentFillStrong,
                borderRadius: BorderRadius.circular(12),
                image: displayImage != null
                    ? DecorationImage(
                        image: NetworkImage(displayImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: displayImage == null
                  ? Icon(Icons.coffee, color: item.color, size: 24)
                  : null,
            ),
            const SizedBox(width: 12), // Figma: gap 12px
            // 텍스트 — 브랜드 + 이름
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand ?? '브랜드명',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.labelAssistive,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Figma: gap 4px
                  Text(
                    item.name,
                    style: AppTextStyles.body2NormalBold.copyWith(
                      color: colors.labelNormal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 편집 모드 체크박스 — 카드 밖 좌측
  /// Figma: 24x24 외곽, 18x18 내부, border 1.5px, radius 5px
  Widget _buildEditCheckbox(AppColorScheme colors, bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(3), // Figma: 3px padding
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), // Figma: 5px radius
          color: isSelected ? colors.primaryNormal : AppColor.transparent,
          border: Border.all(
            // Figma: rgba(112,115,124,0.22) → 시맨틱 보더
            color: isSelected ? colors.primaryNormal : colors.lineNormalNormal,
            width: 1.5, // Figma: 1.5px border
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                size: 12,
                color: AppColor.colorGlobalCommon100,
              )
            : null,
      ),
    );
  }

  /// 편집 모드 하단 바 — Figma: Tab Bar Buttons
  /// 순흑 배경 + LiquidGlass 버튼 2개 + 선택 카운트
  Widget _buildEditingBottomBar() {
    return Obx(() {
      final hasSelection = controller.selectedEditCount > 0;

      // 고정 다크 액션 바(순흑 + LiquidGlass 버튼) — 의도된 디자인. 테마 무관.
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColor.colorGlobalCommon0, // 순흑 #000000
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 공유 버튼 — Figma: Button/Icon/LiquidGlass 44x44
                GestureDetector(
                  onTap: hasSelection ? controller.shareSelectedItems : null,
                  child: _buildLiquidGlassButton(
                    icon: Icons.ios_share,
                    size: 44,
                  ),
                ),
                // 선택 카운트 — 검은 바 위 고정 흰 텍스트
                Text(
                  '${controller.selectedEditCount}개가 선택됨',
                  style: AppTextStyles.body1NormalRegular.copyWith(
                    color: AppColor.staticLabelWhiteNormal,
                  ),
                ),
                // 삭제 버튼 — Figma: Button/Icon/LiquidGlass 44x44
                GestureDetector(
                  onTap: hasSelection ? controller.deleteSelectedItems : null,
                  child: _buildLiquidGlassButton(
                    icon: Icons.delete_outline,
                    size: 44,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Liquid Glass 버튼 — Figma: Button/Icon/LiquidGlass
  /// 그라데이션 fill + 글래스 오버레이
  Widget _buildLiquidGlassButton({
    required IconData icon,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6), // Figma: padding 6px
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Figma: Fill 레이어 — opacity 0.67 그라데이션
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.colorGlobalCommon100.withValues(alpha: 0.25 * 0.67),
            AppColor.colorGlobalCommon0.withValues(alpha: 0.6 * 0.67),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Figma: Glass Effect — rgba(0,0,0,0.2)
          color: AppColor.colorGlobalCommon0.withValues(alpha: 0.2),
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppColor.colorGlobalCoolNeutral99, // Figma: #F7F7F8
            size: 20, // Figma: 20px icon
          ),
        ),
      ),
    );
  }
}
