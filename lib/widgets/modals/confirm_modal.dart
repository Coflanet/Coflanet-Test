import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// A modal for confirmation/alert dialogs.
///
/// Usage:
/// ```dart
/// final confirmed = await ConfirmModal.show(
///   title: '확인',
///   message: '정말 삭제하시겠습니까?',
///   confirmText: '삭제',
///   cancelText: '취소',
///   isDestructive: true,
/// );
/// ```
class ConfirmModal extends StatefulWidget {
  final String title;
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final bool isDestructive;
  final bool showCancelButton;
  final bool barrierDismissible;
  final Widget? icon;

  const ConfirmModal({
    super.key,
    required this.title,
    this.message,
    this.confirmText,
    this.cancelText,
    this.isDestructive = false,
    this.showCancelButton = true,
    this.barrierDismissible = true,
    this.icon,
  });

  /// Shows the confirm modal and returns true if confirmed, false if cancelled.
  /// Returns null if dismissed by tapping outside.
  static Future<bool?> show({
    required String title,
    String? message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
    bool showCancelButton = true,
    bool barrierDismissible = true,
    Widget? icon,
  }) async {
    return Get.dialog<bool?>(
      ConfirmModal(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        showCancelButton: showCancelButton,
        barrierDismissible: barrierDismissible,
        icon: icon,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColorScheme.of(Get.context!).componentMaterialDimmer,
    );
  }

  /// Shows an alert modal with only a confirm button.
  static Future<bool?> alert({
    required String title,
    String? message,
    String? confirmText,
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return show(
      title: title,
      message: message,
      confirmText: confirmText ?? '확인',
      showCancelButton: false,
      barrierDismissible: barrierDismissible,
      icon: icon,
    );
  }

  @override
  State<ConfirmModal> createState() => _ConfirmModalState();
}

class _ConfirmModalState extends State<ConfirmModal>
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

  void _onConfirm() {
    Get.back(result: true);
  }

  void _onCancel() {
    Get.back(result: false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    // Get.dialog 는 Material 조상을 제공하지 않으므로 직접 감싼다 —
    // 없으면 모든 Text 에 노란 이중 밑줄이 그려진다.
    return Material(
      type: MaterialType.transparency,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                borderRadius: AppRadius.modalBorder,
                boxShadow: AppShadows.shadowBlackHeavy,
                // 다크 모드는 검정 그림자가 어두운 배경에 흡수되어 카드 경계가
                // 약해지므로 1px 보더로 경계를 보강한다. 라이트 외형은 불변.
                border: Theme.of(context).brightness == Brightness.dark
                    ? Border.all(color: colors.lineSolidNormal, width: 1)
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [_buildContent(colors), _buildActions()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(height: 16),
          ],
          Text(
            widget.title,
            style: AppTextStyles.heading1Bold.copyWith(
              color: colors.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.message!,
              style: AppTextStyles.body1NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: widget.showCancelButton
          ? Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    text: widget.cancelText ?? '취소',
                    onPressed: _onCancel,
                    type: _ButtonType.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    text: widget.confirmText ?? '확인',
                    onPressed: _onConfirm,
                    type: widget.isDestructive
                        ? _ButtonType.destructive
                        : _ButtonType.primary,
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: _ActionButton(
                text: widget.confirmText ?? '확인',
                onPressed: _onConfirm,
                type: widget.isDestructive
                    ? _ButtonType.destructive
                    : _ButtonType.primary,
              ),
            ),
    );
  }
}

enum _ButtonType { primary, secondary, destructive }

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final _ButtonType type;

  const _ActionButton({
    required this.text,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
    switch (type) {
      case _ButtonType.primary:
        return SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryNormal,
              foregroundColor: AppColor.staticLabelWhiteStrong,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonBorder,
              ),
            ),
            child: Text(text, style: AppTextStyles.headline2Bold),
          ),
        );

      case _ButtonType.destructive:
        return SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.statusNegative,
              foregroundColor: AppColor.staticLabelWhiteStrong,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonBorder,
              ),
            ),
            child: Text(text, style: AppTextStyles.headline2Bold),
          ),
        );

      case _ButtonType.secondary:
        return SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.labelNormal,
              side: BorderSide(color: colors.lineNormalNormal),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonBorder,
              ),
            ),
            child: Text(text, style: AppTextStyles.headline2Bold),
          ),
        );
    }
  }
}
