import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// A customizable bottom sheet with drag handle, optional title, and scrollable content.
///
/// Features:
/// - Drag handle for intuitive interaction
/// - Optional title with close button
/// - Scrollable content area
/// - Optional action buttons at bottom
/// - Slide-up animation with spring physics
///
/// Usage:
/// ```dart
/// // Simple usage
/// AppBottomSheet.show(
///   title: '옵션 선택',
///   child: ListView(
///     shrinkWrap: true,
///     children: [...],
///   ),
/// );
///
/// // With action buttons
/// AppBottomSheet.show(
///   title: '필터',
///   child: FilterContent(),
///   primaryActionText: '적용',
///   onPrimaryAction: () {
///     // Apply filter
///     Get.back();
///   },
///   secondaryActionText: '초기화',
///   onSecondaryAction: () {
///     // Reset filter
///   },
/// );
///
/// // Full height with custom constraints
/// AppBottomSheet.show(
///   child: FullContent(),
///   maxHeight: 0.9, // 90% of screen height
///   isScrollable: true,
/// );
/// ```
class AppBottomSheet extends StatefulWidget {
  /// Title displayed in the header. If null, header shows only drag handle.
  final String? title;

  /// The main content of the bottom sheet
  final Widget child;

  /// Whether to show the close button in header
  final bool showCloseButton;

  /// Whether the content should be scrollable
  final bool isScrollable;

  /// Maximum height as a fraction of screen height (0.0 to 1.0)
  final double maxHeight;

  /// Whether tapping outside dismisses the sheet
  final bool isDismissible;

  /// Whether the sheet can be dragged to dismiss
  final bool enableDrag;

  /// Primary action button text
  final String? primaryActionText;

  /// Primary action callback
  final VoidCallback? onPrimaryAction;

  /// Secondary action button text
  final String? secondaryActionText;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  /// Whether the primary action is destructive (shows red)
  final bool isDestructive;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showCloseButton = true,
    this.isScrollable = true,
    this.maxHeight = 0.85,
    this.isDismissible = true,
    this.enableDrag = true,
    this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.isDestructive = false,
  });

  /// Shows the bottom sheet and returns the result
  static Future<T?> show<T>({
    String? title,
    required Widget child,
    bool showCloseButton = true,
    bool isScrollable = true,
    double maxHeight = 0.85,
    bool isDismissible = true,
    bool enableDrag = true,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool isDestructive = false,
  }) {
    return Get.bottomSheet<T>(
      AppBottomSheet(
        title: title,
        child: child,
        showCloseButton: showCloseButton,
        isScrollable: isScrollable,
        maxHeight: maxHeight,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        primaryActionText: primaryActionText,
        onPrimaryAction: onPrimaryAction,
        secondaryActionText: secondaryActionText,
        onSecondaryAction: onSecondaryAction,
        isDestructive: isDestructive,
      ),
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.componentMaterialDimmer,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleClose() {
    Get.back();
  }

  bool get _hasActions =>
      widget.primaryActionText != null || widget.secondaryActionText != null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * widget.maxHeight,
          ),
          decoration: BoxDecoration(
            color: AppColor.backgroundElevatedNormal,
            borderRadius: AppRadius.top(AppRadius.xxl),
            boxShadow: AppShadows.shadowBlackHeavy,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              if (widget.title != null) _buildHeader(),
              Flexible(
                child: widget.isScrollable
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          bottom: _hasActions ? AppSpacing.sm : AppSpacing.lg,
                        ),
                        child: widget.child,
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          bottom: _hasActions ? AppSpacing.sm : AppSpacing.lg,
                        ),
                        child: widget.child,
                      ),
              ),
              if (_hasActions) _buildActions(bottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColor.lineNormalNormal,
            borderRadius: AppRadius.fullBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: widget.showCloseButton ? AppSpacing.xs : AppSpacing.lg,
        bottom: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.title!,
              style: AppTextStyles.heading1Bold.copyWith(
                color: AppColor.labelNormal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.showCloseButton) _CloseButton(onPressed: _handleClose),
        ],
      ),
    );
  }

  Widget _buildActions(double bottomPadding) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: AppSpacing.md + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedNormal,
        border: Border(
          top: BorderSide(color: AppColor.lineNormalAlternative, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (widget.secondaryActionText != null) ...[
            Expanded(
              child: _ActionButton(
                text: widget.secondaryActionText!,
                onPressed: widget.onSecondaryAction ?? () => Get.back(),
                type: _ActionButtonType.secondary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
          ],
          if (widget.primaryActionText != null)
            Expanded(
              flex: widget.secondaryActionText != null ? 1 : 0,
              child: widget.secondaryActionText != null
                  ? _ActionButton(
                      text: widget.primaryActionText!,
                      onPressed: widget.onPrimaryAction ?? () => Get.back(),
                      type: widget.isDestructive
                          ? _ActionButtonType.destructive
                          : _ActionButtonType.primary,
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: _ActionButton(
                        text: widget.primaryActionText!,
                        onPressed: widget.onPrimaryAction ?? () => Get.back(),
                        type: widget.isDestructive
                            ? _ActionButtonType.destructive
                            : _ActionButtonType.primary,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.fullBorder,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xs),
          child: Icon(
            Icons.close_rounded,
            size: 24,
            color: AppColor.labelAlternative,
          ),
        ),
      ),
    );
  }
}

enum _ActionButtonType { primary, secondary, destructive }

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final _ActionButtonType type;

  const _ActionButton({
    required this.text,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _ActionButtonType.primary:
        return SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryNormal,
              foregroundColor: AppColor.staticLabelWhiteStrong,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
            ),
            child: Text(
              text,
              style: AppTextStyles.headline2Bold.copyWith(
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),
        );

      case _ActionButtonType.destructive:
        return SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.statusNegative,
              foregroundColor: AppColor.staticLabelWhiteStrong,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
            ),
            child: Text(
              text,
              style: AppTextStyles.headline2Bold.copyWith(
                color: AppColor.staticLabelWhiteStrong,
              ),
            ),
          ),
        );

      case _ActionButtonType.secondary:
        return SizedBox(
          height: 52,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.labelNormal,
              side: BorderSide(color: AppColor.lineNormalNormal),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
            ),
            child: Text(
              text,
              style: AppTextStyles.headline2Bold.copyWith(
                color: AppColor.labelNormal,
              ),
            ),
          ),
        );
    }
  }
}
