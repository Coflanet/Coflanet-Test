import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// A modal for single or multi-selection from a list of options.
///
/// Usage:
/// ```dart
/// // Single select
/// final result = await SelectionModal.show(
///   title: '옵션 선택',
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   selectedIndex: 0,
/// );
///
/// // Multi select
/// final results = await SelectionModal.show(
///   title: '옵션 선택',
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   selectedIndices: [0, 2],
///   isMultiSelect: true,
/// );
/// ```
class SelectionModal extends StatefulWidget {
  final String title;
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
    required this.options,
    this.selectedIndex,
    this.selectedIndices,
    this.isMultiSelect = false,
    this.confirmText,
    this.cancelText,
    this.barrierDismissible = true,
  });

  /// Shows the selection modal and returns the selected index (single) or indices (multi).
  /// Returns null if cancelled.
  static Future<dynamic> show({
    required String title,
    required List<String> options,
    int? selectedIndex,
    List<int>? selectedIndices,
    bool isMultiSelect = false,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog<dynamic>(
      SelectionModal(
        title: title,
        options: options,
        selectedIndex: selectedIndex,
        selectedIndices: selectedIndices,
        isMultiSelect: isMultiSelect,
        confirmText: confirmText,
        cancelText: cancelText,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColor.componentMaterialDimmer,
    );
  }

  @override
  State<SelectionModal> createState() => _SelectionModalState();
}

class _SelectionModalState extends State<SelectionModal>
    with SingleTickerProviderStateMixin {
  late int? _selectedIndex;
  late Set<int> _selectedIndices;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _selectedIndices = Set<int>.from(widget.selectedIndices ?? []);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onOptionTap(int index) {
    if (widget.isMultiSelect) {
      setState(() {
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
        } else {
          _selectedIndices.add(index);
        }
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onConfirm() {
    if (widget.isMultiSelect) {
      Get.back(result: _selectedIndices.toList()..sort());
    } else {
      Get.back(result: _selectedIndex);
    }
  }

  void _onCancel() {
    Get.back(result: null);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: AppColor.backgroundElevatedNormal,
              borderRadius: AppRadius.modalBorder,
              boxShadow: AppShadows.shadowBlackHeavy,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildHeader(), _buildOptionsList(), _buildActions()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Text(
        widget.title,
        style: AppTextStyles.heading1Bold.copyWith(color: AppColor.labelNormal),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsList() {
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 320),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final isSelected = widget.isMultiSelect
                ? _selectedIndices.contains(index)
                : _selectedIndex == index;

            return _buildOptionItem(
              index: index,
              label: widget.options[index],
              isSelected: isSelected,
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required int index,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onOptionTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          // Figma: 선택됨 = 흰색 배경, 미선택 = 연한 회색 배경
          color: isSelected
              ? AppColor.backgroundNormalNormal
              : AppColor.componentFillNormal,
          borderRadius: AppRadius.xxxlBorder, // pill 형태
          border: Border.all(
            // Figma: 선택됨 = Violet 테두리 2px, 미선택 = 테두리 없음
            color: isSelected ? AppColor.primaryNormal : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            // Figma: 선택됨 = Violet 텍스트, 미선택 = 검정 텍스트
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: isSelected ? AppColor.primaryNormal : AppColor.labelNormal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    if (widget.isMultiSelect) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryNormal : Colors.transparent,
          borderRadius: AppRadius.checkboxBorder,
          border: Border.all(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.interactionInactive,
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                size: 16,
                color: AppColor.staticLabelWhiteStrong,
              )
            : null,
      );
    } else {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColor.primaryNormal : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppColor.primaryNormal
                : AppColor.interactionInactive,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.staticLabelWhiteStrong,
                  ),
                ),
              )
            : null,
      );
    }
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              text: widget.cancelText ?? '취소',
              onPressed: _onCancel,
              isPrimary: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              text: widget.confirmText ?? '확인',
              onPressed: _onConfirm,
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryNormal,
            foregroundColor: AppColor.staticLabelWhiteStrong,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
          ),
          child: Text(text, style: AppTextStyles.headline2Bold),
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.labelNormal,
          side: BorderSide(color: AppColor.lineNormalNormal),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
        ),
        child: Text(text, style: AppTextStyles.headline2Bold),
      ),
    );
  }
}
