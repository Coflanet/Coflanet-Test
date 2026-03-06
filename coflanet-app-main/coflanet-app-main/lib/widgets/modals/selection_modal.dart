import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// A bottom sheet modal for single or multi-selection from a list of options.
///
/// Figma Design Spec:
/// - Drag handle (40x4px, pill shape, light gray)
/// - Close button (X icon, top right)
/// - Title (22px Bold, center aligned)
/// - Description (optional, 15px Regular, center aligned, gray)
/// - Option buttons (pill shape, 56px height, full-width)
///   - Selected: white bg + violet 2px border + violet text
///   - Unselected: light gray bg + black text
///
/// Usage:
/// ```dart
/// // Single select - taps option and closes immediately
/// final result = await SelectionModal.show(
///   title: '옵션 선택',
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   selectedIndex: 0,
/// );
///
/// // Multi select - shows confirm button
/// final results = await SelectionModal.show(
///   title: '옵션 선택',
///   description: '여러 개를 선택할 수 있어요',
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   selectedIndices: [0, 2],
///   isMultiSelect: true,
/// );
/// ```
class SelectionModal extends StatefulWidget {
  final String title;
  final String? description;
  final List<String> options;
  final int? selectedIndex;
  final List<int>? selectedIndices;
  final bool isMultiSelect;
  final String? confirmText;
  final String? cancelText;
  final bool barrierDismissible;

  const SelectionModal({
    super.key,
    required this.title,
    this.description,
    required this.options,
    this.selectedIndex,
    this.selectedIndices,
    this.isMultiSelect = false,
    this.confirmText,
    this.cancelText,
    this.barrierDismissible = true,
  });

  /// Shows the selection modal and returns the selected index (single) or indices (multi).
  /// Returns null if cancelled or dismissed.
  static Future<dynamic> show({
    required String title,
    String? description,
    required List<String> options,
    int? selectedIndex,
    List<int>? selectedIndices,
    bool isMultiSelect = false,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) async {
    return Get.bottomSheet<dynamic>(
      SelectionModal(
        title: title,
        description: description,
        options: options,
        selectedIndex: selectedIndex,
        selectedIndices: selectedIndices,
        isMultiSelect: isMultiSelect,
        confirmText: confirmText,
        cancelText: cancelText,
        barrierDismissible: barrierDismissible,
      ),
      isDismissible: barrierDismissible,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      barrierColor: AppColor.componentMaterialDimmer,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  State<SelectionModal> createState() => _SelectionModalState();
}

class _SelectionModalState extends State<SelectionModal> {
  late int? _selectedIndex;
  late Set<int> _selectedIndices;

  // Figma colors (semantic mapping)
  static final Color _dragHandleColor = AppColor.lineSolidNormal;
  static final Color _closeIconColor = AppColor.labelNormal;
  static final Color _titleColor = AppColor.labelNormal;
  static final Color _descriptionColor = AppColor.labelAlternative;
  static final Color _selectedBorderColor = AppColor.primaryNormal;
  static final Color _selectedTextColor = AppColor.primaryNormal;
  static final Color _selectedBgColor = AppColor.backgroundNormalNormal;
  static final Color _unselectedBgColor = AppColor.colorGlobalCoolNeutral99;
  static final Color _unselectedTextColor = AppColor.labelNormal;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _selectedIndices = Set<int>.from(widget.selectedIndices ?? []);
  }

  void _onOptionTap(int index) {
    if (widget.isMultiSelect) {
      // Multi-select: toggle and wait for confirm
      setState(() {
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
        } else {
          _selectedIndices.add(index);
        }
      });
    } else {
      // Single-select: select and close immediately
      Get.back(result: index);
    }
  }

  void _onConfirm() {
    if (widget.isMultiSelect) {
      Get.back(result: _selectedIndices.toList()..sort());
    } else {
      Get.back(result: _selectedIndex);
    }
  }

  void _onClose() {
    Get.back(result: null);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedNormal,
        borderRadius: AppRadius.top(AppRadius.xxl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildContent(),
          if (widget.isMultiSelect) _buildConfirmButton(),
          // iOS Home Indicator area
          SizedBox(height: bottomPadding > 0 ? bottomPadding : 20),
        ],
      ),
    );
  }

  /// Drag handle - 40x4px pill shape
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: _dragHandleColor,
        borderRadius: AppRadius.fullBorder,
      ),
    );
  }

  /// Header with close button and title
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Close button - top right
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: _onClose,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.close, size: 24, color: _closeIconColor),
              ),
            ),
          ),
          // Title + Description
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.heading1Bold.copyWith(
                    color: _titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.description!,
                    style: AppTextStyles.body2NormalRegular.copyWith(
                      color: _descriptionColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Scrollable option list
  Widget _buildContent() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.options.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final isSelected = widget.isMultiSelect
                ? _selectedIndices.contains(index)
                : _selectedIndex == index;

            return _buildOptionButton(
              label: widget.options[index],
              isSelected: isSelected,
              onTap: () => _onOptionTap(index),
            );
          },
        ),
      ),
    );
  }

  /// Option button - 56px height, pill shape
  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? _selectedBgColor : _unselectedBgColor,
          borderRadius: AppRadius.fullBorder,
          border: Border.all(
            color: isSelected ? _selectedBorderColor : AppColor.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: isSelected ? _selectedTextColor : _unselectedTextColor,
            ),
          ),
        ),
      ),
    );
  }

  /// Confirm button for multi-select mode
  Widget _buildConfirmButton() {
    final hasSelection = _selectedIndices.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: hasSelection ? _onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryNormal,
            disabledBackgroundColor: AppColor.interactionDisable,
            foregroundColor: AppColor.staticLabelWhiteStrong,
            disabledForegroundColor: AppColor.labelDisable,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.fullBorder),
          ),
          child: Text(
            widget.confirmText ?? '확인',
            style: AppTextStyles.headline1Bold,
          ),
        ),
      ),
    );
  }
}
