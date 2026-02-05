import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Position for the tooltip relative to the trigger element
enum AppTooltipPosition {
  /// Tooltip appears above the trigger
  above,

  /// Tooltip appears below the trigger
  below,

  /// Auto-detect based on available space
  auto,
}

/// A tooltip widget that wraps any child and shows a message on tap or hover.
///
/// Features:
/// - Wraps any widget to show tooltip
/// - Configurable message and position
/// - Arrow pointing to trigger element
/// - Auto-position (above/below) based on available space
/// - Fade in/out animation
/// - Dismiss on tap outside
///
/// Usage:
/// ```dart
/// // Simple tooltip
/// AppTooltip(
///   message: '도움말 텍스트',
///   child: Icon(Icons.help_outline),
/// )
///
/// // Tooltip with custom position
/// AppTooltip(
///   message: '이 버튼을 눌러 저장하세요',
///   position: AppTooltipPosition.above,
///   child: ElevatedButton(
///     onPressed: () {},
///     child: Text('저장'),
///   ),
/// )
///
/// // Rich content tooltip
/// AppTooltip(
///   message: '원두의 로스팅 정도를 선택하세요.\n라이트, 미디엄, 다크 중 선택할 수 있습니다.',
///   maxWidth: 200,
///   child: Icon(Icons.info_outline),
/// )
/// ```
class AppTooltip extends StatefulWidget {
  /// The widget that triggers the tooltip
  final Widget child;

  /// The message to display in the tooltip
  final String message;

  /// Position preference for the tooltip
  final AppTooltipPosition position;

  /// Maximum width of the tooltip
  final double maxWidth;

  /// Whether to show tooltip on tap (default) or long press
  final bool showOnTap;

  /// Whether to show tooltip on hover (for desktop/web)
  final bool showOnHover;

  /// Custom background color (defaults to inverse background)
  final Color? backgroundColor;

  /// Custom text color (defaults to inverse label)
  final Color? textColor;

  /// Duration to show the tooltip before auto-hiding
  final Duration? showDuration;

  const AppTooltip({
    super.key,
    required this.child,
    required this.message,
    this.position = AppTooltipPosition.auto,
    this.maxWidth = 240,
    this.showOnTap = true,
    this.showOnHover = true,
    this.backgroundColor,
    this.textColor,
    this.showDuration,
  });

  @override
  State<AppTooltip> createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip>
    with SingleTickerProviderStateMixin {
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _hideTimer;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hideTooltip();
    _animationController.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (_isVisible) return;

    _hideTimer?.cancel();
    _isVisible = true;

    final overlay = Overlay.of(context);
    final renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final triggerPosition = renderBox.localToGlobal(Offset.zero);
    final triggerSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        message: widget.message,
        triggerPosition: triggerPosition,
        triggerSize: triggerSize,
        position: widget.position,
        maxWidth: widget.maxWidth,
        backgroundColor: widget.backgroundColor ?? AppColor.inverseBackground,
        textColor: widget.textColor ?? AppColor.inverseLabelNormal,
        fadeAnimation: _fadeAnimation,
        onDismiss: _hideTooltip,
      ),
    );

    overlay.insert(_overlayEntry!);
    _animationController.forward();

    // Auto-hide after duration
    if (widget.showDuration != null) {
      _hideTimer = Timer(widget.showDuration!, _hideTooltip);
    } else {
      // Default 3 second auto-hide
      _hideTimer = Timer(const Duration(seconds: 3), _hideTooltip);
    }
  }

  void _hideTooltip() async {
    _hideTimer?.cancel();
    _hideTimer = null;

    if (!_isVisible || !mounted) return;
    _isVisible = false;

    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleTooltip() {
    if (_isVisible) {
      _hideTooltip();
    } else {
      _showTooltip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.showOnHover ? (_) => _showTooltip() : null,
      onExit: widget.showOnHover ? (_) => _hideTooltip() : null,
      child: GestureDetector(
        key: _triggerKey,
        onTap: widget.showOnTap ? _toggleTooltip : null,
        onLongPress: !widget.showOnTap ? _showTooltip : null,
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final String message;
  final Offset triggerPosition;
  final Size triggerSize;
  final AppTooltipPosition position;
  final double maxWidth;
  final Color backgroundColor;
  final Color textColor;
  final Animation<double> fadeAnimation;
  final VoidCallback onDismiss;

  const _TooltipOverlay({
    required this.message,
    required this.triggerPosition,
    required this.triggerSize,
    required this.position,
    required this.maxWidth,
    required this.backgroundColor,
    required this.textColor,
    required this.fadeAnimation,
    required this.onDismiss,
  });

  static const double _arrowHeight = 8;
  static const double _arrowWidth = 12;
  static const double _tooltipPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tap outside to dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        // Tooltip
        _buildTooltip(context),
      ],
    );
  }

  Widget _buildTooltip(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;

    final triggerCenterX = triggerPosition.dx + triggerSize.width / 2;

    // Determine position
    final showAbove = _shouldShowAbove(
      triggerPosition.dy,
      screenSize.height - screenPadding.bottom,
    );

    // Calculate tooltip position
    double tooltipLeft = triggerCenterX - maxWidth / 2;
    tooltipLeft = tooltipLeft.clamp(
      _tooltipPadding,
      screenSize.width - maxWidth - _tooltipPadding,
    );

    final double tooltipTop;
    if (showAbove) {
      tooltipTop = triggerPosition.dy - _arrowHeight - AppSpacing.xxs;
    } else {
      tooltipTop =
          triggerPosition.dy +
          triggerSize.height +
          _arrowHeight +
          AppSpacing.xxs;
    }

    // Calculate arrow position relative to tooltip
    final arrowLeft = triggerCenterX - tooltipLeft - _arrowWidth / 2;

    return Positioned(
      left: tooltipLeft,
      top: showAbove ? null : tooltipTop,
      bottom: showAbove
          ? screenSize.height -
                triggerPosition.dy +
                _arrowHeight +
                AppSpacing.xxs
          : null,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!showAbove) _buildArrow(arrowLeft, pointUp: true),
            Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: AppRadius.mdBorder,
                boxShadow: AppShadows.shadowBlackEmphasize,
              ),
              child: Text(
                message,
                style: AppTextStyles.caption1Regular.copyWith(color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            if (showAbove) _buildArrow(arrowLeft, pointUp: false),
          ],
        ),
      ),
    );
  }

  bool _shouldShowAbove(double triggerTop, double screenBottom) {
    switch (position) {
      case AppTooltipPosition.above:
        return true;
      case AppTooltipPosition.below:
        return false;
      case AppTooltipPosition.auto:
        // Show above if there's more space above than below
        final spaceAbove = triggerTop;
        final spaceBelow = screenBottom - (triggerTop + triggerSize.height);
        return spaceAbove > spaceBelow && spaceAbove > 100;
    }
  }

  Widget _buildArrow(double leftOffset, {required bool pointUp}) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftOffset.clamp(4, maxWidth - _arrowWidth - 4),
      ),
      child: CustomPaint(
        size: Size(_arrowWidth, _arrowHeight),
        painter: _ArrowPainter(color: backgroundColor, pointUp: pointUp),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final bool pointUp;

  _ArrowPainter({required this.color, required this.pointUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (pointUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.pointUp != pointUp;
  }
}
