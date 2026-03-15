import 'package:coflanet/data/models/survey_question_model.dart';

/// Dummy lifestyle survey questions - 12 steps for personality-based coffee matching
class DummyLifestyleSurveyData {
  static const List<SurveyQuestionModel> questions = [
    // ========== 섹션1: 커피 경험 (Step 0-1) ==========

    // Step 0: 커피 추출 방식 선택 (imageGrid - 2 columns, 중복 선택 가능)
    SurveyQuestionModel(
      step: 0,
      question: '어떤 기구로 커피를 마시나요?',
      description: '중복 선택 가능해요.',
      allowMultiple: true,
      questionType: SurveyQuestionType.imageGrid,
      category: '커피 경험',
      options: [
        SurveyOptionModel(id: 'espresso', label: '에스프레소 머신'),
        SurveyOptionModel(id: 'auto', label: '자동 커피머신'),
        SurveyOptionModel(id: 'handdrip', label: '핸드드립'),
        SurveyOptionModel(id: 'capsule', label: '캡슐 머신'),
        SurveyOptionModel(id: 'coldbrew', label: '콜드브루'),
      ],
    ),

    // Step 1: 커피 숙련도 (checkboxWithIcon - single select)
    SurveyQuestionModel(
      step: 1,
      question: '커피와 얼마나 친하신가요?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkboxWithIcon,
      category: '커피 경험',
      options: [
        SurveyOptionModel(
          id: 'beginner',
          label: '입문자',
          icon: '🌱',
          description: '커피는 좋아하지만 추출은 처음이에요',
        ),
        SurveyOptionModel(
          id: 'enthusiast',
          label: '애호가',
          icon: '☕',
          description: '집에서 가끔 내려 마셔요',
        ),
        SurveyOptionModel(
          id: 'home_barista',
          label: '홈바리스타',
          icon: '🧐',
          description: '레시피를 조절하며 즐겨요',
        ),
        SurveyOptionModel(
          id: 'expert',
          label: '전문가',
          icon: '😎',
          description: '레시피를 조절하며 즐겨요',
        ),
      ],
    ),

    // ========== 섹션2: 라이프스타일 (Step 2-5) ==========

    // Step 2: 아침 습관
    SurveyQuestionModel(
      step: 2,
      question: '아침에 일어났을 때 나는?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '라이프스타일',
      options: [
        SurveyOptionModel(id: 'early_bird', label: '알람 전에 눈이 떠진다'),
        SurveyOptionModel(id: 'alarm_ready', label: '알람에 바로 일어난다'),
        SurveyOptionModel(id: 'snooze_once', label: '알람을 한두 번 미룬다'),
        SurveyOptionModel(id: 'snooze_many', label: '알람을 여러 번 미룬다'),
        SurveyOptionModel(id: 'sleep_lover', label: '가능하면 계속 자고 싶다'),
      ],
    ),

    // Step 3: 이상적인 주말
    SurveyQuestionModel(
      step: 3,
      question: '이상적인 주말은?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '라이프스타일',
      options: [
        SurveyOptionModel(id: 'adventure', label: '새로운 장소 탐험/여행'),
        SurveyOptionModel(id: 'social', label: '친구들과 활동적인 모임'),
        SurveyOptionModel(id: 'hobby', label: '취미 활동이나 자기계발'),
        SurveyOptionModel(id: 'cozy', label: '집에서 책/영화 감상'),
        SurveyOptionModel(id: 'rest', label: '아무 계획 없이 휴식'),
      ],
    ),

    // Step 4: 스트레스 해소
    SurveyQuestionModel(
      step: 4,
      question: '스트레스를 받으면 주로?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '라이프스타일',
      options: [
        SurveyOptionModel(id: 'exercise', label: '운동이나 활동적인 것을 한다'),
        SurveyOptionModel(id: 'talk', label: '사람들과 대화하며 푼다'),
        SurveyOptionModel(id: 'media', label: '음악이나 영상을 본다'),
        SurveyOptionModel(id: 'food', label: '맛있는 음식을 먹는다'),
        SurveyOptionModel(id: 'alone', label: '혼자만의 시간을 갖는다'),
      ],
    ),

    // Step 5: 도전 성향
    SurveyQuestionModel(
      step: 5,
      question: '새로운 것을 시도할 때 나는?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '라이프스타일',
      options: [
        SurveyOptionModel(id: 'pioneer', label: '항상 먼저 도전한다'),
        SurveyOptionModel(id: 'curious', label: '관심 있으면 시도한다'),
        SurveyOptionModel(id: 'cautious', label: '주변 반응을 보고 결정한다'),
        SurveyOptionModel(id: 'proven', label: '검증된 것을 선호한다'),
        SurveyOptionModel(id: 'familiar', label: '익숙한 것이 가장 좋다'),
      ],
    ),

    // ========== 섹션3: 맛 취향 (Step 6-9) ==========

    // Step 6: 음식 맛 선호
    SurveyQuestionModel(
      step: 6,
      question: '음식에서 가장 끌리는 맛은?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '맛 취향',
      options: [
        SurveyOptionModel(id: 'sour', label: '상큼하고 새콤한 맛'),
        SurveyOptionModel(id: 'sweet', label: '달콤하고 부드러운 맛'),
        SurveyOptionModel(id: 'nutty', label: '고소하고 담백한 맛'),
        SurveyOptionModel(id: 'rich', label: '진하고 깊은 맛'),
        SurveyOptionModel(id: 'spicy', label: '매콤하고 자극적인 맛'),
      ],
    ),

    // Step 7: 디저트 선호
    SurveyQuestionModel(
      step: 7,
      question: '가장 끌리는 디저트는?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '맛 취향',
      options: [
        SurveyOptionModel(id: 'fruit_tart', label: '상큼한 과일 타르트'),
        SurveyOptionModel(id: 'cheesecake', label: '부드러운 치즈케이크'),
        SurveyOptionModel(id: 'chocolate', label: '진한 초콜릿 케이크'),
        SurveyOptionModel(id: 'nutty_cookie', label: '고소한 견과류 쿠키'),
        SurveyOptionModel(id: 'caramel', label: '달콤한 캐러멜 디저트'),
      ],
    ),

    // Step 8: 음료 온도
    SurveyQuestionModel(
      step: 8,
      question: '평소 음료는 주로?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '맛 취향',
      options: [
        SurveyOptionModel(id: 'always_cold', label: '항상 차갑게'),
        SurveyOptionModel(id: 'mostly_cold', label: '대체로 차갑게'),
        SurveyOptionModel(id: 'depends', label: '상황에 따라 다름'),
        SurveyOptionModel(id: 'mostly_hot', label: '대체로 따뜻하게'),
        SurveyOptionModel(id: 'always_hot', label: '항상 따뜻하게'),
      ],
    ),

    // Step 9: 향 선호
    SurveyQuestionModel(
      step: 9,
      question: '가장 좋아하는 향은?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '맛 취향',
      options: [
        SurveyOptionModel(id: 'floral', label: '꽃향기 (장미, 자스민)'),
        SurveyOptionModel(id: 'fruity', label: '과일향 (베리, 시트러스)'),
        SurveyOptionModel(id: 'herbal', label: '숲/풀 향기 (허브, 민트)'),
        SurveyOptionModel(id: 'sweet_aroma', label: '달콤한 향 (바닐라, 캐러멜)'),
        SurveyOptionModel(id: 'deep', label: '깊은 향 (나무, 가죽, 연기)'),
      ],
    ),

    // ========== 섹션4: 감각/성향 (Step 10-11) ==========

    // Step 10: 자기 표현
    SurveyQuestionModel(
      step: 10,
      question: '나를 잘 표현하는 단어는?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '감각/성향',
      options: [
        SurveyOptionModel(id: 'energetic', label: '활발한 / 에너지 넘치는'),
        SurveyOptionModel(id: 'warm', label: '따뜻한 / 배려하는'),
        SurveyOptionModel(id: 'calm', label: '차분한 / 안정적인'),
        SurveyOptionModel(id: 'independent', label: '독립적인 / 개성 있는'),
        SurveyOptionModel(id: 'practical', label: '실용적인 / 효율적인'),
      ],
    ),

    // Step 11: 결정 방식
    SurveyQuestionModel(
      step: 11,
      question: '중요한 결정을 할 때 나는?',
      description: '',
      allowMultiple: false,
      questionType: SurveyQuestionType.checkbox,
      category: '감각/성향',
      options: [
        SurveyOptionModel(id: 'intuitive', label: '직감을 믿고 빠르게 결정'),
        SurveyOptionModel(id: 'quick_compare', label: '몇 가지 옵션을 빠르게 비교'),
        SurveyOptionModel(id: 'careful', label: '충분히 고민하고 결정'),
        SurveyOptionModel(id: 'consult', label: '주변 의견을 듣고 결정'),
        SurveyOptionModel(id: 'thorough', label: '최대한 정보를 모아 신중하게'),
      ],
    ),
  ];

  /// Total number of questions
  static int get totalQuestions => questions.length;

  /// Get question by step
  static SurveyQuestionModel? getQuestionByStep(int step) {
    if (step < 0 || step >= questions.length) return null;
    return questions[step];
  }

  /// Get questions by category
  static List<SurveyQuestionModel> getQuestionsByCategory(String category) {
    return questions.where((q) => q.category == category).toList();
  }

  /// Get all unique categories
  static List<String> get categories {
    return questions
        .map((q) => q.category)
        .where((c) => c != null)
        .cast<String>()
        .toSet()
        .toList();
  }
}
