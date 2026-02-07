import 'package:get/get.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/storage/local_storage.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/dummy/dummy_survey_data.dart';
import 'package:coflanet/routes/app_pages.dart';

class SurveyController extends BaseController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy result if null (for direct navigation testing)
    if (_surveyResult.value == null) {
      _surveyResult.value = DummySurveyData.generateResult({});
    }
  }

  // Survey state
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;

  // Total steps from dummy data (10 questions)
  int get totalSteps => DummySurveyData.questions.length;

  /// Get AppBar title for current step (per Figma design)
  String get currentStepTitle {
    switch (_currentStep.value) {
      case 0:
        return '커피 추출 방식 선택';
      case 1:
        return '커피 숙련도';
      case 2:
      case 3:
      case 4:
      case 5:
        return '맛과 향 취향';
      case 6:
      case 7:
      case 8:
      case 9:
        return '커피 맛과 취향';
      default:
        return '취향 분석';
    }
  }

  /// Get section info for current step (section number and name)
  /// Section 1: 커피 경험 질문 (Steps 0-1)
  /// Section 2: 기본 맛 취향 (Steps 2-5)
  /// Section 3: 특성 향미 취향 (Steps 6-9)
  (int, String) get currentSection {
    if (_currentStep.value <= 1) {
      return (1, '커피 경험 질문');
    } else if (_currentStep.value <= 5) {
      return (2, '기본 맛 취향');
    } else {
      return (3, '특성 향미 취향');
    }
  }

  /// Get section intro text (only shown on first question of each section)
  String? get sectionIntroText {
    switch (_currentStep.value) {
      case 0:
        return '$userName님께\n커피 경험 질문을 드릴게요!';
      case 2:
        return '$userName님의\n기본 맛 취향을 알려주세요';
      case 6:
        return '$userName님의\n특성 향미 취향을 알려주세요';
      default:
        return null;
    }
  }

  // Selected answers (step -> list of selected option IDs)
  final _answers = <int, List<String>>{}.obs;
  Map<int, List<String>> get answers => _answers;

  // Multi-rating answers (step -> {item_id -> rating_value})
  // rating_value: -1 = dislike, 0 = neutral, 1 = like
  final _multiRatingAnswers = <int, Map<String, int>>{}.obs;
  Map<int, Map<String, int>> get multiRatingAnswers => _multiRatingAnswers;

  // Current question
  SurveyQuestionModel? get currentQuestion {
    if (_currentStep.value >= DummySurveyData.questions.length) return null;
    return DummySurveyData.questions[_currentStep.value];
  }

  // Survey result
  final Rxn<SurveyResultModel> _surveyResult = Rxn<SurveyResultModel>();
  SurveyResultModel? get surveyResult => _surveyResult.value;

  // Selected bean IDs on result screen
  final _selectedBeanIds = <String>{}.obs;
  Set<String> get selectedBeanIds => _selectedBeanIds;
  int get selectedBeanCount => _selectedBeanIds.length;

  // Check if current question has selection
  bool get hasSelection {
    final question = currentQuestion;
    if (question == null) return false;

    // For multiRating, all items must have a selection
    if (question.questionType == SurveyQuestionType.multiRating) {
      final items = question.multiRatingItems;
      if (items == null || items.isEmpty) return false;
      final ratings = _multiRatingAnswers[_currentStep.value];
      if (ratings == null) return false;
      // Check if all items have been rated
      return items.every((item) => ratings.containsKey(item.id));
    }

    // For other types, check if at least one option is selected
    return _answers[_currentStep.value]?.isNotEmpty ?? false;
  }

  // Progress percentage based on total steps
  double get progress => (_currentStep.value + 1) / totalSteps;

  /// Select an option
  void selectOption(String optionId) {
    final question = currentQuestion;
    if (question == null) return;

    if (question.allowMultiple) {
      // Toggle selection for multiple choice
      final currentSelections = List<String>.from(
        _answers[_currentStep.value] ?? [],
      );
      if (currentSelections.contains(optionId)) {
        currentSelections.remove(optionId);
      } else {
        currentSelections.add(optionId);
      }
      _answers[_currentStep.value] = currentSelections;
    } else {
      // Single selection
      _answers[_currentStep.value] = [optionId];
    }
  }

  /// Check if an option is selected
  bool isOptionSelected(String optionId) {
    return _answers[_currentStep.value]?.contains(optionId) ?? false;
  }

  /// Set rating for a multi-rating item
  void setMultiRating(String itemId, int value) {
    final currentRatings = Map<String, int>.from(
      _multiRatingAnswers[_currentStep.value] ?? {},
    );
    currentRatings[itemId] = value;
    _multiRatingAnswers[_currentStep.value] = currentRatings;
  }

  /// Get rating for a multi-rating item
  int? getMultiRating(String itemId) {
    return _multiRatingAnswers[_currentStep.value]?[itemId];
  }

  /// Go to next question
  /// Navigates to Section Intro screens at section transitions
  void nextQuestion() {
    if (_currentStep.value < totalSteps - 1) {
      final nextStep = _currentStep.value + 1;

      // Check if we're transitioning to a new section
      // Section 2 starts at step 2, Section 3 starts at step 6
      if (nextStep == 2) {
        // Transition to Section 2 - show Section 2 Intro
        Get.toNamed('${Routes.surveySectionIntro}/2');
      } else if (nextStep == 6) {
        // Transition to Section 3 - show Section 3 Intro
        Get.toNamed('${Routes.surveySectionIntro}/3');
      } else {
        // Normal question transition within same section
        _currentStep.value = nextStep;
        Get.toNamed('${Routes.survey}/$nextStep');
      }
    } else {
      // All questions answered, go to analyzing
      Get.offNamed(Routes.surveyAnalyzing);
    }
  }

  /// Go to previous question
  void previousQuestion() {
    if (_currentStep.value > 0) {
      _currentStep.value--;
      Get.back();
    } else {
      Get.back(); // Go back to intro
    }
  }

  /// Go to specific step
  void goToStep(int step) {
    _currentStep.value = step;
    Get.toNamed('${Routes.survey}/$step');
  }

  /// Start survey - navigate directly to step 0 (Section 1 Intro is now in SurveyIntro)
  void startSurvey() {
    _currentStep.value = 0;
    _answers.clear();
    _multiRatingAnswers.clear();
    // Go directly to first question (skip Section 1 Intro as SurveyIntro already serves this purpose)
    Get.toNamed('${Routes.survey}/0');
  }

  /// Analyze answers and generate result
  Future<void> analyzeSurvey() async {
    showLoading();

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate result from answers
    _surveyResult.value = DummySurveyData.generateResult(_answers);

    hideLoading();

    // Navigate to complete screen
    Get.offNamed(Routes.surveyComplete);
  }

  /// View result
  void viewResult() {
    _selectedBeanIds.clear();
    Get.offNamed(Routes.surveyResult);
  }

  /// Toggle bean selection on result screen
  void toggleBeanSelection(String beanId) {
    if (_selectedBeanIds.contains(beanId)) {
      _selectedBeanIds.remove(beanId);
    } else {
      _selectedBeanIds.add(beanId);
    }
  }

  /// Check if a bean is selected
  bool isBeanSelected(String beanId) {
    return _selectedBeanIds.contains(beanId);
  }

  /// Complete onboarding and go to home
  Future<void> completeOnboarding() async {
    await _storage.setOnboardingComplete(true);

    // Save survey result
    if (_surveyResult.value != null) {
      await _storage.saveSurveyResult(_surveyResult.value!.toJson());
    }

    Get.offAllNamed(Routes.home);
  }

  /// Get user name from storage
  String get userName => _storage.getUserName() ?? '사용자';
}
