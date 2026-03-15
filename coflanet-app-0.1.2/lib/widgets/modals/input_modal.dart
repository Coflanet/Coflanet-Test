import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// A bottom sheet modal for text/number input with quick select chips.
///
/// Redesigned as per Figma Bottom Sheet spec:
/// - Drag handle at top
/// - Title + subtitle section
/// - Pill-shaped input with suffix unit display
/// - Quick select chips grid (2 rows x 4 cols)
/// - Full-width confirm button
///
/// Usage:
/// ```dart
/// final result = await InputModal.show(
///   title: '원두를 얼마나 사용할까요?',
///   message: '일반적으로 1잔에 15g 정도 사용해요',
///   initialValue: '15',
///   suffix: 'g',
///   quickSelectOptions: ['10g', '12g', '15g', '18g', '20g', '22g', '25g', '30g'],
///   keyboardType: TextInputType.number,
/// );
/// ```
class InputModal extends StatefulWidget {
  final String title;
  final String? message;
  final String? hint;
  final String? initialValue;
  final String? suffix;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int maxLines;
  final String? confirmText;
  final String? cancelText;
  final bool barrierDismissible;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? quickSelectOptions;

  const InputModal({
    super.key,
    required this.title,
    this.message,
    this.hint,
    this.initialValue,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.confirmText,
    this.cancelText,
    this.barrierDismissible = true,
    this.inputFormatters,
    this.quickSelectOptions,
  });

  /// Shows the input modal and returns the entered value.
  /// Returns null if cancelled or dismissed.
  static Future<String?> show({
    required String title,
    String? message,
    String? hint,
    String? initialValue,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
    int maxLines = 1,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
    List<TextInputFormatter>? inputFormatters,
    List<String>? quickSelectOptions,
  }) async {
    return Get.bottomSheet<String?>(
      InputModal(
        title: title,
        message: message,
        hint: hint,
        initialValue: initialValue,
        suffix: suffix,
        keyboardType: keyboardType,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
        confirmText: confirmText,
        cancelText: cancelText,
        barrierDismissible: barrierDismissible,
        inputFormatters: inputFormatters,
        quickSelectOptions: quickSelectOptions,
      ),
      isScrollControlled: true,
      isDismissible: barrierDismissible,
      enableDrag: true,
      barrierColor: AppColor.componentMaterialDimmer,
    );
  }

  @override
  State<InputModal> createState() => _InputModalState();
}

class _InputModalState extends State<InputModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _errorText;
  int? _selectedChipIndex;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    // Find matching quick select option if initial value exists
    if (widget.initialValue != null && widget.quickSelectOptions != null) {
      final initialWithSuffix = '${widget.initialValue}${widget.suffix ?? ''}';
      final index = widget.quickSelectOptions!.indexOf(initialWithSuffix);
      if (index >= 0) {
        _selectedChipIndex = index;
      }
    }

    _focusNode.addListener(() => setState(() {}));

    // Auto-focus the text field after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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

  void _onTextChanged(String value) {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }

    // Update selected chip if value matches
    if (widget.quickSelectOptions != null) {
      final valueWithSuffix = '$value${widget.suffix ?? ''}';
      final index = widget.quickSelectOptions!.indexOf(valueWithSuffix);
      setState(() {
        _selectedChipIndex = index >= 0 ? index : null;
      });
    }
  }

  void _onChipSelected(int index, String chipValue) {
    // Extract numeric value from chip (e.g., "15g" -> "15")
    String numericValue = chipValue;
    if (widget.suffix != null && chipValue.endsWith(widget.suffix!)) {
      numericValue = chipValue.substring(
        0,
        chipValue.length - widget.suffix!.length,
      );
    }

    setState(() {
      _selectedChipIndex = index;
      _controller.text = numericValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: numericValue.length),
      );
      _errorText = null;
    });
  }

  void _onClear() {
    setState(() {
      _controller.clear();
      _selectedChipIndex = null;
      _errorText = null;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundElevatedNormal,
        borderRadius: AppRadius.top(AppRadius.xxxl),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              _buildTitleSection(),
              _buildInputField(),
              if (widget.quickSelectOptions != null &&
                  widget.quickSelectOptions!.isNotEmpty)
                _buildQuickSelectChips(),
              _buildConfirmButton(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColor.lineSolidNormal,
        borderRadius: AppRadius.fullBorder,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        children: [
          Text(
            widget.title,
            style: AppTextStyles.heading2Bold.copyWith(
              color: AppColor.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.message!,
              style: AppTextStyles.label1NormalRegular.copyWith(
                color: AppColor.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    final bool hasFocus = _focusNode.hasFocus;
    final bool hasError = _errorText != null;
    final bool hasValue = _controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColor.componentFillNormal,
              borderRadius: AppRadius.fullBorder,
              border: Border.all(
                color: hasError
                    ? AppColor.statusNegative
                    : hasFocus
                    ? AppColor.primaryNormal
                    : AppColor.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: widget.keyboardType,
                    maxLength: widget.maxLength,
                    maxLines: widget.maxLines,
                    inputFormatters: widget.inputFormatters,
                    onChanged: _onTextChanged,
                    onSubmitted: (_) => _onConfirm(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title3Bold.copyWith(
                      color: AppColor.labelNormal,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: AppTextStyles.title3Medium.copyWith(
                        color: AppColor.labelAssistive,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: hasValue ? 48 : 16,
                        right: 16,
                      ),
                      counterText: '',
                    ),
                  ),
                ),
                if (widget.suffix != null && hasValue)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      widget.suffix!,
                      style: AppTextStyles.title3Bold.copyWith(
                        color: AppColor.labelNormal,
                      ),
                    ),
                  ),
                if (hasValue)
                  GestureDetector(
                    onTap: _onClear,
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColor.componentFillStrong,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: AppColor.labelAlternative,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
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

  Widget _buildQuickSelectChips() {
    final options = widget.quickSelectOptions!;
    // Split into rows of 4
    final int rowCount = (options.length / 4).ceil();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        children: List.generate(rowCount, (rowIndex) {
          final startIdx = rowIndex * 4;
          final endIdx = (startIdx + 4).clamp(0, options.length);
          final rowItems = options.sublist(startIdx, endIdx);

          return Padding(
            padding: EdgeInsets.only(bottom: rowIndex < rowCount - 1 ? 8 : 0),
            child: Row(
              children: List.generate(rowItems.length, (colIndex) {
                final globalIndex = startIdx + colIndex;
                final isSelected = _selectedChipIndex == globalIndex;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: colIndex < rowItems.length - 1 ? 8 : 0,
                    ),
                    child: _QuickSelectChip(
                      label: rowItems[colIndex],
                      isSelected: isSelected,
                      onTap: () =>
                          _onChipSelected(globalIndex, rowItems[colIndex]),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryNormal,
            foregroundColor: AppColor.staticLabelWhiteStrong,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.fullBorder),
          ),
          child: Text(
            widget.confirmText ?? '확인',
            style: AppTextStyles.headline1Bold.copyWith(
              color: AppColor.staticLabelWhiteStrong,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickSelectChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.componentFillNormal,
          borderRadius: AppRadius.xxxlBorder,
          border: Border.all(
            color: isSelected ? AppColor.primaryNormal : AppColor.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body2NormalMedium.copyWith(
              color: isSelected
                  ? AppColor.primaryNormal
                  : AppColor.labelAlternative,
            ),
          ),
        ),
      ),
    );
  }
}
