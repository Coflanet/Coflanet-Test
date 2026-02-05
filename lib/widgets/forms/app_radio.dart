import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// A model representing a radio option.
class AppRadioOption<T> {
  /// The value of this option
  final T value;

  /// The display label
  final String label;

  /// Optional description text
  final String? description;

  /// Whether this option is disabled
  final bool isDisabled;

  const AppRadioOption({
    required this.value,
    required this.label,
    this.description,
    this.isDisabled = false,
  });
}

/// A custom radio button group widget with animations.
///
/// Usage:
/// ```dart
/// // Basic radio group
/// AppRadioGroup<String>(
///   value: selectedValue,
///   options: [
///     AppRadioOption(value: 'option1', label: '옵션 1'),
///     AppRadioOption(value: 'option2', label: '옵션 2'),
///     AppRadioOption(value: 'option3', label: '옵션 3'),
///   ],
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
///
/// // Radio group with descriptions
/// AppRadioGroup<int>(
///   value: selectedPlan,
///   options: [
///     AppRadioOption(
///       value: 1,
///       label: '기본 플랜',
///       description: '월 9,900원',
///     ),
///     AppRadioOption(
///       value: 2,
///       label: '프리미엄 플랜',
///       description: '월 19,900원',
///     ),
///   ],
///   onChanged: (value) => setState(() => selectedPlan = value),
/// )
///
/// // Horizontal layout
/// AppRadioGroup<String>(
///   value: selectedGender,
///   options: [
///     AppRadioOption(value: 'male', label: '남성'),
///     AppRadioOption(value: 'female', label: '여성'),
///   ],
///   onChanged: (value) => setState(() => selectedGender = value),
///   direction: Axis.horizontal,
/// )
/// ```
class AppRadioGroup<T> extends StatelessWidget {
  /// Currently selected value
  final T? value;

  /// List of radio options
  final List<AppRadioOption<T>> options;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Layout direction (vertical or horizontal)
  final Axis direction;

  /// Whether the entire group is enabled
  final bool isEnabled;

  /// Spacing between radio items
  final double spacing;

  /// Size of the radio button
  final double size;

  const AppRadioGroup({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.direction = Axis.vertical,
    this.isEnabled = true,
    this.spacing = 12.0,
    this.size = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Row(children: _buildRadioItems());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildRadioItems(),
    );
  }

  List<Widget> _buildRadioItems() {
    final List<Widget> items = [];

    for (int i = 0; i < options.length; i++) {
      items.add(
        AppRadioItem<T>(
          option: options[i],
          isSelected: value == options[i].value,
          onTap: _handleTap,
          isEnabled: isEnabled && !options[i].isDisabled,
          size: size,
        ),
      );

      if (i < options.length - 1) {
        items.add(
          direction == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
    }

    return items;
  }

  void _handleTap(T value) {
    if (!isEnabled || onChanged == null) return;
    onChanged!(value);
  }
}

/// Individual radio button item.
class AppRadioItem<T> extends StatefulWidget {
  final AppRadioOption<T> option;
  final bool isSelected;
  final void Function(T value) onTap;
  final bool isEnabled;
  final double size;

  const AppRadioItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.isEnabled,
    required this.size,
  });

  @override
  State<AppRadioItem<T>> createState() => _AppRadioItemState<T>();
}

