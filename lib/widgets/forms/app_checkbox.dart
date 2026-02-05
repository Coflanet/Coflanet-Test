import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// A custom checkbox widget with label and animations.
///
/// Usage:
/// ```dart
/// // Basic checkbox
/// AppCheckbox(
///   value: isChecked,
///   onChanged: (value) => setState(() => isChecked = value),
///   label: '약관에 동의합니다',
/// )
///
/// // Checkbox with description
/// AppCheckbox(
///   value: isChecked,
///   onChanged: (value) => setState(() => isChecked = value),
///   label: '마케팅 수신 동의',
///   description: '이벤트 및 프로모션 정보를 받아보세요',
/// )
///
/// // Disabled checkbox
/// AppCheckbox(
///   value: true,
///   onChanged: null,
///   label: '비활성화된 체크박스',
///   isEnabled: false,
/// )
/// ```
class AppCheckbox extends StatefulWidget {
  /// Current checked state
  final bool value;

  /// Callback when checkbox is tapped. Null to disable.
  final ValueChanged<bool>? onChanged;

  /// Label text displayed next to checkbox
  final String? label;

  /// Optional description text below the label
  final String? description;

  /// Whether the checkbox is enabled
  final bool isEnabled;

  /// Size of the checkbox (default: 22)
  final double size;

  /// Whether to show error state
  final bool hasError;

  /// Error message to display
  final String? errorText;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.isEnabled = true,
    this.size = 22.0,
    this.hasError = false,
    this.errorText,
  });

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AppCheckbox oldWidget) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox(isDisabled),
              if (widget.label != null) ...[
                SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildLabelSection(isDisabled)),
              ],
            ],
          ),
          if (widget.hasError && widget.errorText != null) ...[
            SizedBox(height: AppSpacing.xxs),
            Padding(
              padding: EdgeInsets.only(left: widget.size + AppSpacing.sm),
              child: Text(
                widget.errorText!,
                style: AppTextStyles.caption1Regular.copyWith(
                  color: AppColor.statusNegative,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckbox(bool isDisabled) {
    final Color borderColor;
    final Color fillColor;

    if (isDisabled) {
      borderColor = AppColor.interactionDisable;
      fillColor = widget.value
          ? AppColor.interactionDisable
          : AppColor.backgroundNormalNormal;
    } else if (widget.hasError) {
      borderColor = AppColor.statusNegative;
      fillColor = widget.value
          ? AppColor.statusNegative
          : AppColor.backgroundNormalNormal;
    } else {
      borderColor = widget.value
          ? AppColor.primaryNormal
          : AppColor.interactionInactive;
      fillColor = widget.value
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
              color: fillColor,
              borderRadius: AppRadius.checkboxBorder,
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
            child: _buildCheckIcon(isDisabled),
          ),
        );
      },
    );
  }

  Widget _buildCheckIcon(bool isDisabled) {
    return AnimatedBuilder(
      animation: _checkAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _checkAnimation.value,
          child: Transform.scale(
            scale: _checkAnimation.value,
            child: Icon(
              Icons.check_rounded,
              size: widget.size - 6,
              color: isDisabled
                  ? AppColor.labelDisable
                  : AppColor.staticLabelWhiteStrong,
            ),
          ),
        );
      },
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
