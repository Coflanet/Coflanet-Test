import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';
import 'package:coflanet/constants/spacing_constant.dart';

/// Text field size variants
enum TextFieldSize {
  /// Small: height 40px, text body2NormalRegular
  sm,

  /// Medium: height 48px, text body1NormalRegular (default)
  md,

  /// Large: height 56px, text headline2Bold
  lg,
}

/// A custom text field widget with validation and animations.
///
/// Usage:
/// ```dart
/// // Basic text field
/// AppTextField(
///   controller: _controller,
///   hintText: '이메일을 입력하세요',
/// )
///
/// // Text field with label
/// AppTextField(
///   controller: _controller,
///   label: '이메일',
///   hintText: 'example@email.com',
/// )
///
/// // Text field with helper text
/// AppTextField(
///   controller: _controller,
///   label: '닉네임',
///   hintText: '닉네임을 입력하세요',
///   helperText: '2~10자 사이로 입력해주세요',
/// )
///
/// // Text field with error
/// AppTextField(
///   controller: _controller,
///   label: '비밀번호',
///   hintText: '비밀번호를 입력하세요',
///   errorText: '비밀번호가 일치하지 않습니다',
///   obscureText: true,
/// )
///
/// // Text field with prefix and suffix icons
/// AppTextField(
///   controller: _controller,
///   hintText: '검색어를 입력하세요',
///   prefixIcon: Icons.search,
///   suffixIcon: Icons.clear,
///   onSuffixTap: () => _controller.clear(),
/// )
///
/// // Password field with visibility toggle
/// AppTextField(
///   controller: _passwordController,
///   label: '비밀번호',
///   hintText: '비밀번호를 입력하세요',
///   obscureText: true,
///   showPasswordToggle: true,
/// )
///
/// // Multiline text field
/// AppTextField(
///   controller: _bioController,
///   label: '자기소개',
///   hintText: '자기소개를 입력하세요',
///   maxLines: 4,
///   maxLength: 200,
/// )
///
/// // Phone number input
/// AppTextField(
///   controller: _phoneController,
///   label: '전화번호',
///   hintText: '010-0000-0000',
///   keyboardType: TextInputType.phone,
///   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node for managing focus
  final FocusNode? focusNode;

  /// Label text displayed above the field
  final String? label;

  /// Hint text displayed when field is empty
  final String? hintText;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error text displayed below the field (overrides helper)
  final String? errorText;

  /// Whether the field is enabled
  final bool isEnabled;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Whether to show password visibility toggle
  final bool showPasswordToggle;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Custom prefix widget
  final Widget? prefix;

  /// Custom suffix widget
  final Widget? suffix;

  /// Callback when suffix icon is tapped
  final VoidCallback? onSuffixTap;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when editing is complete
  final VoidCallback? onEditingComplete;

  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum length of text
  final int? maxLength;

  /// Maximum lines for multiline input
  final int maxLines;

  /// Minimum lines for multiline input
  final int? minLines;

  /// Whether to expand to fill available space
  final bool expands;

  /// Whether to auto-focus on mount
  final bool autofocus;

  /// Whether the field is read-only
  final bool readOnly;

  /// Custom validator function
  final String? Function(String?)? validator;

  /// Text capitalization behavior
  final TextCapitalization textCapitalization;

  /// Auto-correct behavior
  final bool autocorrect;

  /// Enable suggestions
  final bool enableSuggestions;

  /// Text field size variant
  final TextFieldSize size;

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
    this.prefix,
    this.suffix,
    this.onSuffixTap,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.autofocus = false,
    this.readOnly = false,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.size = TextFieldSize.md,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late bool _hasFocus;
  late bool _isObscured;
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;
  bool get _isDisabled => !widget.isEnabled;

  double get _height {
    switch (widget.size) {
      case TextFieldSize.sm:
        return 40;
      case TextFieldSize.md:
        return 48;
      case TextFieldSize.lg:
        return 56;
    }
  }

  TextStyle get _textStyle {
    switch (widget.size) {
      case TextFieldSize.sm:
        return AppTextStyles.body2NormalRegular;
      case TextFieldSize.md:
        return AppTextStyles.body1NormalRegular;
      case TextFieldSize.lg:
        return AppTextStyles.headline2Bold;
    }
  }

  EdgeInsets get _contentPadding {
    switch (widget.size) {
      case TextFieldSize.sm:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case TextFieldSize.md:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        );
      case TextFieldSize.lg:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _hasFocus = _focusNode.hasFocus;
    _isObscured = widget.obscureText;

    _focusNode.addListener(_handleFocusChange);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    if (_hasFocus) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });

    if (_hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          SizedBox(height: AppSpacing.xs),
        ],
        _buildTextField(),
        if (_hasError || widget.helperText != null) ...[
          SizedBox(height: AppSpacing.xxs),
          _buildHelperOrError(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    final color = _isDisabled ? AppColor.labelDisable : AppColor.labelNormal;

    return Text(
      widget.label!,
      style: AppTextStyles.label1NormalMedium.copyWith(color: color),
    );
  }

  Widget _buildTextField() {
    return SizedBox(
      height: _height,
      child: AnimatedBuilder(
        animation: _borderAnimation,
        builder: (context, child) {
          final Color borderColor;
          final Color fillColor;

          if (_isDisabled) {
            borderColor = AppColor.lineNormalAlternative;
            fillColor = AppColor.interactionDisable;
          } else if (_hasError) {
            borderColor = AppColor.statusNegative;
            fillColor = AppColor.componentFillNormal;
          } else if (_hasFocus) {
            borderColor = Color.lerp(
              AppColor.lineNormalNormal,
              AppColor.primaryNormal,
              _borderAnimation.value,
            )!;
            fillColor = AppColor.backgroundNormalNormal;
          } else {
            borderColor = AppColor.lineNormalNormal;
            fillColor = AppColor.componentFillNormal;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: AppRadius.inputBorder,
              border: Border.all(
                color: borderColor,
                width: _hasFocus && !_hasError && !_isDisabled ? 1.5 : 1.0,
              ),
              boxShadow: _hasFocus && !_isDisabled && !_hasError
                  ? [
                      BoxShadow(
                        color: AppColor.primaryNormal.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: child,
          );
        },
        child: _buildTextFieldContent(),
      ),
    );
  }

  Widget _buildTextFieldContent() {
    final textColor = _isDisabled
        ? AppColor.labelDisable
        : AppColor.labelNormal;
    final hintColor = AppColor.labelAssistive;
    final cursorColor = _hasError
        ? AppColor.statusNegative
        : AppColor.primaryNormal;

    return TextField(
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
      expands: widget.expands,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      style: _textStyle.copyWith(color: textColor),
      cursorColor: cursorColor,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body1NormalRegular.copyWith(color: hintColor),
        isDense: true,
        contentPadding: _contentPadding,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        counterText: '',
        prefixIcon: _buildPrefixIcon(),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        suffixIcon: _buildSuffixIcon(),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefix != null) {
      return Padding(
        padding: EdgeInsets.only(left: AppSpacing.sm),
        child: widget.prefix,
      );
    }

    if (widget.prefixIcon != null) {
      final iconColor = _isDisabled
          ? AppColor.labelDisable
          : AppColor.labelAlternative;

      return Icon(widget.prefixIcon, size: 20, color: iconColor);
    }

    return null;
  }

  Widget? _buildSuffixIcon() {
    // Password visibility toggle takes precedence
    if (widget.showPasswordToggle && widget.obscureText) {
      final iconColor = _isDisabled
          ? AppColor.labelDisable
          : AppColor.labelAlternative;

      return GestureDetector(
        onTap: _isDisabled ? null : _toggleObscure,
        child: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: iconColor,
        ),
      );
    }

    if (widget.suffix != null) {
      return Padding(
        padding: EdgeInsets.only(right: AppSpacing.sm),
        child: widget.suffix,
      );
    }

    if (widget.suffixIcon != null) {
      final iconColor = _isDisabled
          ? AppColor.labelDisable
          : AppColor.labelAlternative;

      return GestureDetector(
        onTap: _isDisabled ? null : widget.onSuffixTap,
        child: Icon(widget.suffixIcon, size: 20, color: iconColor),
      );
    }

    return null;
  }

  Widget _buildHelperOrError() {
    if (_hasError) {
      return Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 14,
            color: AppColor.statusNegative,
          ),
          SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              widget.errorText!,
              style: AppTextStyles.caption1Regular.copyWith(
                color: AppColor.statusNegative,
              ),
            ),
          ),
        ],
      );
    }

    if (widget.helperText != null) {
      return Text(
        widget.helperText!,
        style: AppTextStyles.caption1Regular.copyWith(
          color: AppColor.labelAlternative,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// A search text field variant with search icon and clear button.
///
/// Usage:
/// ```dart
/// AppSearchField(
///   controller: _searchController,
///   hintText: '커피 레시피 검색',
///   onChanged: (value) => _filterResults(value),
///   onClear: () => _clearSearch(),
/// )
/// ```
class AppSearchField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;

  /// Hint text
  final String? hintText;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when clear button is tapped
  final VoidCallback? onClear;

  /// Whether the field is enabled
  final bool isEnabled;

  /// Whether to auto-focus on mount
  final bool autofocus;

  /// Text field size variant
  final TextFieldSize size;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.isEnabled = true,
    this.autofocus = false,
    this.size = TextFieldSize.md,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      hintText: widget.hintText ?? '검색',
      isEnabled: widget.isEnabled,
      autofocus: widget.autofocus,
      prefixIcon: Icons.search_rounded,
      suffixIcon: _hasText ? Icons.close_rounded : null,
      onSuffixTap: _handleClear,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      size: widget.size,
    );
  }
}
