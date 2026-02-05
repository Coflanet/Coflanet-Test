import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Snackbar notification types
enum AppSnackbarType {
  /// Default dark snackbar
  info,

  /// Green success snackbar
  success,

  /// Red error snackbar
  error,

  /// Orange warning snackbar
  warning,
}

/// A custom snackbar with animated slide-in and various status variants.
///
/// Features:
/// - Four types: info (default), success, error, warning
/// - Icon + message layout
/// - Auto-dismiss with configurable duration
/// - Optional action button
/// - Slide-in from bottom animation
///
/// Usage:
/// ```dart
/// // Quick success message
/// AppSnackbar.success('저장되었습니다');
///
/// // Error with longer duration
/// AppSnackbar.error('오류가 발생했습니다', duration: Duration(seconds: 5));
///
/// // Warning with action
/// AppSnackbar.warning(
///   '네트워크 연결이 불안정합니다',
///   actionText: '재시도',
///   onAction: () => retryConnection(),
/// );
///
/// // Custom info snackbar
/// AppSnackbar.show(
///   message: '새로운 레시피가 추가되었습니다',
///   icon: Icons.coffee_rounded,
/// );
/// ```
class AppSnackbar {
  AppSnackbar._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  /// Shows a snackbar with customizable options
  static void show({
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    String? actionText,
    VoidCallback? onAction,
    bool showIcon = true,
  }) {
    _dismiss();

    final overlay = Overlay.of(Get.overlayContext!);

    _currentEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        message: message,
        type: type,
        duration: duration,
        icon: icon,
        actionText: actionText,
        onAction: onAction,
        showIcon: showIcon,
        onDismiss: _dismiss,
      ),
    );

    overlay.insert(_currentEntry!);

    _dismissTimer?.cancel();
    _dismissTimer = Timer(duration + const Duration(milliseconds: 350), () {
      _dismiss();
    });
  }

  /// Shows a success snackbar (green)
  static void success(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionText,
    VoidCallback? onAction,
  }) {
    show(
      message: message,
      type: AppSnackbarType.success,
      duration: duration,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Shows an error snackbar (red)
  static void error(
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionText,
    VoidCallback? onAction,
  }) {
    show(
      message: message,
      type: AppSnackbarType.error,
      duration: duration,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Shows a warning snackbar (orange)
  static void warning(
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionText,
    VoidCallback? onAction,
  }) {
    show(
      message: message,
      type: AppSnackbarType.warning,
      duration: duration,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Shows an info snackbar (default dark)
  static void info(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionText,
    VoidCallback? onAction,
  }) {
    show(
      message: message,
      type: AppSnackbarType.info,
      duration: duration,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Dismisses the current snackbar
  static void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }

  /// Force dismiss any visible snackbar
  static void dismiss() => _dismiss();
}

class _SnackbarOverlay extends StatefulWidget {
  final String message;
  final AppSnackbarType type;
  final Duration duration;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showIcon;
  final VoidCallback onDismiss;

  const _SnackbarOverlay({
    required this.message,
    required this.type,
    required this.duration,
    this.icon,
    this.actionText,
    this.onAction,
    required this.showIcon,
    required this.onDismiss,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Schedule dismiss animation
    Future.delayed(widget.duration, () {
      if (mounted && _isVisible) {
        _animateOut();
      }
    });
  }

  void _animateOut() async {
    if (!mounted) return;
    setState(() => _isVisible = false);
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case AppSnackbarType.success:
        return AppColor.statusPositive;
      case AppSnackbarType.error:
        return AppColor.statusNegative;
      case AppSnackbarType.warning:
        return AppColor.statusCautionary;
      case AppSnackbarType.info:
        return AppColor.inverseBackground;
    }
  }

  Color get _textColor {
    switch (widget.type) {
      case AppSnackbarType.success:
      case AppSnackbarType.error:
      case AppSnackbarType.info:
        return AppColor.inverseLabelNormal;
      case AppSnackbarType.warning:
        return AppColor.staticLabelBlackNormal;
    }
  }

  Color get _iconColor => _textColor;

  IconData get _defaultIcon {
    switch (widget.type) {
      case AppSnackbarType.success:
        return Icons.check_circle_rounded;
      case AppSnackbarType.error:
        return Icons.error_rounded;
      case AppSnackbarType.warning:
        return Icons.warning_rounded;
      case AppSnackbarType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      left: AppSpacing.md,
      right: AppSpacing.md,
      bottom: bottomPadding + AppSpacing.lg,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy > 100) {
                  _animateOut();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: AppRadius.lgBorder,
                  boxShadow: AppShadows.shadowBlackStrong,
                ),
                child: Row(
                  children: [
                    if (widget.showIcon) ...[
                      Icon(
                        widget.icon ?? _defaultIcon,
                        color: _iconColor,
                        size: 22,
                      ),
                      SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        widget.message,
                        style: AppTextStyles.body2NormalMedium.copyWith(
                          color: _textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.actionText != null) ...[
                      SizedBox(width: AppSpacing.sm),
                      _ActionButton(
                        text: widget.actionText!,
                        textColor: _textColor,
                        onPressed: () {
                          widget.onAction?.call();
                          _animateOut();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.smBorder,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          text,
          style: AppTextStyles.label1NormalBold.copyWith(
            color: textColor,
            decoration: TextDecoration.underline,
            decorationColor: textColor,
          ),
        ),
      ),
    );
  }
}
