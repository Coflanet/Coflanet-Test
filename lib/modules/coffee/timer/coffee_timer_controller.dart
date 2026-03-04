import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/data/models/timer_step_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/modules/coffee/coffee_controller.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Timer state enum
enum TimerState { idle, preCountdown, running, paused, completed }

/// Controller for coffee brewing timer — Figma step-by-step flow
class CoffeeTimerController extends BaseController {
  /// Recipe repository for loading recipes
  final RecipeRepository _recipeRepository =
      RepositoryProvider.recipeRepository;

  // ─── Recipe ───
  final Rxn<TimerRecipeModel> _recipe = Rxn<TimerRecipeModel>();
  TimerRecipeModel? get recipe => _recipe.value;

  // ─── Step navigation ───
  final _currentStepIndex = 0.obs;
  int get currentStepIndex => _currentStepIndex.value;
  int get totalSteps => _recipe.value?.steps.length ?? 0;

  TimerStepModel? get currentStep {
    final r = _recipe.value;
    if (r == null || _currentStepIndex.value >= r.steps.length) return null;
    return r.steps[_currentStepIndex.value];
  }

  bool get isFirstStep => _currentStepIndex.value == 0;
  bool get isLastStep =>
      _recipe.value != null &&
      _currentStepIndex.value >= _recipe.value!.steps.length - 1;

  // ─── Timer state ───
  final _state = TimerState.idle.obs;
  TimerState get state => _state.value;

  // Per-step countdown
  final _remainingSeconds = 0.obs;
  int get remainingSeconds => _remainingSeconds.value;

  // Pre-countdown (5s before brewing step starts)
  final _preCountdownSeconds = 0.obs;
  int get preCountdownSeconds => _preCountdownSeconds.value;

  // Total elapsed across all timed steps
  final _totalElapsedSeconds = 0.obs;
  int get totalElapsedSeconds => _totalElapsedSeconds.value;

  Timer? _timer;

  // ─── Computed values ───

  /// Progress for current step's circular timer (0.0 → 1.0)
  double get stepProgress {
    final step = currentStep;
    if (step == null || step.durationSeconds == 0) return 0.0;
    final elapsed = step.durationSeconds - _remainingSeconds.value;
    return elapsed / step.durationSeconds;
  }

  /// Overall progress across all timed steps
  double get totalProgress {
    final r = _recipe.value;
    if (r == null || r.totalDurationSeconds == 0) return 0.0;
    return _totalElapsedSeconds.value / r.totalDurationSeconds;
  }

  /// Total water amount label (e.g. "Total 210ml")
  String get totalWaterLabel {
    final r = _recipe.value;
    if (r == null) return '';
    return 'Total ${r.waterAmount}ml';
  }

  /// Total time label (e.g. "02:30")
  String get totalTimeLabel {
    final r = _recipe.value;
    if (r == null) return '00:00';
    return _formatTime(r.totalDurationSeconds);
  }

  /// Remaining time formatted for current step
  String get remainingTimeString => _formatTime(_remainingSeconds.value);

  /// Total remaining time formatted
  String get totalRemainingTimeString {
    final r = _recipe.value;
    if (r == null) return '00:00';
    return _formatTime(r.totalDurationSeconds - _totalElapsedSeconds.value);
  }

  /// Current step duration formatted
  String get stepDurationString {
    final step = currentStep;
    if (step == null) return '00:00';
    return _formatTime(step.durationSeconds);
  }

  /// Phase markers for circular timer widget
  List<double> get phaseMarkers {
    final r = _recipe.value;
    if (r == null || r.totalDurationSeconds == 0) return [];
    final markers = <double>[];
    int accumulated = 0;
    for (int i = 0; i < r.steps.length - 1; i++) {
      accumulated += r.steps[i].durationSeconds;
      if (accumulated > 0) {
        markers.add(accumulated / r.totalDurationSeconds);
      }
    }
    return markers;
  }

  /// Name of next timed step (for pre-countdown banner)
  String? get nextTimedStepName {
    final r = _recipe.value;
    if (r == null) return null;
    // Find next step from current
    for (int i = _currentStepIndex.value + 1; i < r.steps.length; i++) {
      if (r.steps[i].hasTimer) return r.steps[i].title;
    }
    return null;
  }

  // ─── Lifecycle ───

