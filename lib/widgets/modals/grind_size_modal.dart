import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// Preset grind sizes in microns (μm).
class GrindSizePreset {
  final int value;
  final String label;

  const GrindSizePreset(this.value, this.label);

  static const List<GrindSizePreset> presets = [
    GrindSizePreset(600, '600μm'),
    GrindSizePreset(800, '800μm'),
    GrindSizePreset(1000, '1000μm'),
    GrindSizePreset(1200, '1200μm'),
    GrindSizePreset(1400, '1400μm'),
    GrindSizePreset(1600, '1600μm'),
  ];
}

/// A modal for inputting grind size with preset buttons.
///
/// Figma: 분쇄도 입력 Modal
///
/// Usage:
/// ```dart
/// final grindSize = await GrindSizeModal.show(
///   initialValue: 1000,
/// );
/// if (grindSize != null) {
///   controller.updateGrindSize(grindSize);
/// }
/// ```
class GrindSizeModal extends StatefulWidget {
  final int? initialValue;
  final String? title;
  final String? message;
  final int min;
  final int max;
  final bool barrierDismissible;

  const GrindSizeModal({
    super.key,
    this.initialValue,
    this.title,
    this.message,
    this.min = 200,
    this.max = 1600,
    this.barrierDismissible = true,
  });

  /// Shows the grind size modal and returns the selected value in μm.
  /// Returns null if cancelled.
  static Future<int?> show({
    int? initialValue,
    String? title,
    String? message,
    int min = 200,
    int max = 1600,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog<int?>(
      GrindSizeModal(
        initialValue: initialValue,
        title: title,
        message: message,
        min: min,
        max: max,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColorScheme.of(Get.context!).componentMaterialDimmer,
    );
  }

  @override
  State<GrindSizeModal> createState() => _GrindSizeModalState();
}

class _GrindSizeModalState extends State<GrindSizeModal>
    with SingleTickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late int _currentValue;
  String? _errorText;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? 1000;
    _textController = TextEditingController(text: _currentValue.toString());
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
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPresetSelected(int value) {
    setState(() {
      _currentValue = value;
      _textController.text = value.toString();
      _errorText = null;
    });
  }

  void _onTextChanged(String text) {
    final value = int.tryParse(text);
    if (value != null) {
      setState(() {
        _currentValue = value;
        _errorText = null;
      });
    }
  }

  String? _validate() {
    final value = int.tryParse(_textController.text);
    if (value == null) {
      return '올바른 숫자를 입력하세요';
    }
    if (value < widget.min || value > widget.max) {
      return '${widget.min}~${widget.max}μm 사이의 값을 입력하세요';
    }
    return null;
  }

  void _onConfirm() {
    final error = _validate();
    if (error != null) {
      setState(() {
        _errorText = error;
      });
      return;
    }
    Get.back(result: _currentValue);
  }

  void _onCancel() {
    Get.back(result: null);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScheme.of(context);
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
                color: colors.backgroundElevatedNormal,
                borderRadius: AppRadius.modalBorder,
                boxShadow: AppShadows.shadowBlackHeavy,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(colors),
                  _buildInputField(colors),
                  _buildPresetButtons(colors),
                  _buildHint(colors),
                  _buildActions(colors),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        children: [
          Text(
            widget.title ?? '분쇄도를 입력해주세요',
            style: AppTextStyles.heading1Bold.copyWith(
              color: colors.labelNormal,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.message!,
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              '추출 방식과 장비에 따라 굵기를 조절해보세요',
              style: AppTextStyles.body2NormalRegular.copyWith(
                color: colors.labelAlternative,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.componentFillNormal,
              borderRadius: AppRadius.buttonBorder,
              border: Border.all(
                color: _errorText != null
                    ? colors.statusNegative
                    : _focusNode.hasFocus
                    ? colors.primaryNormal
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _onTextChanged,
                    onSubmitted: (_) => _onConfirm(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title2Bold.copyWith(
                      color: colors.labelNormal,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'μm',
                    style: AppTextStyles.body1NormalMedium.copyWith(
                      color: colors.labelAlternative,
                    ),
                  ),
                ),
              ],
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
                    color: colors.statusNegative,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _errorText!,
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: colors.statusNegative,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetButtons(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: GrindSizePreset.presets.map((preset) {
          final isSelected = _currentValue == preset.value;
          return GestureDetector(
            onTap: () => _onPresetSelected(preset.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryNormal
                    : colors.componentFillNormal,
                borderRadius: AppRadius.xxxlBorder,
                border: Border.all(
                  color: isSelected
                      ? colors.primaryNormal
                      : colors.lineNormalNormal,
                  width: 1,
                ),
              ),
              child: Text(
                preset.label,
                style: AppTextStyles.label1NormalMedium.copyWith(
                  color: isSelected
                      ? AppColor.staticLabelWhiteStrong
                      : colors.labelNormal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHint(AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.backgroundNormalAlternative,
          borderRadius: AppRadius.mdBorder,
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colors.labelAssistive, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getGrindSizeHint(),
                style: AppTextStyles.caption1Regular.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGrindSizeHint() {
    if (_currentValue < 400) return '에스프레소용 곱게 분쇄 (200-400μm)';
    if (_currentValue < 600) return '모카포트용 분쇄 (400-600μm)';
    if (_currentValue < 800) return '에어로프레스용 분쇄 (600-800μm)';
    if (_currentValue < 1000) return '푸어오버용 중간 분쇄 (800-1000μm)';
    if (_currentValue < 1200) return '드립용 중간 분쇄 (1000-1200μm)';
    if (_currentValue < 1400) return '프렌치프레스용 분쇄 (1200-1400μm)';
    return '콜드브루용 굵게 분쇄 (1400-1600μm)';
  }

  Widget _buildActions(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.labelNormal,
                  side: BorderSide(color: colors.lineNormalNormal),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorder,
                  ),
                ),
                child: Text('취소', style: AppTextStyles.headline2Bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryNormal,
                  foregroundColor: AppColor.staticLabelWhiteStrong,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonBorder,
                  ),
                ),
                child: Text('확인', style: AppTextStyles.headline2Bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
