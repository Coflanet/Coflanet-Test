import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// A modal for text/number input with validation support.
///
/// Usage:
/// ```dart
/// final result = await InputModal.show(
///   title: '값 입력',
///   hint: '숫자를 입력하세요',
///   initialValue: '10',
///   keyboardType: TextInputType.number,
///   validator: (value) => value.isEmpty ? '값을 입력하세요' : null,
/// );
/// ```
class InputModal extends StatefulWidget {
  final String title;
  final String? message;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int maxLines;
  final String? confirmText;
  final String? cancelText;
  final bool barrierDismissible;
  final List<TextInputFormatter>? inputFormatters;

  const InputModal({
    super.key,
    required this.title,
    this.message,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.confirmText,
    this.cancelText,
    this.barrierDismissible = true,
    this.inputFormatters,
  });

  /// Shows the input modal and returns the entered value.
  /// Returns null if cancelled.
  static Future<String?> show({
    required String title,
    String? message,
    String? hint,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
    int maxLines = 1,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
    List<TextInputFormatter>? inputFormatters,
  }) async {
    return Get.dialog<String?>(
      InputModal(
        title: title,
        message: message,
        hint: hint,
        initialValue: initialValue,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
        confirmText: confirmText,
        cancelText: cancelText,
        barrierDismissible: barrierDismissible,
        inputFormatters: inputFormatters,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColor.componentMaterialDimmer,
    );
  }

  @override
  State<InputModal> createState() => _InputModalState();
}

class _InputModalState extends State<InputModal>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _errorText;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

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

    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final value = _controller.text;

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) {
        setState(() {
          _errorText = error;
        });
        return;
      }
    }

    Get.back(result: value);
  }

  void _onCancel() {
    Get.back(result: null);
  }

  void _onTextChanged(String value) {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: AppColor.backgroundElevatedNormal,
                borderRadius: AppRadius.modalBorder,
                boxShadow: AppShadows.shadowBlackHeavy,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  if (widget.message != null) _buildMessage(),
                  _buildTextField(),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        widget.title,
        style: AppTextStyles.heading1Bold.copyWith(color: AppColor.labelNormal),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Text(
        widget.message!,
        style: AppTextStyles.body2NormalRegular.copyWith(
          color: AppColor.labelAlternative,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.componentFillNormal,
              borderRadius: AppRadius.buttonBorder,
              border: Border.all(
                color: _errorText != null
                    ? AppColor.statusNegative
                    : _focusNode.hasFocus
                    ? AppColor.primaryNormal
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              onChanged: _onTextChanged,
              onSubmitted: (_) => _onConfirm(),
              style: AppTextStyles.body1NormalMedium.copyWith(
                color: AppColor.labelNormal,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.body1NormalRegular.copyWith(
                  color: AppColor.labelAssistive,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                counterText: '',
              ),
            ),
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 14,
                    color: AppColor.statusNegative,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _errorText!,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.statusNegative,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