class _AppRadioItemState<T> extends State<AppRadioItem<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _innerDotAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _innerDotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AppRadioItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    widget.onTap(widget.option.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRadioCircle(),
          SizedBox(width: AppSpacing.sm),
          Flexible(child: _buildLabelSection()),
        ],
      ),
    );
  }

  Widget _buildRadioCircle() {
    final Color borderColor;
    final Color fillColor;

    if (!widget.isEnabled) {
      borderColor = AppColor.interactionDisable;
      fillColor = widget.isSelected
          ? AppColor.interactionDisable
          : AppColor.backgroundNormalNormal;
    } else {
      borderColor = widget.isSelected
          ? AppColor.primaryNormal
          : AppColor.interactionInactive;
      fillColor = widget.isSelected
          ? AppColor.primaryNormal
          : AppColor.backgroundNormalNormal;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fillColor,
              border: Border.all(color: borderColor, width: 2),
              boxShadow: widget.isSelected && widget.isEnabled
                  ? [
                      BoxShadow(
                        color: AppColor.primaryNormal.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: _buildInnerDot(),
          ),
        );
      },
    );
  }

  Widget _buildInnerDot() {
    return AnimatedBuilder(
      animation: _innerDotAnimation,
      builder: (context, child) {
        return Center(
          child: Transform.scale(
            scale: _innerDotAnimation.value,
            child: Container(
              width: widget.size * 0.36,
              height: widget.size * 0.36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isEnabled
                    ? AppColor.staticLabelWhiteStrong
                    : AppColor.labelDisable,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabelSection() {
    final labelColor = widget.isEnabled
        ? AppColor.labelNormal
        : AppColor.labelDisable;
    final descColor = widget.isEnabled
        ? AppColor.labelAlternative
        : AppColor.labelDisable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.option.label,
          style: AppTextStyles.body1NormalMedium.copyWith(color: labelColor),
        ),
        if (widget.option.description != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            widget.option.description!,
            style: AppTextStyles.caption1Regular.copyWith(color: descColor),
          ),
        ],
      ],
    );
  }
}

/// A single radio button for standalone use.
///
/// Usage:
/// ```dart
/// AppRadio(
///   value: isSelected,
///   onChanged: (value) => setState(() => isSelected = value),
///   label: '선택 항목',
/// )
/// ```
class AppRadio extends StatefulWidget {
  /// Whether this radio is selected
  final bool value;

  /// Callback when tapped
  final ValueChanged<bool>? onChanged;

  /// Optional label text
  final String? label;

  /// Optional description
  final String? description;

  /// Whether the radio is enabled
  final bool isEnabled;

  /// Size of the radio button
  final double size;

  const AppRadio({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.isEnabled = true,
    this.size = 22.0,
  });

  @override
  State<AppRadio> createState() => _AppRadioState();
}

class _AppRadioState extends State<AppRadio>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _innerDotAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _innerDotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AppRadio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled || widget.onChanged == null) return;
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.isEnabled || widget.onChanged == null;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRadioCircle(isDisabled),
          if (widget.label != null) ...[
            SizedBox(width: AppSpacing.sm),
            Flexible(child: _buildLabelSection(isDisabled)),
          ],
        ],
      ),
    );
  }

  Widget _buildRadioCircle(bool isDisabled) {
    final Color borderColor;
    final Color fillColor;

    if (isDisabled) {
      borderColor = AppColor.interactionDisable;
      fillColor = widget.value
          ? AppColor.interactionDisable
          : AppColor.backgroundNormalNormal;
    } else {
      borderColor = widget.value
          ? AppColor.primaryNormal
          : AppColor.interactionInactive;
      fillColor = widget.value
          ? AppColor.primaryNormal
          : AppColor.backgroundNormalNormal;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: widget.value && !isDisabled
            ? [
                BoxShadow(
                  color: AppColor.primaryNormal.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: AnimatedBuilder(
        animation: _innerDotAnimation,
        builder: (context, child) {
          return Center(
            child: Transform.scale(
              scale: _innerDotAnimation.value,
              child: Container(
                width: widget.size * 0.36,
                height: widget.size * 0.36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDisabled
                      ? AppColor.labelDisable
                      : AppColor.staticLabelWhiteStrong,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabelSection(bool isDisabled) {
    final labelColor = isDisabled
        ? AppColor.labelDisable
        : AppColor.labelNormal;
    final descColor = isDisabled
        ? AppColor.labelDisable
        : AppColor.labelAlternative;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label!,
          style: AppTextStyles.body1NormalMedium.copyWith(color: labelColor),
        ),
        if (widget.description != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            widget.description!,
            style: AppTextStyles.caption1Regular.copyWith(color: descColor),
          ),
        ],
      ],
    );
  }
}
