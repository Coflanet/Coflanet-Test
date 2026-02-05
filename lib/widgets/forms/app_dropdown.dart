import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// A model representing a dropdown option.
class AppDropdownOption<T> {
  /// The value of this option
  final T value;

  /// The display label
  final String label;

  /// Optional icon
  final IconData? icon;

  /// Whether this option is disabled
  final bool isDisabled;

  const AppDropdownOption({
    required this.value,
    required this.label,
    this.icon,
    this.isDisabled = false,
  });
}

/// A custom dropdown widget with smooth animations.
///
/// Usage:
/// ```dart
/// // Basic dropdown
/// AppDropdown<String>(
///   value: selectedValue,
///   options: [
///     AppDropdownOption(value: 'option1', label: '옵션 1'),
///     AppDropdownOption(value: 'option2', label: '옵션 2'),
///     AppDropdownOption(value: 'option3', label: '옵션 3'),
///   ],
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
///
/// // Dropdown with label
/// AppDropdown<String>(
///   label: '카테고리',
///   value: selectedCategory,
///   options: categories.map((c) => AppDropdownOption(
///     value: c.id,
///     label: c.name,
///   )).toList(),
///   onChanged: (value) => setState(() => selectedCategory = value),
///   placeholder: '카테고리를 선택하세요',
/// )
///
/// // Dropdown with icons
/// AppDropdown<String>(
///   value: selectedSort,
///   options: [
///     AppDropdownOption(value: 'latest', label: '최신순', icon: Icons.access_time),
///     AppDropdownOption(value: 'popular', label: '인기순', icon: Icons.favorite),
///     AppDropdownOption(value: 'price', label: '가격순', icon: Icons.attach_money),
///   ],
///   onChanged: (value) => setState(() => selectedSort = value),
/// )
///
/// // Dropdown with helper text
/// AppDropdown<int>(
///   label: '원두 분량',
///   value: selectedGrams,
///   options: [
///     AppDropdownOption(value: 15, label: '15g'),
///     AppDropdownOption(value: 18, label: '18g'),
///     AppDropdownOption(value: 20, label: '20g'),
///   ],
///   onChanged: (value) => setState(() => selectedGrams = value),
///   helperText: '에스프레소 기준 권장량입니다',
/// )
/// ```
class AppDropdown<T> extends StatefulWidget {
  /// Currently selected value
  final T? value;

  /// List of dropdown options
  final List<AppDropdownOption<T>> options;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Label text displayed above the dropdown
  final String? label;

  /// Placeholder text when no value is selected
  final String? placeholder;

  /// Helper text displayed below the dropdown
  final String? helperText;

  /// Error text displayed below the dropdown
  final String? errorText;

  /// Whether the dropdown is enabled
  final bool isEnabled;

  /// Custom prefix icon
  final IconData? prefixIcon;

  const AppDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.isEnabled = true,
    this.prefixIcon,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;
  bool get _isDisabled => !widget.isEnabled || widget.onChanged == null;

