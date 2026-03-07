import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/data/models/coffee_item_model.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/modules/coffee/select/select_coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Select Coffee Content (SC-01, SC-02) - For Shell Tab 0 "원두"
/// Black background with accordion-style coffee cards per Figma design
class SelectCoffeeContent extends GetView<SelectCoffeeController> {
  const SelectCoffeeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // No Scaffold - MainShellView provides the scaffold
    // No SafeArea - MainShellView handles safe areas
    // SizedBox.expand ensures Container fills all available space
    // Background color: Figma #F4F4F5
    return SizedBox.expand(
      child: Container(
        color: AppColor.colorGlobalCoolNeutral98, // Figma: #F4F4F5
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primaryNormal),
            );
          }

          return controller.coffeeItems.isEmpty
              ? _buildEmptyState()
              : _buildCoffeeList();
        }),
      ),
    );
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
                color: AppColor
                    .colorGlobalCoolNeutral95, // Light gray for light bg
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.coffee_outlined,
                size: 40,
                color: AppColor.colorGlobalCoolNeutral50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '저장된 원두가 없어요',
              style: AppTextStyles.title2Bold.copyWith(
                color: AppColor.colorGlobalCommon0, // Black text for light bg
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '자주 마시는 원두를 추가해보세요',
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: AppColor.colorGlobalCoolNeutral50,
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
                    color:
                        AppColor.colorGlobalCommon100, // White text on purple
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
    final items = controller.coffeeItems;
    final isEditing = controller.isEditing;

    return Column(
      children: [
        Expanded(
          child: isEditing
              ? _buildEditModeList(items)
              : _buildNormalModeList(items),
        ),
        // Bottom action bar in edit mode
        if (isEditing) _buildEditingBottomBar(),
      ],
    );
  }

  /// Normal mode list with accordion cards
  Widget _buildNormalModeList(List<CoffeeItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _buildListAddButton(false);
        }
        final item = items[index];
        return _CoffeeAccordionCard(
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

  /// Edit mode list with reorderable items
  Widget _buildEditModeList(List<CoffeeItem> items) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            itemCount: items.length,
            onReorder: (oldIndex, newIndex) {
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

              // Obx wraps each item so checkbox reacts to selection changes
              // independently. ReorderableListView.builder calls itemBuilder
              // lazily during layout (outside the parent Obx scope), so without
              // a per-item Obx, _selectedIdsForEdit changes would not trigger
              // a rebuild of the checkbox UI.
              return Obx(key: ValueKey(item.id), () {
                final isSelected = controller.isSelectedForEdit(item.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Checkbox OUTSIDE card (left)
                        GestureDetector(
                          onTap: () => controller.toggleEditSelection(item.id),
                          child: _buildEditCheckbox(isSelected),
                        ),
                        const SizedBox(width: 12),
                        // Card
                        Expanded(child: _buildEditModeCard(item, isSelected)),
                        const SizedBox(width: 12),
                        // Drag handle with ReorderableDragStartListener
                        ReorderableDragStartListener(
                          index: index,
                          child: Icon(
                            Icons.drag_handle,
                            color: AppColor.labelNormal,
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
        // Add button at the bottom (outside ReorderableListView)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildListAddButton(true),
        ),
      ],
    );
  }

  /// Add button at the end of the list
  /// Normal mode: Gray filled circular button with inset shadow (음각 효과)
  /// Edit mode: Gray outline circular button with inset shadow (음각 효과)
  Widget _buildListAddButton(bool isEditing) {
    return Padding(
      padding: EdgeInsets.only(
        top: isEditing ? 4 : 8, // Figma: smaller gap in edit mode
        bottom: isEditing ? 8 : 16,
      ),
      child: Center(
        child: GestureDetector(
          onTap: controller.addNewCoffee,
          child: isEditing
              ? _buildEditModeAddButton()
              : _buildNormalModeAddButton(),
        ),
      ),
    );
  }

  /// Normal mode add button with inset shadow effect (음각)
  /// Figma: Recessed/pressed appearance with inner shadow
  Widget _buildNormalModeAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Base color - light gray
        color: const Color(0xFFE8E8E8),
        // Outer subtle shadow for depth
        boxShadow: [
          // Light shadow on bottom-right (simulates light source from top-left)
          BoxShadow(
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.8),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
          // Dark shadow on top-left (simulates depth/recess)
          BoxShadow(
            color: AppColor.colorGlobalCommon0.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Inner gradient to simulate inset effect
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              const Color(0xFFE8E8E8), // Center - base color
              const Color(0xFFD8D8D8), // Edge - slightly darker
            ],
            stops: const [0.6, 1.0],
          ),
          // Inner shadow simulation with border
          border: Border.all(
            color: const Color(0xFFCCCCCC).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: const Icon(Icons.add, color: Color(0xFF4A4A4A), size: 24),
      ),
    );
  }

  /// Edit mode add button with inset shadow effect (음각)
  /// Figma: Outline style with recessed appearance
  Widget _buildEditModeAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Slightly darker than background for inset effect
        color: const Color(0xFFEAEAEA),
        // Inset shadow simulation
        boxShadow: [
          // Inner shadow effect (top-left dark)
          BoxShadow(
            color: AppColor.colorGlobalCommon0.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(-1, -1),
            spreadRadius: -1,
          ),
          // Bottom-right light for contrast
          BoxShadow(
            color: AppColor.colorGlobalCommon100.withValues(alpha: 0.9),
            blurRadius: 3,
            offset: const Offset(1, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Inner gradient for recessed look
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [
              const Color(0xFFF0F0F0), // Center - lighter
              const Color(0xFFE0E0E0), // Edge - darker (inset effect)
            ],
            stops: const [0.5, 1.0],
          ),
          border: Border.all(
            color: AppColor.colorGlobalCoolNeutral50.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColor.colorGlobalCoolNeutral50,
          size: 24,
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
      // Bean was edited — refresh the list
      controller.refreshList();
    }
  }

  Future<void> _onRecipePressed(CoffeeItem item) async {
    controller.selectCoffee(item.id);
    // Ensure CoffeeController is registered and set selected bean
    if (!Get.isRegistered<CoffeeController>()) {
      Get.put<CoffeeController>(CoffeeController(), permanent: true);
    }
    // Wait for recipe to load before navigating
    await Get.find<CoffeeController>().setSelectedBean(
      id: item.id,
      name: item.name,
    );
    Get.toNamed(Routes.coffeeSettings, arguments: {'coffeeId': item.id});
  }

  /// Edit mode card - Figma: List/Coffee List/Accordion
  /// Height: 80px, Background: #FFFFFF, Border-radius: 20px, Padding: 16px
  Widget _buildEditModeCard(CoffeeItem item, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.toggleEditSelection(item.id),
      child: Container(
        height: 80, // Figma: ~72-80px for better proportions
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ), // Figma: padding
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100, // Figma: #FFFFFF
          borderRadius: BorderRadius.circular(20), // Figma: ~16-20px radius
          border: isSelected
              ? Border.all(color: AppColor.primaryNormal, width: 2)
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
            // Thumbnail - Figma: 48x48, radius 12px
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.colorGlobalCoolNeutral95,
                borderRadius: BorderRadius.circular(12), // Figma: 12px
                image: item.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(item.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.imageUrl == null
                  ? Icon(Icons.coffee, color: item.color, size: 24)
                  : null,
            ),
            const SizedBox(width: 12), // Figma: gap 12px
            // Text content - Figma: brand + name
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand - Figma: 12px, gray
                  Text(
                    item.brand ?? '브랜드명',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12, // Figma: 12px
                      fontWeight: FontWeight.w400, // Figma: 400
                      height: 1.4,
                      letterSpacing: 0.02,
                      color: AppColor.colorGlobalNeutral60, // Figma: gray
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Figma: gap 4px
                  // Name - Figma: 14-16px, semi-bold
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15, // Figma: 14-16px
                      fontWeight: FontWeight.w600, // Figma: 600
                      height: 1.4,
                      letterSpacing: 0.01,
                      color: AppColor.colorGlobalNeutral10, // Figma: near black
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

  /// Edit mode checkbox - OUTSIDE card, left side
  /// Figma: 24x24 outer, 18x18 inner box, border 1.5px, radius 5px
  Widget _buildEditCheckbox(bool isSelected) {
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
          color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
          border: Border.all(
            color: isSelected
                ? AppColor.primaryNormal
                : const Color(
                    0xFF70737C,
                  ).withValues(alpha: 0.22), // Figma: rgba(112,115,124,0.22)
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

  /// Edit mode bottom bar - Figma: Tab Bar Buttons
  /// Height: 64px content + safe area, Padding: 16px, Buttons: 40x40 Liquid Glass
  Widget _buildEditingBottomBar() {
    return Obx(() {
      final hasSelection = controller.selectedEditCount > 0;

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ), // Increased padding
        decoration: const BoxDecoration(
          color: AppColor.colorGlobalCommon0, // Pure black #000000
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48, // Increased for better button visibility
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Share button - Figma: Button/Icon/LiquidGlass 44x44
                GestureDetector(
                  onTap: hasSelection ? controller.shareSelectedItems : null,
                  child: _buildLiquidGlassButton(
                    icon: Icons.ios_share,
                    size: 44,
                  ),
                ),
                // Selection count - Figma: Body 1/Normal - Regular (16px, 400)
                Text(
                  '${controller.selectedEditCount}개가 선택됨',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15, // Increased for better visibility
                    fontWeight: FontWeight.w400, // Figma: 400
                    height: 1.5, // Figma: 150%
                    letterSpacing: 0.01,
                    color: AppColor.colorGlobalCoolNeutral99, // Figma: #F7F7F8
                  ),
                ),
                // Delete button - Figma: Button/Icon/LiquidGlass 44x44
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

  /// Liquid Glass Button - Figma: Button/Icon/LiquidGlass
  /// Fill layer with gradient + Glass Effect overlay
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
        // Figma: Fill layer - gradient with opacity 0.67
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
          // Figma: Glass Effect - rgba(0,0,0,0.2)
          color: AppColor.colorGlobalCommon0.withValues(alpha: 0.2),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFFF7F7F8), // Figma: #F7F7F8
            size: 20, // Figma: 20px icon
          ),
        ),
      ),
    );
  }
}

/// Accordion-style Coffee Card with expand/collapse functionality
class _CoffeeAccordionCard extends StatefulWidget {
  final CoffeeItem item;
  final bool isEditing;
  final bool isSelected;
  final bool initiallyExpanded;
  final VoidCallback? onTap;
  final VoidCallback onDetailPressed;
  final VoidCallback onRecipePressed;

  const _CoffeeAccordionCard({
    required this.item,
    required this.isEditing,
    required this.isSelected,
    required this.initiallyExpanded,
    this.onTap,
    required this.onDetailPressed,
    required this.onRecipePressed,
  });

  @override
  State<_CoffeeAccordionCard> createState() => _CoffeeAccordionCardState();
}

class _CoffeeAccordionCardState extends State<_CoffeeAccordionCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    // In edit mode, cards should start collapsed
    _isExpanded = widget.isEditing ? false : widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurns = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: 0.5,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_CoffeeAccordionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Collapse all cards when entering edit mode
    if (widget.isEditing && !oldWidget.isEditing && _isExpanded) {
      _isExpanded = false;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isEditing) {
      widget.onTap?.call();
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColor.colorGlobalCommon100, // Always white card
          borderRadius: BorderRadius.circular(
            20,
          ), // Figma: 12-16px, slightly more rounded
          border: widget.isSelected
              ? Border.all(color: AppColor.primaryNormal, width: 2)
              : null,
          boxShadow: [
            // Subtle shadow for all cards
            BoxShadow(
              color: AppColor.colorGlobalCommon0.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (always visible)
            _buildHeader(),
            // Expandable content
            ClipRect(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Align(
                    heightFactor: _heightFactor.value,
                    alignment: Alignment.topCenter,
                    child: child,
                  );
                },
                child: _buildExpandedContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header row - Figma: List/Coffee List/Accordion > List
  /// Padding: 20px 16px, gap: 16px, height: ~110px
  /// Note: In edit mode, checkbox and drag handle are OUTSIDE the card (in parent list)
  Widget _buildHeader() {
    // Figma: brand text color rgba(55, 56, 60, 0.61) = #37383C @ 61%
    final subtitleColor = AppColor.labelAlternative;
    // Figma: coffee name color #171719
    const textColor = AppColor.colorGlobalCoolNeutral10;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20, // Figma: 16-20px horizontal
          vertical: 20, // Figma: increased for ~110px card height
        ),
        child: Row(
          children: [
            // Thumbnail - Figma: 64x64, border-radius 12px
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.item.color.withValues(alpha: 0.3),
                    widget.item.color.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(12), // Figma: 8-12px
              ),
              child: Icon(Icons.coffee, color: widget.item.color, size: 32),
            ),
            const SizedBox(width: 16), // Figma: gap 16px
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.item.brand != null) ...[
                    // Figma: 12-14px, gray color
                    Text(
                      widget.item.brand!,
                      style: AppTextStyles.label1NormalMedium.copyWith(
                        color: subtitleColor,
                        letterSpacing: 0.0145,
                      ),
                    ),
                    const SizedBox(height: 6), // Figma: gap 6px
                  ],
                  // Figma: 16px, semi-bold, dark color
                  Text(
                    widget.item.name,
                    style: AppTextStyles.body1NormalBold.copyWith(
                      color: textColor,
                      letterSpacing: 0.0096,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Chevron icon (only in normal mode - not in edit mode)
            // In edit mode, drag handle is OUTSIDE the card
            if (!widget.isEditing)
              RotationTransition(
                turns: _iconTurns,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.labelNeutral,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Expanded Content - Figma: Contents section
  /// Padding: 0px 16px, gap: 16px between sections
  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coffee Profile Section (Taste bars + Divider + Flavor tags in ONE container)
          _buildCoffeeProfileSection(),
          const SizedBox(height: 16),
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Coffee Profile Section - Figma: Coffee Profile
  /// Contains: Attributes (taste bars) + Divider + Flavor Notes (tags)
  /// All inside ONE gray container
  /// Padding: 16px 24px 24px, gap: 20px, radius: 24px
  /// Background: rgba(112, 115, 124, 0.08)
  Widget _buildCoffeeProfileSection() {
    final profile = widget.item.flavorProfile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        16,
        24,
        24,
      ), // Figma: 16px 24px 24px
      decoration: BoxDecoration(
        color: AppColor.componentFillNormal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Attributes Section (Figma: height 100px = 5 bars × 20px, NO gap) ──
          _TasteProgressBar(label: '산미', value: profile.acidity),
          _TasteProgressBar(label: '바디감', value: profile.body),
          _TasteProgressBar(label: '단맛', value: profile.sweetness),
          _TasteProgressBar(label: '쓴맛', value: profile.bitterness),
          _TasteProgressBar(label: '밸런스', value: profile.balance),

          // ── Divider (Figma: 1px height, gap 20px above/below via container gap) ──
          if (widget.item.allFlavorTags.isNotEmpty) ...[
            const SizedBox(height: 20), // gap before divider
            Container(height: 1, color: AppColor.componentFillNormal),
            const SizedBox(height: 20), // gap after divider (before tags)
            // ── Flavor Notes Section (Figma: Coffee Profile/Flavor Notes) ──
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: widget.item.allFlavorTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.componentFillNormal,
                    borderRadius: AppRadius.fullBorder,
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.label1NormalMedium.copyWith(
                      color: AppColor.colorGlobalCoolNeutral10,
                      letterSpacing: 0.0145,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Action Buttons - Figma: Button List
  /// Height: 40px, radius: 99px (pill), gap: 4px
  /// Gray button: rgba(112, 115, 124, 0.08), text #171719
  /// Primary button: #6541F2, text #FFFFFF
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Secondary Button - 원두 상세 (Figma: Button/Solid/Gray)
        Expanded(
          child: GestureDetector(
            onTap: widget.onDetailPressed,
            child: Container(
              height: 40, // Figma: 40px
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF70737C,
                ).withValues(alpha: 0.08), // Figma gray
                borderRadius: AppRadius.fullBorder, // 99px pill
              ),
              child: Center(
                child: Text(
                  '원두 상세', // Figma label
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: AppColor.colorGlobalCoolNeutral10, // #171719
                    letterSpacing: 0.0096,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4), // Figma: gap 4px
        // Primary Button - 레시피 실행 (Figma: Button/Solid/Primary)
        Expanded(
          child: GestureDetector(
            onTap: widget.onRecipePressed,
            child: Container(
              height: 40, // Figma: 40px
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: AppColor.colorGlobalViolet50, // #6541F2
                borderRadius: AppRadius.fullBorder, // 99px pill
              ),
              child: Center(
                child: Text(
                  '레시피 실행', // Figma label
                  style: AppTextStyles.body2NormalBold.copyWith(
                    color: AppColor.colorGlobalCommon100, // #FFFFFF
                    letterSpacing: 0.0096,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Taste Profile Progress Bar Widget - Figma: Coffee Profile/Attributes/Resource/Gauge
/// Label width: 40px, indicator with 6 segments and dividers
/// Fill color: #9E86FC (Violet70), Score color: rgba(55, 56, 60, 0.61)
class _TasteProgressBar extends StatelessWidget {
  final String label;
  final double value;

  /// Maximum value for the progress bar (default: 5.0)
  static const double _maxValue = 5.0;
  static const int _segmentCount = 6; // 0~1, 1~2, 2~3, 3~4, 4~5, 5+

  const _TasteProgressBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, _maxValue);
    // Calculate how many segments to fill (out of 6)
    final filledSegments = (clampedValue / _maxValue * _segmentCount).ceil();

    // Figma: Gauge row height is 20px
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          // Label - Figma: width 40px, Label 1/Normal - Medium, #171719
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: AppColor.colorGlobalCoolNeutral10, // #171719
                letterSpacing: 0.0145,
              ),
            ),
          ),
          const SizedBox(width: 12), // Figma: gap 12px
          // Progress bar with segments - Figma: 156px width, 8px height
          // Structure: [Segment][Divider][Segment][Divider]...[Segment]
          // 6 segments + 5 dividers (1px each) = inline layout per Figma
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF70737C,
                ).withValues(alpha: 0.12), // Figma: rgba(112, 115, 124, 0.12)
                borderRadius: AppRadius.fullBorder,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.fullBorder,
                child: Row(
                  children: _buildSegmentsWithDividers(filledSegments),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), // Figma: gap after indicator
          // Score - Figma: width 28px, Label 1/Normal - Regular, rgba(55, 56, 60, 0.61)
          SizedBox(
            width: 28,
            child: Text(
              clampedValue.toStringAsFixed(1),
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: AppColor.labelAlternative,
                letterSpacing: 0.0145,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// Build segments with inline dividers per Figma spec
  /// Structure: [Segment][Divider][Segment][Divider]...[Segment]
  /// Dividers are 1px wide, taking actual space in the layout
  List<Widget> _buildSegmentsWithDividers(int filledSegments) {
    final List<Widget> children = [];
    final dividerColor =
        AppColor.colorGlobalCoolNeutral50; // Figma: rgba(112, 115, 124, 0.16)

    for (int i = 0; i < _segmentCount; i++) {
      final isFilled = i < filledSegments;

      // Add segment (Expanded to share remaining space equally)
      children.add(
        Expanded(
          child: Container(
            color: isFilled
                ? AppColor
                      .colorGlobalViolet70 // #9E86FC per Figma
                : AppColor.transparent,
          ),
        ),
      );

      // Add divider between segments (not after the last one)
      if (i < _segmentCount - 1) {
        children.add(
          Container(
            width: 1, // Figma: 1px divider
            height: 8,
            color: dividerColor.withValues(alpha: 0.16),
          ),
        );
      }
    }

    return children;
  }
}
