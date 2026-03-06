import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'selection_modal.dart';
import 'input_modal.dart';
import 'time_picker_modal.dart';
import 'confirm_modal.dart';
import 'unsaved_changes_modal.dart';
import 'equipment_selection_modal.dart';
import 'grind_size_modal.dart';

/// Utility class providing convenient static methods for showing modals.
///
/// Usage:
/// ```dart
/// // Selection
/// final result = await ModalUtils.showSelection(
///   title: '옵션 선택',
///   options: ['A', 'B', 'C'],
/// );
///
/// // Input
/// final value = await ModalUtils.showInput(
///   title: '값 입력',
///   hint: '숫자를 입력하세요',
/// );
///
/// // Time picker
/// final duration = await ModalUtils.showTimePicker(
///   title: '시간 선택',
/// );
///
/// // Confirm
/// final confirmed = await ModalUtils.showConfirm(
///   title: '확인',
///   message: '계속하시겠습니까?',
/// );
///
/// // Alert
/// await ModalUtils.showAlert(
///   title: '알림',
///   message: '작업이 완료되었습니다.',
/// );
/// ```
class ModalUtils {
  ModalUtils._();

  /// Shows a selection modal for single or multi-select.
  ///
  /// Returns selected index for single select, or `List<int>` for multi select.
  /// Returns null if cancelled.
  static Future<dynamic> showSelection({
    required String title,
    required List<String> options,
    int? selectedIndex,
    List<int>? selectedIndices,
    bool isMultiSelect = false,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    return SelectionModal.show(
      title: title,
      options: options,
      selectedIndex: selectedIndex,
      selectedIndices: selectedIndices,
      isMultiSelect: isMultiSelect,
      confirmText: confirmText,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows an input modal for text/number input.
  ///
  /// Returns the entered string value, or null if cancelled.
  static Future<String?> showInput({
    required String title,
    String? message,
    String? hint,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
    int maxLines = 1,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return InputModal.show(
      title: title,
      message: message,
      hint: hint,
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
      maxLength: maxLength,
      maxLines: maxLines,
      confirmText: confirmText,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
      inputFormatters: inputFormatters,
    );
  }

  /// Shows a number input modal with numeric keyboard.
  ///
  /// Returns the entered value as int, or null if cancelled or invalid.
  static Future<int?> showNumberInput({
    required String title,
    String? message,
    String? hint,
    int? initialValue,
    int? min,
    int? max,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) async {
    final result = await InputModal.show(
      title: title,
      message: message,
      hint: hint,
      initialValue: initialValue?.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '값을 입력하세요';
        }
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return '올바른 숫자를 입력하세요';
        }
        if (min != null && intValue < min) {
          return '최소 $min 이상이어야 합니다';
        }
        if (max != null && intValue > max) {
          return '최대 $max 이하여야 합니다';
        }
        return null;
      },
      confirmText: confirmText,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
    );

    if (result == null) return null;
    return int.tryParse(result);
  }

  /// Shows a time picker modal for selecting duration.
  ///
  /// Returns the selected Duration, or null if cancelled.
  static Future<Duration?> showTimePicker({
    required String title,
    Duration? initialDuration,
    int maxMinutes = 60,
    int maxSeconds = 59,
    bool showSeconds = true,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    return TimePickerModal.show(
      title: title,
      initialDuration: initialDuration,
      maxMinutes: maxMinutes,
      maxSeconds: maxSeconds,
      showSeconds: showSeconds,
      confirmText: confirmText,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a confirmation modal with cancel and confirm buttons.
  ///
  /// Returns true if confirmed, false if cancelled.
  static Future<bool?> showConfirm({
    required String title,
    String? message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return ConfirmModal.show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
      barrierDismissible: barrierDismissible,
      icon: icon,
    );
  }

  /// Shows an alert modal with only a confirm button.
  ///
  /// Returns true when dismissed.
  static Future<bool?> showAlert({
    required String title,
    String? message,
    String? confirmText,
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return ConfirmModal.alert(
      title: title,
      message: message,
      confirmText: confirmText,
      barrierDismissible: barrierDismissible,
      icon: icon,
    );
  }

  /// Shows a destructive confirmation modal (e.g., for delete actions).
  ///
  /// Returns true if confirmed, false if cancelled.
  static Future<bool?> showDestructiveConfirm({
    required String title,
    String? message,
    String confirmText = '삭제',
    String cancelText = '취소',
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return ConfirmModal.show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: true,
      barrierDismissible: barrierDismissible,
      icon: icon,
    );
  }

  /// Shows an unsaved changes warning modal.
  ///
  /// Returns [UnsavedChangesResult.continueEditing] if user wants to continue,
  /// [UnsavedChangesResult.discardAndExit] if user wants to discard and exit.
  /// Returns null if dismissed (when barrierDismissible is true).
  ///
  /// Typical usage with PopScope:
  /// ```dart
  /// PopScope(
  ///   canPop: false,
  ///   onPopInvokedWithResult: (didPop, result) async {
  ///     if (didPop) return;
  ///     if (!hasUnsavedChanges) {
  ///       Navigator.of(context).pop();
  ///       return;
  ///     }
  ///     final result = await ModalUtils.showUnsavedChanges();
  ///     if (result == UnsavedChangesResult.discardAndExit) {
  ///       Navigator.of(context).pop();
  ///     }
  ///   },
  ///   child: ...
  /// )
  /// ```
  static Future<UnsavedChangesResult?> showUnsavedChanges({
    String? title,
    String? message,
    String? continueText,
    String? exitText,
    bool barrierDismissible = false,
  }) {
    return UnsavedChangesModal.show(
      title: title,
      message: message,
      continueText: continueText,
      exitText: exitText,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows an equipment selection modal for choosing coffee brewing equipment.
  ///
  /// Returns the selected [CoffeeEquipment], or null if cancelled.
  static Future<CoffeeEquipment?> showEquipmentSelection({
    CoffeeEquipment? selectedEquipment,
    List<CoffeeEquipment>? availableEquipments,
    String? title,
    bool barrierDismissible = true,
  }) {
    return EquipmentSelectionModal.show(
      selectedEquipment: selectedEquipment,
      availableEquipments: availableEquipments,
      title: title,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows a grind size input modal with preset buttons.
  ///
  /// Returns the selected grind size in μm, or null if cancelled.
  static Future<int?> showGrindSize({
    int? initialValue,
    String? title,
    String? message,
    int min = 200,
    int max = 1600,
    bool barrierDismissible = true,
  }) {
    return GrindSizeModal.show(
      initialValue: initialValue,
      title: title,
      message: message,
      min: min,
      max: max,
      barrierDismissible: barrierDismissible,
    );
  }
}
