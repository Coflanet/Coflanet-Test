import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coflanet/constants/color_constant.dart';
import 'package:coflanet/constants/style_constant.dart';
import 'package:coflanet/core/base/base_controller.dart';
import 'package:coflanet/core/services/survey_service.dart';
import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';
import 'package:coflanet/routes/app_pages.dart';

/// Survey type enum for standard and lifestyle surveys
enum SurveyType { standard, lifestyle }

class SurveyController extends BaseController {
  /// Survey repository for questions and results
  final SurveyRepository _surveyRepository =
      RepositoryProvider.surveyRepository;

  /// User preferences repository for onboarding state
  final UserPreferencesRepository _prefsRepository =
      RepositoryProvider.userPreferencesRepository;

  /// Survey service for shared state (including userName)
  final SurveyService _surveyService = Get.find<SurveyService>();

  /// Cached questions loaded from repository
  List<SurveyQuestionModel> _questions = [];

  /// Server session ID for survey (set by start_survey RPC)
  String? _sessionId;

  /// Current survey type (standard or lifestyle)
  final _surveyType = SurveyType.standard.obs;
  SurveyType get surveyType => _surveyType.value;

  @override
  void onInit() {
    super.onInit();
    _loadQuestions();
    // Note: Do NOT initialize dummy result here.
    // Survey result should only be set after user completes the survey.
    // Skipping survey should leave _surveyResult as null.
  }

  /// Load survey questions from repository
  Future<void> _loadQuestions() async {
    _questions = await _surveyRepository.getQuestions();
  }

  // Survey state
  final _currentStep = 0.obs;
  int get currentStep => _currentStep.value;

  // Total steps from loaded questions
  int get totalSteps => _questions.length;

