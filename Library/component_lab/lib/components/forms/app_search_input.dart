import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// 검색 입력 — Figma `Search Input/*`.
///
/// `AppTextField`를 composition으로 활용한 표준 검색 입력.
/// leading 돋보기 아이콘 + clear 버튼 + onSubmitted 콜백.
class AppSearchInput extends StatefulWidget {
  const AppSearchInput({
    super.key,
    this.controller,
    this.hintText = '검색',
    this.onSubmitted,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
    this.size = AppTextFieldSize.md,
    this.isEnabled = true,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  /// clear 버튼 탭 콜백. null이면 텍스트만 비움.
  final VoidCallback? onClear;
  final bool autofocus;
  final AppTextFieldSize size;
  final bool isEnabled;

  @override
  State<AppSearchInput> createState() => _AppSearchInputState();
}

class _AppSearchInputState extends State<AppSearchInput> {
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant AppSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onTextChanged);
      if (_ownsController) _controller.dispose();
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = TextEditingController();
        _ownsController = true;
      }
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;
    return AppTextField(
      controller: _controller,
      hintText: widget.hintText,
      prefixIcon: Icons.search_rounded,
      suffixIcon: hasText ? Icons.cancel_rounded : null,
      onSuffixTap: hasText ? _clear : null,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      autofocus: widget.autofocus,
      isEnabled: widget.isEnabled,
      size: widget.size,
    );
  }
}
