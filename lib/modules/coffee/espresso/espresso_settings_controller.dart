import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/data/models/extraction_step_model.dart';
import 'package:coflanet/widgets/modals/confirm_modal.dart';
import 'package:coflanet/widgets/modals/selection_modal.dart';
import 'package:coflanet/widgets/modals/time_picker_modal.dart';

/// Controller for Espresso Settings (extraction steps configuration)
class EspressoSettingsController extends BaseController {
  // ─── State ───
  final _steps = <ExtractionStep>[].obs;
  List<ExtractionStep> get steps => _steps;

  final _isEditing = false.obs;
  bool get isEditing => _isEditing.value;

  // ─── Lifecycle ───
  @override
  void onInit() {
    super.onInit();
    _initializeDefaultSteps();
  }

  void _initializeDefaultSteps() {
    _steps.addAll([
      ExtractionStep(
        id: '1',
        type: ExtractionStepType.mainExtraction,
        name: '본추출',
        duration: const Duration(seconds: 25),
        pressure: 9.0,
        temperature: 93,
        isRequired: true,
      ),
    ]);
  }

  // ─── Editing Mode ───
  void toggleEditing() {
    _isEditing.value = !_isEditing.value;
  }

  // ─── Reorder ───
  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex >= _steps.length || newIndex > _steps.length) return;
    if (newIndex > oldIndex) newIndex--;

    final step = _steps.removeAt(oldIndex);
    _steps.insert(newIndex, step);
  }

  // ─── Add Step ───
  Future<void> showAddStepOptions() async {
    final result = await SelectionModal.show(
      title: '추가할 단계 선택',
      options: ['프리인퓨전', '블루밍', '추가 추출'],
    );

    if (result != null) {
      final types = [
        ExtractionStepType.preInfusion,
        ExtractionStepType.blooming,
        ExtractionStepType.additionalExtraction,
      ];

      final names = ['프리인퓨전', '블루밍', '추가 추출'];

      _steps.add(
        ExtractionStep(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: types[result],
          name: names[result],
          duration: const Duration(seconds: 5),
          pressure: 3.0,
          temperature: 93,
          isRequired: false,
        ),
      );
    }
  }

  // ─── Edit Step ───
  Future<void> editStep(ExtractionStep step) async {
    final duration = await TimePickerModal.show(
      title: '${step.name} 시간 설정',
      initialDuration: step.duration,
      maxMinutes: 2,
    );

    if (duration != null) {
      final index = _steps.indexWhere((s) => s.id == step.id);
      if (index != -1) {
        _steps[index] = step.copyWith(duration: duration);
      }
    }
  }

  // ─── Delete Step ───
  Future<void> deleteStep(ExtractionStep step) async {
    // Check if blooming depends on pre-infusion
    if (step.type == ExtractionStepType.preInfusion) {
      final hasBlooming = _steps.any(
        (s) => s.type == ExtractionStepType.blooming,
      );
      if (hasBlooming) {
        final confirmed = await ConfirmModal.show(
          title: '프리인퓨전을 삭제할까요?',
          message: '블루밍 단계도 함께 삭제됩니다.',
          confirmText: '삭제',
          cancelText: '취소',
          isDestructive: true,
        );

        if (confirmed == true) {
          _steps.removeWhere(
            (s) =>
                s.type == ExtractionStepType.preInfusion ||
                s.type == ExtractionStepType.blooming,
          );
        }
        return;
      }
    }

    final confirmed = await ConfirmModal.show(
      title: '${step.name}을(를) 삭제할까요?',
      message: '이 단계가 삭제됩니다.',
      confirmText: '삭제',
      cancelText: '취소',
      isDestructive: true,
    );

    if (confirmed == true) {
      _steps.removeWhere((s) => s.id == step.id);
    }
  }

  // ─── Save & Exit ───
  void saveSettings() {
    Get.back(result: _steps.toList());
  }
}