  /// Get AppBar title for current step (per Figma design)
  /// Lifestyle survey: All question screens show "커피 맛과 취향"
  /// Standard survey: Section-specific titles
  String get currentStepTitle {
    if (_surveyType.value == SurveyType.lifestyle) {
      // Figma: 라이프스타일 설문의 모든 질문 화면은 "커피 맛과 취향" 표시
      return '커피 맛과 취향';
    }
    // Standard survey
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
  /// Standard survey:
  ///   Section 1: 커피 경험 질문 (Steps 0-1)
  ///   Section 2: 기본 맛 취향 (Steps 2-5)
  ///   Section 3: 특성 향미 취향 (Steps 6-9)
  /// Lifestyle survey:
  ///   Section 1: 커피 경험 (Steps 0-1)
  ///   Section 2: 라이프스타일 (Steps 2-5)
  ///   Section 3: 맛 취향 (Steps 6-9)
  ///   Section 4: 감각/성향 (Steps 10-11)
  (int, String) get currentSection {
    if (_surveyType.value == SurveyType.lifestyle) {
      if (_currentStep.value <= 1) {
        return (1, '커피 경험');
      } else if (_currentStep.value <= 5) {
        return (2, '라이프스타일');
      } else if (_currentStep.value <= 9) {
        return (3, '맛 취향');
      } else {
        return (4, '감각/성향');
      }
    }
    // Standard survey
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
    if (_surveyType.value == SurveyType.lifestyle) {
      switch (_currentStep.value) {
        case 0:
          return '$userName님께\n커피 경험 질문을 드릴게요!';
        case 2:
          return '$userName님의\n라이프스타일을 알려주세요';
        case 6:
          return '$userName님의\n맛 취향을 알려주세요';
        case 10:
          return '$userName님의\n감각과 성향을 알려주세요';
        default:
          return null;
      }
    }
    // Standard survey
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
    if (_currentStep.value >= _questions.length) return null;
    return _questions[_currentStep.value];
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

  /// Check if current question should auto-advance after selection
  /// Auto-advance: single selection questions (not multiRating, not allowMultiple)
  bool get shouldAutoAdvance {
    final question = currentQuestion;
    if (question == null) return false;

    // Don't auto-advance for multiple selection or multiRating
    if (question.allowMultiple) return false;
    if (question.questionType == SurveyQuestionType.multiRating) return false;

    return true;
  }

  // Progress percentage based on total steps
  double get progress => (_currentStep.value + 1) / totalSteps;

  /// Select an option
  /// Section 2-3 (steps 2-9): auto-advance after selection (no button)
  /// Section 1 (steps 0-1): user must tap button to proceed
  void selectOption(String optionId, {bool autoAdvance = false}) {
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

      // Section 2-3 (steps 2-9): auto-advance after selection
      if (_currentStep.value >= 2) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!isClosed) nextQuestion();
        });
      }
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
    // Save current step answers to server (fire-and-forget)
    _saveCurrentStepToServer();

    if (_currentStep.value < totalSteps - 1) {
      final nextStep = _currentStep.value + 1;

      // Check if we're transitioning to a new section
      if (_surveyType.value == SurveyType.lifestyle) {
        // Lifestyle survey section transitions:
        // Section 2 starts at step 2, Section 3 starts at step 6, Section 4 starts at step 10
        if (nextStep == 2) {
          Get.toNamed('${Routes.surveySectionIntro}/2');
        } else if (nextStep == 6) {
          Get.toNamed('${Routes.surveySectionIntro}/3');
        } else if (nextStep == 10) {
          Get.toNamed('${Routes.surveySectionIntro}/4');
        } else {
          _currentStep.value = nextStep;
          Get.toNamed('${Routes.survey}/$nextStep');
        }
      } else {
        // Standard survey section transitions:
        // Section 2 starts at step 2, Section 3 starts at step 6
        if (nextStep == 2) {
          Get.toNamed('${Routes.surveySectionIntro}/2');
        } else if (nextStep == 6) {
          Get.toNamed('${Routes.surveySectionIntro}/3');
        } else {
          _currentStep.value = nextStep;
          Get.toNamed('${Routes.survey}/$nextStep');
        }
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
  Future<void> startSurvey() async {
    _surveyType.value = SurveyType.standard;
    _currentStep.value = 0;
    _answers.clear();
    _multiRatingAnswers.clear();
    _questions = await _surveyRepository.getQuestions(type: 'standard');

    // start_survey RPC — server CHECK: 'preference' or 'lifestyle'
    try {
      final result = await _surveyRepository.startSurvey(
        surveyType: 'preference',
      );
      _sessionId =
          result['session_id'] as String? ??
          result['new_session_id'] as String?;
    } catch (e) {
      debugPrint('[SurveyController] startSurvey RPC failed: $e');
    }

    Get.toNamed('${Routes.survey}/0');
  }

  /// Start lifestyle survey
  Future<void> startLifestyleSurvey() async {
    _surveyType.value = SurveyType.lifestyle;
    _currentStep.value = 0;
    _answers.clear();
    _multiRatingAnswers.clear();
    _questions = await _surveyRepository.getQuestions(type: 'lifestyle');

    try {
      final result = await _surveyRepository.startSurvey(
        surveyType: 'lifestyle',
      );
      _sessionId =
          result['session_id'] as String? ??
          result['new_session_id'] as String?;
    } catch (e) {
      debugPrint('[SurveyController] startLifestyleSurvey RPC failed: $e');
    }

    Get.toNamed('${Routes.survey}/0');
  }

  /// Save current step's answers to server (fire-and-forget, non-blocking)
  void _saveCurrentStepToServer() {
    if (_sessionId == null) return;
    final step = _currentStep.value;
    final stepAnswers = _answers[step];
    if (stepAnswers == null || stepAnswers.isEmpty) return;

    final question = currentQuestion;
    // Send step + selected_options for the RPC to resolve question_id via step lookup
    // survey_answers table: session_id, question_id (FK UUID), selected_options text[]
    final answerMaps = <Map<String, dynamic>>[
      {'step': question?.step ?? step, 'selected_options': stepAnswers},
    ];

    _surveyRepository.saveSurveyStepAnswers(_sessionId!, answerMaps).catchError(
      (e) {
        debugPrint('[SurveyController] saveSurveyStepAnswers failed: $e');
        return <String, dynamic>{};
      },
    );
  }

  /// Whether analysis is currently running (prevents duplicate calls)
  bool _isAnalyzing = false;

  /// Analyze answers and generate result
  Future<void> analyzeSurvey() async {
    if (_isAnalyzing) return;
    _isAnalyzing = true;

    try {
      _surveyResult.value = await _surveyRepository
          .generateResult(_answers)
          .timeout(const Duration(seconds: 30));
      _isAnalyzing = false;
      Get.offNamed(Routes.surveyComplete);
    } on TimeoutException {
      _isAnalyzing = false;
      debugPrint('[SurveyController] analyzeSurvey timeout');
      _showErrorDialog(
        '서버 응답 시간이 초과되었습니다.\n다시 시도해주세요.',
        errorDetail: 'TimeoutException: 30초 초과',
      );
    } catch (e) {
      _isAnalyzing = false;
      debugPrint('[SurveyController] analyzeSurvey error: $e');
      _showErrorDialog(
        '설문 분석 중 오류가 발생했습니다.\n다시 시도해주세요.',
        errorDetail: e.toString(),
      );
    }
  }

  /// Show error dialog with retry / back options
  /// [errorDetail] is only visible in debug builds
  void _showErrorDialog(String message, {String? errorDetail}) {
    final showDetail = kDebugMode && errorDetail != null;

    Get.dialog(
      _ErrorDialog(
        message: message,
        errorDetail: showDetail ? errorDetail : null,
        onRetry: () {
          Get.back();
          analyzeSurvey();
        },
        onBack: () {
          Get.back();
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
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

  /// Complete onboarding and go to main shell (Select Coffee Section)
  /// Per Figma: Survey Result → MainShell Tab 0 (원두)
  Future<void> completeOnboarding() async {
    await _prefsRepository.setOnboardingComplete(true);

    // Save survey result
    if (_surveyResult.value != null) {
      await _surveyRepository.saveSurveyResult(_surveyResult.value!);
    }

    // Save selected bean IDs for MainShell to load
    if (_selectedBeanIds.isNotEmpty) {
      await _surveyRepository.saveSelectedBeanIds(_selectedBeanIds.toList());
    }

    // Navigate to MainShell Tab 0 (원두) per Figma design
    Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
  }

  /// Skip survey and go to main shell without saving survey result
  /// User can take survey later from My Planet screen
  Future<void> skipSurvey() async {
    await _prefsRepository.setOnboardingComplete(true);
    // Do NOT save survey result - leave it null so My Planet shows empty state
    // Navigate to MainShell Tab 0 (원두) per Figma design
    Get.offAllNamed(Routes.mainShell, arguments: {'initialTab': 0});
  }

  /// Get user name from SurveyService (shared state)
  String get userName => _surveyService.userName;
}

/// Error dialog with expandable detail section (debug only)
class _ErrorDialog extends StatefulWidget {
  final String message;
  final String? errorDetail;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _ErrorDialog({
    required this.message,
    required this.onRetry,
    required this.onBack,
    this.errorDetail,
  });

  @override
  State<_ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<_ErrorDialog> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.backgroundNormalNormal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        '분석 오류',
        style: AppTextStyles.heading2Bold.copyWith(color: AppColor.labelNormal),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message,
            style: AppTextStyles.body1NormalRegular.copyWith(
              color: AppColor.labelNeutral,
              height: 1.5,
            ),
          ),
          if (widget.errorDetail != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _showDetail = !_showDetail),
              child: Row(
                children: [
                  Icon(
                    _showDetail ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: AppColor.labelAssistive,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '오류 상세보기',
                    style: AppTextStyles.caption1Regular.copyWith(
                      color: AppColor.labelAssistive,
                    ),
                  ),
                ],
              ),
            ),
            if (_showDetail) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.componentFillNormal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  widget.errorDetail!,
                  style: AppTextStyles.caption1Regular.copyWith(
                    color: AppColor.labelAlternative,
                    fontFamily: 'monospace',
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onBack,
          child: Text(
            '돌아가기',
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: AppColor.labelAssistive,
            ),
          ),
        ),
        TextButton(
          onPressed: widget.onRetry,
          child: Text(
            '재시도',
            style: AppTextStyles.body1NormalMedium.copyWith(
              color: AppColor.primaryNormal,
            ),
          ),
        ),
      ],
    );
  }
}
