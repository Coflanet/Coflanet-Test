import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/app_color_scheme.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/constants/radius_constant.dart';

/// A modal for selecting time duration with wheel pickers.
///
/// Usage:
/// ```dart
/// final duration = await TimePickerModal.show(
///   title: '시간 선택',
///   initialDuration: Duration(minutes: 5, seconds: 30),
///   maxMinutes: 60,
/// );
/// ```
class TimePickerModal extends StatefulWidget {
  final String title;
  final Duration? initialDuration;
  final int maxMinutes;
  final int maxSeconds;
  final bool showSeconds;
  final String? confirmText;
  final String? cancelText;
  final bool barrierDismissible;

  const TimePickerModal({
    super.key,
    required this.title,
    this.initialDuration,
    this.maxMinutes = 60,
    this.maxSeconds = 59,
    this.showSeconds = true,
    this.confirmText,
    this.cancelText,
    this.barrierDismissible = true,
  });

  /// Shows the time picker modal and returns the selected duration.
  /// Returns null if cancelled.
  static Future<Duration?> show({
    required String title,
    Duration? initialDuration,
    int maxMinutes = 60,
    int maxSeconds = 59,
    bool showSeconds = true,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog<Duration?>(
      TimePickerModal(
        title: title,
        initialDuration: initialDuration,
        maxMinutes: maxMinutes,
        maxSeconds: maxSeconds,
        showSeconds: showSeconds,
        confirmText: confirmText,
        cancelText: cancelText,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: AppColorScheme.of(Get.context!).componentMaterialDimmer,
    );
  }

  @override
  State<TimePickerModal> createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal>
    with SingleTickerProviderStateMixin {
  late int _selectedMinutes;
  late int _selectedSeconds;
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.initialDuration?.inMinutes ?? 0;
    _selectedSeconds = (widget.initialDuration?.inSeconds ?? 0) % 60;

    // Clamp values to max
    _selectedMinutes = _selectedMinutes.clamp(0, widget.maxMinutes);
    _selectedSeconds = _selectedSeconds.clamp(0, widget.maxSeconds);

    _minutesController = FixedExtentScrollController(
      initialItem: _selectedMinutes,
    );
    _secondsController = FixedExtentScrollController(
      initialItem: _selectedSeconds,
    );

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
    _minutesController.dispose();
    _secondsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final duration = Duration(
      minutes: _selectedMinutes,
      seconds: _selectedSeconds,
    );
    Get.back(result: duration);
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
              children: [
                _buildHeader(colors),
                _buildPickers(colors),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        widget.title,
        style: AppTextStyles.heading1Bold.copyWith(color: colors.labelNormal),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPickers(AppColorScheme colors) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minutes picker
          Expanded(
            child: _buildWheelPicker(
              colors: colors,
              controller: _minutesController,
              itemCount: widget.maxMinutes + 1,
              label: '분',
              onChanged: (index) {
                _selectedMinutes = index;
              },
            ),
          ),
          if (widget.showSeconds) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                ':',
                style: AppTextStyles.title2Bold.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ),
            // Seconds picker
            Expanded(
              child: _buildWheelPicker(
                colors: colors,
                controller: _secondsController,
                itemCount: widget.maxSeconds + 1,
                label: '초',
                onChanged: (index) {
                  _selectedSeconds = index;
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWheelPicker({
    required AppColorScheme colors,
    required FixedExtentScrollController controller,
    required int itemCount,
    required String label,
    required ValueChanged<int> onChanged,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Selection highlight
        Positioned(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: colors.primaryNormal.withValues(alpha: 0.08),
              borderRadius: AppRadius.buttonBorder,
            ),
          ),
        ),
        // Wheel picker
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CupertinoPicker(
                scrollController: controller,
                itemExtent: 44,
                selectionOverlay: null,
                onSelectedItemChanged: onChanged,
                children: List.generate(
                  itemCount,
                  (index) => Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: AppTextStyles.title2MediumMono.copyWith(
                        color: colors.labelNormal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                label,
                style: AppTextStyles.body1NormalMedium.copyWith(
                  color: colors.labelAlternative,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
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
    final colors = AppColorScheme.of(context);
    if (isPrimary) {
      return SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primaryNormal,
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
          foregroundColor: colors.labelNormal,
          side: BorderSide(color: colors.lineNormalNormal),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
        ),
        child: Text(text, style: AppTextStyles.headline2Bold),
      ),
    );
  }
}
