import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// TextField 사이즈 변형.
enum AppTextFieldSize {
  /// 40px height — body2NormalRegular
  sm,

  /// 48px height — body1NormalRegular (default)
  md,

  /// 56px height — headline2Bold
  lg,
}

/// 디자인 시스템 표준 TextField.
///
/// ```dart
/// AppTextField(
///   controller: _ctrl,
///   label: '이메일',
///   hintText: 'name@example.com',
///   prefixIcon: Icons.email_outlined,
/// )
/// ```
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isEnabled;
  final bool obscureText;
  final bool showPasswordToggle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool autofocus;
  final bool readOnly;
  final AppTextFieldSize size;

  /// 멀티라인일 때 글자 수 카운터 표시 여부 (`maxLength` 설정 시에만 유효).
  final bool showCounter;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.isEnabled = true,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.readOnly = false,
    this.size = AppTextFieldSize.md,
    this.showCounter = false,
  });

  /// Multiline (Text Area) factory — Figma `Text Area/*`.
  ///
  /// `maxLines`/`minLines`/`maxLength`+counter를 한 번에 켠다.
  /// 기본 4줄, 글자수 표시 on.
  factory AppTextField.multiline({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? hintText,
    String? helperText,
    String? errorText,
    bool isEnabled = true,
    ValueChanged<String>? onChanged,
    int minLines = 4,
    int maxLines = 8,
    int? maxLength,
    bool autofocus = false,
    AppTextFieldSize size = AppTextFieldSize.md,
    bool showCounter = true,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      isEnabled: isEnabled,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      autofocus: autofocus,
      size: size,
      showCounter: showCounter,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() => _hasFocus = _focusNode.hasFocus);
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  double get _height {
    switch (widget.size) {
      case AppTextFieldSize.sm:
        return 40;
      case AppTextFieldSize.md:
        return 48;
      case AppTextFieldSize.lg:
        return 56;
    }
  }

  TextStyle get _textStyle {
    switch (widget.size) {
      case AppTextFieldSize.sm:
        return AppTextStyles.body2NormalRegular;
      case AppTextFieldSize.md:
        return AppTextStyles.body1NormalRegular;
      case AppTextFieldSize.lg:
        return AppTextStyles.headline2Bold;
    }
  }

  EdgeInsets get _contentPadding => const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      );

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final labelColor = c.labelNormal;
    final altColor = c.labelAlternative;
    final errorColor = c.statusNegative;
    final fillColor = c.componentFillNormal;
    final disabledFill = c.interactionDisable;
    final primaryColor = c.primaryNormal;

    final borderColor = !widget.isEnabled
        ? Colors.transparent
        : _hasError
            ? errorColor
            : _hasFocus
                ? primaryColor
                : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label2Medium.copyWith(color: labelColor),
          ),
          const SizedBox(height: AppSpacing.space8),
        ],
        SizedBox(
          height: widget.maxLines > 1 ? null : _height,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.isEnabled,
            obscureText: _isObscured,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: _textStyle.copyWith(
              color: widget.isEnabled ? labelColor : c.labelDisable,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: widget.isEnabled ? fillColor : disabledFill,
              hintText: widget.hintText,
              hintStyle: _textStyle.copyWith(color: altColor),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 20, color: altColor)
                  : null,
              suffixIcon: _buildSuffixIcon(altColor, errorColor),
              contentPadding: _contentPadding,
              counterText: widget.showCounter ? null : '',
              counterStyle: AppTextStyles.caption1Regular.copyWith(
                color: altColor,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.radiusInputBorder,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusInputBorder,
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusInputBorder,
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusInputBorder,
                borderSide: BorderSide(color: errorColor, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.radiusInputBorder,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (_hasError || widget.helperText != null) ...[
          const SizedBox(height: AppSpacing.space4),
          Text(
            _hasError ? widget.errorText! : widget.helperText!,
            style: AppTextStyles.caption1Regular.copyWith(
              color: _hasError ? errorColor : altColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon(Color altColor, Color errorColor) {
    if (widget.showPasswordToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: altColor,
        ),
        onPressed: () => setState(() => _isObscured = !_isObscured),
      );
    }
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, size: 20, color: altColor),
        onPressed: widget.onSuffixTap,
      );
    }
    return null;
  }
}
