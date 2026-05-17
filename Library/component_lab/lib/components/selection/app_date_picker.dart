import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../foundation/app_color.dart';
import '../../foundation/app_color_theme.dart';
import '../../foundation/app_radius.dart';
import '../../foundation/app_spacing.dart';
import '../../foundation/app_text_style.dart';

/// 단일 일자 / 범위 선택 모드.
enum AppDatePickerMode { single, range }

/// 일자 선택 인풋 — Figma `Date Picker/*`.
///
/// 인라인 input-style trigger (label, placeholder, 선택값 표시) + tap 시
/// 플랫폼에 맞는 picker(`CupertinoDatePicker` modal sheet on iOS,
/// `showDatePicker` Material dialog on Android/Web).
///
/// 단일/범위 모두 지원. 범위는 `initialRange`로 시작값 지정, 결과는
/// `onRangeChanged`로 콜백.
///
/// P0 MVP: 풀-커스텀 캘린더 그리드는 후속(P1+) — Figma의 plat sub-files는
/// 디자인 디테일이 안정화된 뒤 별도 PR로 진행.
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    this.mode = AppDatePickerMode.single,
    this.label,
    this.placeholder = '날짜 선택',
    this.initialDate,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.onRangeChanged,
    this.isEnabled = true,
    this.locale = const Locale('ko', 'KR'),
  });

  final AppDatePickerMode mode;
  final String? label;
  final String placeholder;
  final DateTime? initialDate;
  final DateTimeRange? initialRange;

  /// 선택 가능 범위. 기본: today - 100y ~ today + 10y.
  final DateTime? firstDate;
  final DateTime? lastDate;

  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  final bool isEnabled;
  final Locale locale;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _date;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
    _range = widget.initialRange;
  }

  DateTime get _firstDate =>
      widget.firstDate ?? DateTime(DateTime.now().year - 100);
  DateTime get _lastDate =>
      widget.lastDate ?? DateTime(DateTime.now().year + 10);

  Future<void> _open() async {
    if (!widget.isEnabled) return;
    if (widget.mode == AppDatePickerMode.single) {
      final picked = await _showSingle();
      if (picked != null) {
        setState(() => _date = picked);
        widget.onChanged?.call(picked);
      }
    } else {
      final picked = await _showRange();
      if (picked != null) {
        setState(() => _range = picked);
        widget.onRangeChanged?.call(picked);
      }
    }
  }

  Future<DateTime?> _showSingle() async {
    if (!kIsWeb && Platform.isIOS) {
      return _showCupertinoDate();
    }
    return showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
      locale: widget.locale,
    );
  }

  Future<DateTime?> _showCupertinoDate() async {
    DateTime temp = _date ?? DateTime.now();
    return showModalBottomSheet<DateTime>(
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
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: temp,
                    minimumDate: _firstDate,
                    maximumDate: _lastDate,
                    onDateTimeChanged: (d) => temp = d,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<DateTimeRange?> _showRange() {
    return showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: _firstDate,
      lastDate: _lastDate,
      locale: widget.locale,
    );
  }

  String get _displayValue {
    if (widget.mode == AppDatePickerMode.single) {
      if (_date == null) return widget.placeholder;
      return _formatDate(_date!);
    }
    if (_range == null) return widget.placeholder;
    return '${_formatDate(_range!.start)} ~ ${_formatDate(_range!.end)}';
  }

  bool get _hasValue =>
      widget.mode == AppDatePickerMode.single ? _date != null : _range != null;

  String _formatDate(DateTime d) {
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }

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
                    Icons.calendar_today_rounded,
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
