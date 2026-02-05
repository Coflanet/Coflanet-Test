import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// A custom toggle/switch widget with smooth animations.
///
/// Usage:
/// ```dart
/// // Basic toggle
/// AppToggle(
///   value: isEnabled,
///   onChanged: (value) => setState(() => isEnabled = value),
/// )
///
/// // Toggle with label
/// AppToggle(
///   value: notificationsEnabled,
///   onChanged: (value) => setState(() => notificationsEnabled = value),
///   label: '알림 받기',
/// )
///
/// // Toggle with label and description
/// AppToggle(
///   value: darkMode,
///   onChanged: (value) => setState(() => darkMode = value),
///   label: '다크 모드',
///   description: '어두운 테마를 사용합니다',
/// )
///
/// // Toggle with label on left side
/// AppToggle(
///   value: isActive,
///   onChanged: (value) => setState(() => isActive = value),
///   label: '활성화',
///   labelPosition: AppToggleLabelPosition.left,
/// )
///
/// // Disabled toggle
/// AppToggle(
///   value: true,
///   onChanged: null,
///   label: '비활성화된 토글',
///   isEnabled: false,
/// )
///
/// // Small size toggle
/// AppToggle(
///   value: isOn,
///   onChanged: (value) => setState(() => isOn = value),
///   size: AppToggleSize.small,
/// )
/// ```
enum AppToggleLabelPosition { left, right }

enum AppToggleSize { small, medium, large }

class AppToggle extends StatefulWidget {
  /// Current toggle state
  final bool value;

  /// Callback when toggle is changed. Null to disable.
  final ValueChanged<bool>? onChanged;

  /// Optional label text
  final String? label;

  /// Optional description text
  final String? description;

  /// Whether the toggle is enabled
  final bool isEnabled;

  /// Position of the label relative to the toggle
  final AppToggleLabelPosition labelPosition;

  /// Size of the toggle
  final AppToggleSize size;

  /// Custom active color (defaults to primary)
  final Color? activeColor;

  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.isEnabled = true,
    this.labelPosition = AppToggleLabelPosition.right,
    this.size = AppToggleSize.medium,
    this.activeColor,
  });

  @override
  State<AppToggle> createState() => _AppToggleState();
}

class _AppToggleState extends State<AppToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;

  // Size configurations
  double get _trackWidth {
    switch (widget.size) {
      case AppToggleSize.small:
        return 40.0;
      case AppToggleSize.medium:
        return 50.0;
      case AppToggleSize.large:
        return 60.0;
    }
  }

  double get _trackHeight {
    switch (widget.size) {
      case AppToggleSize.small:
        return 24.0;
      case AppToggleSize.medium:
        return 30.0;
      case AppToggleSize.large:
        return 36.0;
    }
  }

  double get _thumbSize {
    switch (widget.size) {
      case AppToggleSize.small:
        return 18.0;
      case AppToggleSize.medium:
        return 24.0;
      case AppToggleSize.large:
        return 30.0;
    }
  }

  double get _thumbPadding => 3.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AppToggle oldWidget) {
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

    if (widget.label == null) {
      return GestureDetector(
        onTap: _handleTap,
        child: _buildToggle(isDisabled),
      );
    }

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.labelPosition == AppToggleLabelPosition.left
            ? [
                Flexible(child: _buildLabelSection(isDisabled)),
                SizedBox(width: AppSpacing.sm),
                _buildToggle(isDisabled),
              ]
            : [
                _buildToggle(isDisabled),
                SizedBox(width: AppSpacing.sm),
                Flexible(child: _buildLabelSection(isDisabled)),
              ],
      ),
    );
  }

  Widget _buildToggle(bool isDisabled) {
    final activeColor = widget.activeColor ?? AppColor.primaryNormal;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final Color trackColor;
        final Color thumbColor;

        if (isDisabled) {
          trackColor = widget.value
              ? AppColor.interactionDisable
              : AppColor.componentFillStrong;
          thumbColor = AppColor.staticLabelWhiteStrong;
        } else {
          trackColor = Color.lerp(
            AppColor.componentFillStrong,
            activeColor,
            _positionAnimation.value,
          )!;
          thumbColor = AppColor.staticLabelWhiteStrong;
        }

        final thumbPosition =
            _positionAnimation.value *
            (_trackWidth - _thumbSize - (_thumbPadding * 2));

        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: _trackWidth,
            height: _trackHeight,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(_trackHeight / 2),
              boxShadow: widget.value && !isDisabled
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: _thumbPadding + thumbPosition,
                  top: (_trackHeight - _thumbSize) / 2,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: thumbColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.colorGlobalCommon0.withValues(
                            alpha: 0.15,
                          ),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      crossAxisAlignment: widget.labelPosition == AppToggleLabelPosition.left
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
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

/// A toggle tile widget that spans the full width with label and toggle.
///
/// Usage:
/// ```dart
/// AppToggleTile(
///   value: isEnabled,
///   onChanged: (value) => setState(() => isEnabled = value),
///   title: '푸시 알림',
///   subtitle: '새로운 소식을 알림으로 받아보세요',
/// )
/// ```
class AppToggleTile extends StatelessWidget {
  /// Current toggle state
  final bool value;

  /// Callback when toggle is changed
  final ValueChanged<bool>? onChanged;

  /// Title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Whether the tile is enabled
  final bool isEnabled;

  /// Leading widget (icon, avatar, etc.)
  final Widget? leading;

  /// Padding around the tile
  final EdgeInsets padding;

  const AppToggleTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.isEnabled = true,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || onChanged == null;
    final labelColor = isDisabled
        ? AppColor.labelDisable
        : AppColor.labelNormal;
    final subtitleColor = isDisabled
        ? AppColor.labelDisable
        : AppColor.labelAlternative;

    return GestureDetector(
      onTap: () {
        if (!isDisabled) {
          onChanged?.call(!value);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: AppSpacing.sm)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1NormalMedium.copyWith(
                      color: labelColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption1Regular.copyWith(
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            AppToggle(
              value: value,
              onChanged: isDisabled ? null : onChanged,
              size: AppToggleSize.medium,
            ),
          ],
        ),
      ),
    );
  }
}
