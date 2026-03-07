import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      barrierColor: AppColor.componentMaterialDimmer,
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            decoration: BoxDecoration(
              color: AppColor.backgroundElevatedNormal,
              borderRadius: AppRadius.modalBorder,
              boxShadow: AppShadows.shadowBlackHeavy,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildHeader(), _buildPickers(), _buildActions()],
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

  Widget _buildPickers() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minutes picker
          Expanded(
            child: _buildWheelPicker(
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
                  color: AppColor.labelAlternative,
                ),
              ),
            ),
            // Seconds picker
            Expanded(
              child: _buildWheelPicker(
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
              color: AppColor.primaryNormal.withValues(alpha: 0.08),
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
                        color: AppColor.labelNormal,
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
                  color: AppColor.labelAlternative,
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
