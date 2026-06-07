import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Result of the unsaved changes modal interaction.
enum UnsavedChangesResult {
  /// User chose to continue editing
  continueEditing,

  /// User chose to discard changes and exit
  discardAndExit,
}

/// A modal for warning users about unsaved changes.
///
/// Figma Design: Alert Dialog with destructive action
/// - White rounded rectangle with shadow (16-20px radius)
/// - No icon (clean, minimal design)
/// - Horizontal button layout (side by side)
/// - Secondary (gray pill) + Destructive (red filled) buttons
///
/// Usage:
/// ```dart
/// final result = await UnsavedChangesModal.show();
/// if (result == UnsavedChangesResult.discardAndExit) {
///   Get.back(); // Exit the screen
/// }
/// // If continueEditing, do nothing (user stays on screen)
/// ```
class UnsavedChangesModal extends StatefulWidget {
  final String? title;
  final String? message;
  final String? continueText;
  final String? exitText;
  final bool barrierDismissible;

  const UnsavedChangesModal({
    super.key,
    this.title,
    this.message,
    this.continueText,
    this.exitText,
    this.barrierDismissible = false,
  });

  /// Shows the unsaved changes modal and returns the user's choice.
  /// Returns null if dismissed by tapping outside (when barrierDismissible is true).
  static Future<UnsavedChangesResult?> show({
    String? title,
    String? message,
    String? continueText,
    String? exitText,
    bool barrierDismissible = false,
  }) async {
    return Get.dialog<UnsavedChangesResult?>(
      UnsavedChangesModal(
        title: title,
        message: message,
        continueText: continueText,
        exitText: exitText,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColorScheme.of(Get.context!).componentMaterialDimmer,
    );
  }

  @override
  State<UnsavedChangesModal> createState() => _UnsavedChangesModalState();
}

class _UnsavedChangesModalState extends State<UnsavedChangesModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  void _onContinueEditing() {
    Get.back(result: UnsavedChangesResult.continueEditing);
  }

  void _onDiscardAndExit() {
    Get.back(result: UnsavedChangesResult.discardAndExit);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            decoration: BoxDecoration(
              color: colors.backgroundElevatedNormal,
              borderRadius: AppRadius.xlBorder,
              boxShadow: AppShadows.shadowBlackHeavy,
              // 다크 모드는 검정 그림자가 어두운 배경에 흡수되어 카드 경계가
              // 약해지므로 1px 보더로 경계를 보강한다. 라이트 외형은 불변.
              border: Theme.of(context).brightness == Brightness.dark
                  ? Border.all(color: colors.lineSolidNormal, width: 1)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildContent(colors), _buildActions(colors)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppColorScheme colors) {
    // Figma: No icon, just title and message centered
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title - Figma: 18-20px Bold/SemiBold, #1A1A1A, center aligned
          Text(
            widget.title ?? '편집 내용이 저장되지 않았어요',
            style: AppTextStyles.title2Bold.copyWith(
              color: colors.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Message - Figma: 14-16px Regular, gray (#666666), center aligned
          Text(
            widget.message ?? '저장하지 않고 나가시겠어요?',
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: colors.labelAlternative,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AppColorScheme colors) {
    // Figma: Horizontal button layout, equal width, 12-16px gap
    // Left: Secondary (gray), Right: Destructive (red)
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          // Secondary button - Figma: gray background (#F5F5F5), dark text, pill shape
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _onContinueEditing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.componentFillNormal,
                  foregroundColor: colors.labelNormal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.xxxlBorder,
                  ),
                ),
                child: Text(
                  widget.continueText ?? '편집 계속하기',
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: colors.labelNormal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Destructive button - Figma: red background (#FF4D4D), white text, pill shape
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _onDiscardAndExit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.statusNegative,
                  foregroundColor: AppColor.staticLabelWhiteStrong,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.xxxlBorder,
                  ),
                ),
                child: Text(
                  widget.exitText ?? '나가기',
                  style: AppTextStyles.headline2Bold.copyWith(
                    color: AppColor.staticLabelWhiteStrong,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