  @override
  void onInit() {
    super.onInit();
    _loadRecipe();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> _loadRecipe() async {
    final args = Get.arguments;
    final coffeeType = args?['type'] as String? ?? 'handDrip';

    // Try to load from CoffeeController first
    if (Get.isRegistered<CoffeeController>()) {
      final coffeeController = Get.find<CoffeeController>();
      final extractionSteps = coffeeController.extractionSteps;

      if (extractionSteps.isNotEmpty) {
        // Build recipe from CoffeeController data
        _recipe.value = _buildRecipeFromController(coffeeController);
        _currentStepIndex.value = 0;
        _totalElapsedSeconds.value = 0;
        _initCurrentStep();
        return;
      }
    }

    // Load from repository (handles dummy vs API internally)
    _recipe.value = await _recipeRepository.getRecipeByType(coffeeType);
    _currentStepIndex.value = 0;
    _totalElapsedSeconds.value = 0;
    _initCurrentStep();
  }

  /// Build TimerRecipeModel from CoffeeController data
  TimerRecipeModel _buildRecipeFromController(CoffeeController controller) {
    final steps = <TimerStepModel>[];
    int stepNumber = 1;

    // Step 1: 원두 분쇄 (preparation)
    steps.add(
      TimerStepModel(
        stepNumber: stepNumber++,
        title: '원두 분쇄',
        description: '분쇄도: ${controller.grindSize}μm',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '☕',
        actionText: '원두 ${controller.coffeeAmount}g을 균일하게 분쇄',
      ),
    );

    // Step 2: 예열 (preparation)
    steps.add(
      TimerStepModel(
        stepNumber: stepNumber++,
        title: '예열',
        description: '서버와 드리퍼 예열',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '🔥',
        actionText: '뜨거운 물로 드리퍼와 서버를 예열',
      ),
    );

    // Add extraction steps from controller
    for (final step in controller.extractionSteps) {
      steps.add(
        TimerStepModel(
          stepNumber: stepNumber++,
          title: step.title,
          description: '물 ${step.waterAmount}ml 추출',
          durationSeconds: step.duration.inSeconds,
          waterAmount: step.waterAmount,
          stepType: TimerStepType.brewing,
          actionText: '${step.waterAmount}ml의 물을 천천히 부어주세요',
        ),
      );
    }

    // Final step: 추출 완료 (preparation)
    steps.add(
      TimerStepModel(
        stepNumber: stepNumber++,
        title: '추출 완료',
        description: '드리퍼 제거하고 서버를 섞기',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '✨',
        actionText: '드리퍼를 제거하고 커피를 가볍게 섞어주세요',
      ),
    );

    // Calculate total duration from brewing steps only
    final totalDuration = steps
        .where((s) => s.hasTimer)
        .fold(0, (sum, s) => sum + s.durationSeconds);

    return TimerRecipeModel(
      id: 'custom_recipe',
      name: controller.selectedBeanName.isNotEmpty
          ? controller.selectedBeanName
          : '커스텀 레시피',
      coffeeType: 'handDrip',
      coffeeAmount: controller.coffeeAmount,
      waterAmount: controller.totalStepsWaterAmount,
      totalDurationSeconds: totalDuration,
      steps: steps,
      completionMessage: '추출이 완료되었습니다!',
      aromaDescription: '신선한 커피의 향을 즐겨보세요',
      aromaTags: const [
        AromaTagModel(emoji: '🍫', name: '초콜릿'),
        AromaTagModel(emoji: '🌰', name: '견과류'),
        AromaTagModel(emoji: '🍯', name: '카라멜'),
      ],
    );
  }

  void _initCurrentStep() {
    final step = currentStep;
    if (step == null) return;
    _remainingSeconds.value = step.durationSeconds;
    _state.value = TimerState.idle;
  }

  // ─── Step navigation ───

  /// Go to previous step
  void previousStep() {
    if (isFirstStep) return;
    _timer?.cancel();
    _currentStepIndex.value--;
    _initCurrentStep();
  }

  /// Go to next step (manual advance for preparation steps)
  void nextStep() {
    if (isLastStep) {
      _completeTimer();
      return;
    }
    _timer?.cancel();
    _currentStepIndex.value++;
    _initCurrentStep();

    // Auto-start pre-countdown if next step is a timed step
    final step = currentStep;
    if (step != null && step.hasTimer) {
      _startPreCountdown();
    }
  }

  // ─── Pre-countdown (5s) ───

  void _startPreCountdown() {
    _state.value = TimerState.preCountdown;
    _preCountdownSeconds.value = 5;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      if (_preCountdownSeconds.value > 1) {
        _preCountdownSeconds.value--;
      } else {
        _preCountdownSeconds.value = 0;
        _startStepTimer();
      }
    });
  }

  // ─── Step timer ───

  void _startStepTimer() {
    final step = currentStep;
    if (step == null) return;

    _state.value = TimerState.running;
    _remainingSeconds.value = step.durationSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
        _totalElapsedSeconds.value++;
      } else {
        _onStepTimerComplete();
      }
    });
  }

  void _onStepTimerComplete() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    if (isLastStep) {
      _completeTimer();
    } else {
      // Auto-advance to next step
      _currentStepIndex.value++;
      _initCurrentStep();
      final step = currentStep;
      if (step != null && step.hasTimer) {
        _startPreCountdown();
      }
      // If next step is preparation, stay idle for manual advance
    }
  }

  /// Toggle play/pause for timed steps
  void toggleTimer() {
    if (_state.value == TimerState.running) {
      pauseTimer();
    } else if (_state.value == TimerState.paused) {
      resumeTimer();
    } else if (_state.value == TimerState.idle) {
      final step = currentStep;
      if (step != null && step.hasTimer) {
        _startPreCountdown();
      }
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    _state.value = TimerState.paused;
  }

  void resumeTimer() {
    _state.value = TimerState.running;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
        _totalElapsedSeconds.value++;
      } else {
        _onStepTimerComplete();
      }
    });
  }

  // ─── Completion ───

  void _completeTimer() {
    _timer?.cancel();
    _state.value = TimerState.completed;

    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isClosed) HapticFeedback.heavyImpact();
    });

    // Save brew log (fire-and-forget, don't block timer completion)
    _saveBrewLog();

    Get.offNamed(
      Routes.timerComplete,
      arguments: {
        'recipe': _recipe.value,
        'totalTime': _totalElapsedSeconds.value,
      },
    );
  }

  /// Save brew log after timer completion (non-blocking)
  /// brew_logs table columns: bean_id, brew_method_id, recipe_id,
  /// coffee_amount_g, water_temp_c, grind_size_um, total_water_ml,
  /// total_yield_g, total_duration_seconds, cups, strength, rating, notes, brewed_at
  void _saveBrewLog() {
    final r = _recipe.value;
    if (r == null) return;

    final values = <String, dynamic>{
      // Send slug for RPC to resolve → brew_method_id
      'brew_method_slug': r.coffeeType,
      'coffee_amount_g': r.coffeeAmount,
      'total_water_ml': r.waterAmount,
      'total_duration_seconds': _totalElapsedSeconds.value,
      'brewed_at': DateTime.now().toIso8601String(),
    };

    // Recipe ID (if it's a server UUID, not a local key)
    if (r.id.contains('-')) {
      values['recipe_id'] = r.id;
    }

    // Try to get bean info from CoffeeController if available
    if (Get.isRegistered<CoffeeController>()) {
      try {
        final cc = Get.find<CoffeeController>();
        if (cc.selectedBeanId != null && cc.selectedBeanId!.isNotEmpty) {
          values['bean_id'] = cc.selectedBeanId;
        }
        if (cc.grindSize > 0) {
          values['grind_size_um'] = cc.grindSize;
        }
      } catch (_) {}
    }

    RepositoryProvider.brewLogRepository.saveBrewLog(values).catchError((e) {
      debugPrint('[CoffeeTimer] saveBrewLog failed: $e');
      return <String, dynamic>{};
    });
  }

  /// Stop and go back
  void stopTimer() {
    _timer?.cancel();
    _state.value = TimerState.idle;
    Get.back();
  }

  /// Restart from beginning
  void restartTimer() {
    _timer?.cancel();
    _currentStepIndex.value = 0;
    _totalElapsedSeconds.value = 0;
    _initCurrentStep();
  }

  /// Go to main shell (원두 탭)
  void goToHome() {
    _timer?.cancel();
    Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
  }

  // ─── Formatting helpers ───

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