  String get _displayText {
    if (widget.value == null) {
      return widget.placeholder ?? '선택하세요';
    }
    try {
      final option = widget.options.firstWhere((o) => o.value == widget.value);
      return option.label;
    } catch (_) {
      return widget.placeholder ?? '선택하세요';
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDisabled) return;

    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
    setState(() {
      _isOpen = false;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectOption(AppDropdownOption<T> option) {
    if (option.isDisabled) return;
    widget.onChanged?.call(option.value);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Calculate if dropdown should open upward or downward
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    final dropdownHeight = (widget.options.length * 48.0 + 16).clamp(
      0.0,
      240.0,
    );
    final openUpward = spaceBelow < dropdownHeight && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Backdrop to close dropdown when tapping outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            // Dropdown menu
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  0,
                  openUpward ? -(dropdownHeight + 8) : size.height + 8,
                ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        alignment: openUpward
                            ? Alignment.bottomCenter
                            : Alignment.topCenter,
                        child: child,
                      ),
                    );
                  },
                  child: _buildDropdownMenu(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownMenu() {
    return Material(
      color: AppColor.backgroundElevatedNormal,
      borderRadius: AppRadius.lgBorder,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 240),
        decoration: BoxDecoration(
          color: AppColor.backgroundElevatedNormal,
          borderRadius: AppRadius.lgBorder,
          border: Border.all(color: AppColor.lineNormalNormal, width: 1),
          boxShadow: AppShadows.shadowBlackStrong,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.lgBorder,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.options.map((option) {
                final isSelected = option.value == widget.value;
                return _buildOptionItem(option, isSelected);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem(AppDropdownOption<T> option, bool isSelected) {
    final isDisabled = option.isDisabled;

    final Color textColor;
    final Color backgroundColor;

    if (isDisabled) {
      textColor = AppColor.labelDisable;
      backgroundColor = AppColor.backgroundElevatedNormal;
    } else if (isSelected) {
      textColor = AppColor.primaryNormal;
      backgroundColor = AppColor.primaryNormal.withValues(alpha: 0.08);
    } else {
      textColor = AppColor.labelNormal;
      backgroundColor = AppColor.backgroundElevatedNormal;
    }

    return GestureDetector(
      onTap: () => _selectOption(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: backgroundColor,
        child: Row(
          children: [
            if (option.icon != null) ...[
              Icon(option.icon, size: 20, color: textColor),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                option.label,
                style: AppTextStyles.body1NormalMedium.copyWith(
                  color: textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColor.primaryNormal,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          SizedBox(height: AppSpacing.xs),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: _buildDropdownButton(),
        ),
        if (_hasError || widget.helperText != null) ...[
          SizedBox(height: AppSpacing.xxs),
          _buildHelperOrError(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    final color = _isDisabled ? AppColor.labelDisable : AppColor.labelNormal;

    return Text(
      widget.label!,
      style: AppTextStyles.label1NormalMedium.copyWith(color: color),
    );
  }

  Widget _buildDropdownButton() {
    final Color borderColor;
    final Color fillColor;
    final Color textColor;
    final Color iconColor;

    if (_isDisabled) {
      borderColor = AppColor.lineNormalAlternative;
      fillColor = AppColor.interactionDisable;
      textColor = AppColor.labelDisable;
      iconColor = AppColor.labelDisable;
    } else if (_hasError) {
      borderColor = AppColor.statusNegative;
      fillColor = AppColor.componentFillNormal;
      textColor = widget.value == null
          ? AppColor.labelAssistive
          : AppColor.labelNormal;
      iconColor = AppColor.labelAlternative;
    } else if (_isOpen) {
      borderColor = AppColor.primaryNormal;
      fillColor = AppColor.backgroundNormalNormal;
      textColor = widget.value == null
          ? AppColor.labelAssistive
          : AppColor.labelNormal;
      iconColor = AppColor.primaryNormal;
    } else {
      borderColor = AppColor.lineNormalNormal;
      fillColor = AppColor.componentFillNormal;
      textColor = widget.value == null
          ? AppColor.labelAssistive
          : AppColor.labelNormal;
      iconColor = AppColor.labelAlternative;
    }

    return GestureDetector(
      onTap: _toggleDropdown,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: AppRadius.inputBorder,
          border: Border.all(
            color: borderColor,
            width: _isOpen && !_hasError && !_isDisabled ? 1.5 : 1.0,
          ),
          boxShadow: _isOpen && !_isDisabled && !_hasError
              ? [
                  BoxShadow(
                    color: AppColor.primaryNormal.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              Icon(widget.prefixIcon, size: 20, color: iconColor),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                _displayText,
                style: AppTextStyles.body1NormalRegular.copyWith(
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            RotationTransition(
              turns: _rotationAnimation,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelperOrError() {
    if (_hasError) {
      return Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 14,
            color: AppColor.statusNegative,
          ),
          SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              widget.errorText!,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.statusNegative,
              ),
            ),
          ),
        ],
      );
    }

    if (widget.helperText != null) {
      return Text(
        widget.helperText!,
        style: AppTextStyles.caption1Regular.copyWith(
          color: AppColor.labelAlternative,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// A compact inline dropdown for use within other components.
///
/// Usage:
/// ```dart
/// AppInlineDropdown<String>(
///   value: selectedUnit,
///   options: [
///     AppDropdownOption(value: 'g', label: 'g'),
///     AppDropdownOption(value: 'ml', label: 'ml'),
///     AppDropdownOption(value: 'oz', label: 'oz'),
///   ],
///   onChanged: (value) => setState(() => selectedUnit = value),
/// )
/// ```
class AppInlineDropdown<T> extends StatelessWidget {
  /// Currently selected value
  final T? value;

  /// List of dropdown options
  final List<AppDropdownOption<T>> options;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Placeholder text
  final String? placeholder;

  /// Whether the dropdown is enabled
  final bool isEnabled;

  const AppInlineDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.placeholder,
    this.isEnabled = true,
  });

  String get _displayText {
    if (value == null) {
      return placeholder ?? '선택';
    }
    try {
      final option = options.firstWhere((o) => o.value == value);
      return option.label;
    } catch (_) {
      return placeholder ?? '선택';
    }
  }

  void _showBottomSheet(BuildContext context) {
    if (!isEnabled || onChanged == null) return;

    showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColor.backgroundElevatedNormal,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.top(AppRadius.xxl)),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.componentFillStrong,
                    borderRadius: AppRadius.fullBorder,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                ...options.map((option) {
                  final isSelected = option.value == value;
                  return ListTile(
                    enabled: !option.isDisabled,
                    selected: isSelected,
                    leading: option.icon != null
                        ? Icon(
                            option.icon,
                            color: isSelected
                                ? AppColor.primaryNormal
                                : AppColor.labelAlternative,
                          )
                        : null,
                    title: Text(
                      option.label,
                      style: AppTextStyles.body1NormalMedium.copyWith(
                        color: option.isDisabled
                            ? AppColor.labelDisable
                            : isSelected
                            ? AppColor.primaryNormal
                            : AppColor.labelNormal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColor.primaryNormal,
                          )
                        : null,
                    onTap: option.isDisabled
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            onChanged?.call(option.value);
                          },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || onChanged == null;
    final textColor = isDisabled
        ? AppColor.labelDisable
        : value == null
        ? AppColor.labelAssistive
        : AppColor.labelNormal;
    final iconColor = isDisabled
        ? AppColor.labelDisable
        : AppColor.labelAlternative;

    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: AppRadius.mdBorder,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _displayText,
              style: AppTextStyles.label1NormalMedium.copyWith(
                color: textColor,
              ),
            ),
            SizedBox(width: AppSpacing.xxs),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: iconColor),
          ],
        ),
      ),
    );
  }
}
