import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// 시간 선택 인풋 — Figma `Time Picker/*`.
///
/// 인라인 input-style trigger + tap 시 플랫폼별 시간 picker:
/// - iOS: `CupertinoDatePicker(mode: time)` modal sheet
/// - Android/Web/Desktop: `showTimePicker` Material dialog
///
/// 12/24h는 `use24HourFormat`로 토글. (24h 기본)
///
/// P0 MVP: 풀-커스텀 시계 그리드는 후속(P1+).
class AppTimePicker extends StatefulWidget {
  const AppTimePicker({
    super.key,
    this.label,
    this.placeholder = '시간 선택',
    this.initialTime,
    this.onChanged,
    this.isEnabled = true,
    this.use24HourFormat = true,
  });

  final String? label;
  final String placeholder;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay?>? onChanged;
  final bool isEnabled;
  final bool use24HourFormat;

  @override
  State<AppTimePicker> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends State<AppTimePicker> {
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
  }

  Future<void> _open() async {
    if (!widget.isEnabled) return;
    final TimeOfDay? picked;
    if (!kIsWeb && Platform.isIOS) {
      picked = await _showCupertinoTime();
    } else {
      picked = await showTimePicker(
        context: context,
        initialTime: _time ?? TimeOfDay.now(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: widget.use24HourFormat,
          ),
          child: child ?? const SizedBox(),
        ),
      );
    }
    if (picked != null) {
      setState(() => _time = picked);
      widget.onChanged?.call(picked);
    }
  }

  Future<TimeOfDay?> _showCupertinoTime() async {
    final initial = _time ?? TimeOfDay.now();
    DateTime temp = DateTime(2000, 1, 1, initial.hour, initial.minute);
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColor.backgroundElevatedNormal,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: 280,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(sheetContext, temp),
                        child: const Text('완료'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: temp,
                    use24hFormat: widget.use24HourFormat,
                    onDateTimeChanged: (d) => temp = d,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result == null) return null;
    return TimeOfDay(hour: result.hour, minute: result.minute);
  }

  String get _displayValue {
    if (_time == null) return widget.placeholder;
    final h = _time!.hour;
    final m = _time!.minute.toString().padLeft(2, '0');
    if (widget.use24HourFormat) {
      return '${h.toString().padLeft(2, '0')}:$m';
    }
    final period = h < 12 ? '오전' : '오후';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$period $h12:$m';
  }

  bool get _hasValue => _time != null;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final altColor =
        c.labelAlternative;
    final labelColor =
        c.labelNormal;
    final fillColor = widget.isEnabled
        ? (c.componentFillNormal)
        : (c.interactionDisable);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label2Medium.copyWith(color: labelColor),
          ),
          const SizedBox(height: AppSpacing.s8),
        ],
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isEnabled ? _open : null,
            borderRadius: AppRadius.radiusInputBorder,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
              ),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: AppRadius.radiusInputBorder,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: altColor,
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Text(
                      _displayValue,
                      style: AppTextStyles.body1NormalRegular.copyWith(
                        color: _hasValue ? labelColor : altColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
