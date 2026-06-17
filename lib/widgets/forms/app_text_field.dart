import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
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

  /// 단일 줄 여부 — 멀티라인([maxLines] > 1)이나 [expands] 가 아니면 단일 줄이다.
  /// (비밀번호 필드는 항상 단일 줄)
  bool get _isSingleLine {
    if (widget.obscureText) return true;
    if (widget.expands) return false;
    return widget.maxLines == 1;
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
    final colors = AppColorScheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _buildLabel(colors),
          SizedBox(height: AppSpacing.xs),
        ],
        _buildTextField(colors),
        if (_hasError || widget.helperText != null) ...[
          SizedBox(height: AppSpacing.xxs),
          _buildHelperOrError(colors),
        ],
      ],
    );
  }

  Widget _buildLabel(AppColorScheme colors) {
    final color = _isDisabled ? colors.labelDisable : colors.labelNormal;

    return Text(
      widget.label!,
      style: AppTextStyles.label1NormalMedium.copyWith(color: color),
    );
  }

  Widget _buildTextField(AppColorScheme colors) {
    return SizedBox(
      height: _height,
      child: AnimatedBuilder(
        animation: _borderAnimation,
        builder: (context, child) {
          final Color borderColor;
          final Color fillColor;

          if (_isDisabled) {
            borderColor = colors.lineNormalAlternative;
            fillColor = colors.interactionDisable;
          } else if (_hasError) {
            borderColor = colors.statusNegative;
            fillColor = colors.componentFillNormal;
          } else if (_hasFocus) {
            borderColor = Color.lerp(
              colors.lineNormalNormal,
              colors.primaryNormal,
              _borderAnimation.value,
            )!;
            fillColor = colors.backgroundNormalNormal;
          } else {
            borderColor = colors.lineNormalNormal;
            fillColor = colors.componentFillNormal;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            // 세로 정렬은 자식([_buildTextFieldContent])이 담당하므로 컨테이너는
            // alignment 로 개입하지 않는다(자식에 고정 높이 [_height] 제약을 그대로
            // 전달). 자식 분기:
            //  - 단일 줄: [Row(crossAxisAlignment.center)] 가 줄 박스를 세로 중앙에.
            //  - 멀티라인/expands: [TextField] 가 박스를 위에서부터 채운다(top-anchor).
            // (alignment: center 를 주면 멀티라인 [TextField] 가 자기 높이로 줄어들어
            // expands/top-anchor 동작이 깨지므로 의도적으로 생략한다.)
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
                        color: colors.primaryNormal.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: child,
          );
        },
        child: _buildTextFieldContent(colors),
      ),
    );
  }

  Widget _buildTextFieldContent(AppColorScheme colors) {
    final textColor = _isDisabled ? colors.labelDisable : colors.labelNormal;
    final hintColor = colors.labelAssistive;
    final cursorColor = _hasError
        ? colors.statusNegative
        : colors.primaryNormal;

    // 단일 줄에서는 디자인 토큰의 line-height(height 1.4~1.6)를 1.0 으로 눌러
    // 텍스트의 '줄 박스'를 글리프 박스와 같게 만든다. 이렇게 해야 바깥 레이아웃
    // ([Row] crossAxis center)가 줄 박스를 중앙에 둘 때 '글리프'도 정확히 중앙에
    // 온다. (height 1.5 인 줄 박스는 leading 이 baseline 위/아래로 비대칭 분배되어
    // 줄 박스를 중앙에 둬도 글리프가 사이즈별로 위/아래로 어긋나는 원인이 된다.)
    // 멀티라인은 가독성을 위해 토큰 line-height 를 그대로 유지한다.
    final inputStyle = _isSingleLine
        ? _textStyle.copyWith(color: textColor, height: 1.0)
        : _textStyle.copyWith(color: textColor);

    // hint 스타일은 입력 텍스트와 동일한 메트릭(폰트 크기/높이)을 사용해야
    // 빈 필드의 hint 와 입력된 텍스트가 같은 세로 위치에 놓인다.
    // (기존에는 size 와 무관하게 body1 로 고정되어 sm/lg 에서 hint 가 어긋났다.)
    final hintStyle = _isSingleLine
        ? _textStyle.copyWith(color: hintColor, height: 1.0)
        : _textStyle.copyWith(color: hintColor);

    // strut 을 글리프 박스에 고정해 한글/영문/숫자 등 문자 구성에 관계없이
    // 줄 높이가 흔들리지 않도록 한다(단일 줄 중앙 정렬 안정화).
    final strutStyle = _isSingleLine
        ? StrutStyle(
            fontFamily: _textStyle.fontFamily,
            fontSize: _textStyle.fontSize,
            height: 1.0,
            forceStrutHeight: true,
          )
        : null;

    // 입력 필드 본체. 단일 줄/멀티라인 모두 [TextField] 의 데코레이션은
    // 테두리 없이 hint 만 담당하고, 세로 정렬은 바깥 레이아웃이 결정한다.
    final textField = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.isEnabled,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: _isSingleLine ? null : widget.minLines,
      expands: widget.expands,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      style: inputStyle,
      strutStyle: strutStyle,
      cursorColor: cursorColor,
      // 멀티라인은 위에서부터 채우고(top), 단일 줄은 바깥 [Row] 가 줄 박스를
      // 세로 중앙에 배치하므로 데코레이터 자체 정렬은 사용하지 않는다.
      textAlignVertical: _isSingleLine ? null : TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: hintStyle,
        // isCollapsed: InputDecorator 의 기본 세로 패딩/라벨 baseline 예약을 제거해
        // 데코레이터 높이를 '입력 줄 박스' 높이로 정확히 축소한다. 가로 패딩만 직접
        // 부여하고, 단일 줄 세로 정렬은 바깥 [Row] 가 결정론적으로 처리한다.
        // (멀티라인은 [_multiLineContentPadding] 으로 상하 여백을 부여)
        isCollapsed: true,
        contentPadding: _isSingleLine
            ? _singleLineTextPadding
            : _multiLineContentPadding,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        // 채움색은 바깥 AnimatedContainer 가 담당한다. 테마의 InputDecorationTheme
        // (filled: true)가 새어들어 텍스트 영역에만 채움이 한 번 더 겹쳐 그 부분만
        // 진해 보이는 문제를 막기 위해 명시적으로 끈다.
        filled: false,
        counterText: '',
      ),
    );

    // 멀티라인/expands: 고정 높이 박스를 위에서부터 채운다(정상 동작).
    // [_multiLineContentPadding] 의 가로 패딩이 좌우 여백을 담당하므로 [Row] 불필요.
    if (!_isSingleLine) {
      return textField;
    }

    // 단일 줄: [Row(crossAxisAlignment.center)] 로 아이콘과 입력 줄 박스를
    // 고정 높이([_height]) 박스 안에서 결정론적으로 세로 중앙에 배치한다.
    // (InputDecorator 의 textAlignVertical 에 의존하지 않으므로 사이즈(sm/md/lg)·
    // 구성(bare/prefix/suffix/toggle)과 무관하게 동일하게 동작한다.)
    final prefixWidget = _buildPrefixWidget(colors);
    final suffixWidget = _buildSuffixWidget(colors);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        prefixWidget ?? SizedBox(width: AppSpacing.md),
        Expanded(child: textField),
        suffixWidget ?? SizedBox(width: AppSpacing.md),
      ],
    );
  }

  /// 단일 줄 입력 텍스트의 가로 패딩. 좌우 끝은 [Row] 가 아이콘/여백([AppSpacing.md])
  /// 으로 처리하므로 텍스트 자체에는 추가 가로 패딩을 두지 않는다(0).
  /// 세로 패딩도 0 — 중앙 정렬은 [Row] 가 담당한다.
  EdgeInsets get _singleLineTextPadding => EdgeInsets.zero;

  /// 멀티라인 입력의 내용 패딩. 고정 높이 박스를 위에서부터 채우되 좌우/상하 여백을 둔다.
  EdgeInsets get _multiLineContentPadding =>
      EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm);

  /// 단일 줄 모드의 선행(prefix) 위젯. 아이콘은 48dp 폭 슬롯에 중앙 정렬하여
  /// 기존 [prefixIconConstraints] minWidth 48 동작을 유지한다. 세로 중앙 정렬은
  /// 바깥 [Row] 가 담당하므로 여기서는 가로 슬롯/여백만 책임진다.
  Widget? _buildPrefixWidget(AppColorScheme colors) {
    if (widget.prefix != null) {
      return Padding(
        padding: EdgeInsets.only(left: AppSpacing.sm),
        child: widget.prefix,
      );
    }

    if (widget.prefixIcon != null) {
      final iconColor = _isDisabled
          ? colors.labelDisable
          : colors.labelAlternative;

      return SizedBox(
        width: 48,
        child: Center(
          widthFactor: 1.0,
          child: Icon(widget.prefixIcon, size: 20, color: iconColor),
        ),
      );
    }

    return null;
  }

  /// 단일 줄 모드의 후행(suffix) 위젯. 비밀번호 토글 > 커스텀 suffix > suffixIcon 순.
  /// 세로 중앙 정렬은 바깥 [Row] 가 담당한다.
  Widget? _buildSuffixWidget(AppColorScheme colors) {
    // Password visibility toggle takes precedence
    if (widget.showPasswordToggle && widget.obscureText) {
      final iconColor = _isDisabled
          ? colors.labelDisable
          : colors.labelAlternative;

      return SizedBox(
        width: 48,
        child: Center(
          widthFactor: 1.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isDisabled ? null : _toggleObscure,
            child: Icon(
              _isObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: iconColor,
            ),
          ),
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
          ? colors.labelDisable
          : colors.labelAlternative;

      return SizedBox(
        width: 48,
        child: Center(
          widthFactor: 1.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isDisabled ? null : widget.onSuffixTap,
            child: Icon(widget.suffixIcon, size: 20, color: iconColor),
          ),
        ),
      );
    }

    return null;
  }

  Widget _buildHelperOrError(AppColorScheme colors) {
    if (_hasError) {
      return Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 14,
            color: colors.statusNegative,
          ),
          SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              widget.errorText!,
              style: AppTextStyles.caption1Regular.copyWith(
                color: colors.statusNegative,
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
          color: colors.labelAlternative,
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
