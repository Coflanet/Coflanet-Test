import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// Dummy survey questions
class DummySurveyData {
  static const List<SurveyQuestionModel> questions = [
    // Q1: 커피를 마시는 이유
    SurveyQuestionModel(
      step: 1,
      question: '커피를 마시는 주된 이유가 무엇인가요?',
      description: '가장 큰 이유를 선택해 주세요',
      options: [
        SurveyOptionModel(id: 'taste', label: '맛있어서', icon: '😋'),
        SurveyOptionModel(id: 'caffeine', label: '각성 효과', icon: '⚡'),
        SurveyOptionModel(id: 'habit', label: '습관', icon: '🔄'),
        SurveyOptionModel(id: 'mood', label: '분위기', icon: '☕'),
        SurveyOptionModel(id: 'health', label: '건강', icon: '💪'),
      ],
    ),

    // Q2: 맛 선호도
    SurveyQuestionModel(
      step: 2,
      question: '어떤 맛을 선호하시나요?',
      description: '선호하는 맛을 모두 선택해 주세요',
      allowMultiple: true,
      options: [
        SurveyOptionModel(
          id: 'acidic',
          label: '산미',
          description: '과일 같은 상큼한 맛',
        ),
        SurveyOptionModel(
          id: 'sweet',
          label: '단맛',
          description: '카라멜, 초콜릿 같은 달콤한 맛',
        ),
        SurveyOptionModel(id: 'bitter', label: '쓴맛', description: '진하고 깊은 맛'),
        SurveyOptionModel(
          id: 'nutty',
          label: '고소함',
          description: '견과류 같은 고소한 맛',
        ),
        SurveyOptionModel(id: 'balance', label: '밸런스', description: '균형 잡힌 맛'),
      ],
    ),

    // Q3: 과일 향
    SurveyQuestionModel(
      step: 3,
      question: '커피에서 나는 과일 향을 좋아하시나요?',
      description: '에티오피아, 케냐 같은 아프리카 원두에서 많이 느껴져요',
      options: [
        SurveyOptionModel(
          id: 'love',
          label: '좋아요',
          icon: '🍊',
          description: '과일 향이 나는 커피가 좋아요',
        ),
        SurveyOptionModel(
          id: 'hate',
          label: '싫어요',
          icon: '🚫',
          description: '커피는 커피 맛이 나야죠',
        ),
      ],
    ),

    // Q4: 경험 수준
    SurveyQuestionModel(
      step: 4,
      question: '커피 경험 수준은 어느 정도인가요?',
      description: '',
      options: [
        SurveyOptionModel(
          id: 'beginner',
          label: '입문자',
          icon: '🌱',
          description: '커피에 관심을 갖기 시작했어요',
        ),
        SurveyOptionModel(
          id: 'enthusiast',
          label: '애호가',
          icon: '☕',
          description: '다양한 커피를 즐기고 있어요',
        ),
        SurveyOptionModel(
          id: 'home_barista',
          label: '홈바리스타',
          icon: '🏠',
          description: '집에서 직접 추출해요',
        ),
        SurveyOptionModel(
          id: 'expert',
          label: '전문가',
          icon: '👨‍🍳',
          description: '커피가 직업이에요',
        ),
      ],
    ),

    // Q5: 사용 기구
    SurveyQuestionModel(
      step: 5,
      question: '주로 사용하는 커피 기구는?',
      description: '여러 개를 선택할 수 있어요',
      allowMultiple: true,
      options: [
        SurveyOptionModel(id: 'handdrip', label: '핸드드립', icon: '☕'),
        SurveyOptionModel(id: 'mokapot', label: '모카포트', icon: '🫖'),
        SurveyOptionModel(id: 'espresso', label: '에스프레소 머신', icon: '☕'),
        SurveyOptionModel(id: 'capsule', label: '캡슐머신', icon: '💊'),
        SurveyOptionModel(id: 'etc', label: '기타', icon: '🔧'),
      ],
    ),

    // Q6: 음용 시간대
    SurveyQuestionModel(
      step: 6,
      question: '커피를 주로 마시는 시간대는?',
      description: '',
      options: [
        SurveyOptionModel(id: 'morning', label: '아침', icon: '🌅'),
        SurveyOptionModel(id: 'afternoon', label: '오후', icon: '☀️'),
        SurveyOptionModel(id: 'evening', label: '저녁', icon: '🌙'),
        SurveyOptionModel(id: 'anytime', label: '상관없음', icon: '🕐'),
      ],
    ),
  ];

  /// Generate dummy result based on answers
  static SurveyResultModel generateResult(Map<int, List<String>> answers) {
    // Simple logic to determine coffee type based on answers
    final tastePref = answers[2] ?? [];

    String coffeeType;
    String description;
    TasteProfileModel tasteProfile;
    List<FlavorDescriptionModel> flavorDescriptions;

    if (tastePref.contains('acidic')) {
      coffeeType = '산미파';
      description = '진하고 깊은 풍미를 좋아하네요 😊';
      tasteProfile = const TasteProfileModel(
        acidity: 90,
        sweetness: 60,
        bitterness: 30,
        body: 40,
        aroma: 80,
      );
      flavorDescriptions = const [
        FlavorDescriptionModel(
          name: '과일향',
          emoji: '🍊',
          description: '시트러스, 베리류의 밝고 상큼한 향미가 느껴지는 커피를 선호해요',
        ),
        FlavorDescriptionModel(
          name: '꽃향',
          emoji: '🌸',
          description: '자스민, 라벤더 같은 은은한 플로럴 노트를 즐겨요',
        ),
        FlavorDescriptionModel(
          name: '견과류/초콜릿향',
          emoji: '🍫',
          description: '아몬드, 헤이즐넛, 다크초콜릿의 고소하고 달콤한 풍미',
        ),
        FlavorDescriptionModel(
          name: '로스팅향',
          emoji: '🔥',
          description: '캐러멜, 토스트 같은 따뜻하고 깊은 로스팅 향미',
        ),
      ];
    } else if (tastePref.contains('bitter')) {
      coffeeType = '진한맛파';
      description = '진하고 깊은 풍미를 좋아하네요 😊';
      tasteProfile = const TasteProfileModel(
        acidity: 30,
        sweetness: 40,
        bitterness: 90,
        body: 85,
        aroma: 60,
      );
      flavorDescriptions = const [
        FlavorDescriptionModel(
          name: '로스팅향',
          emoji: '🔥',
          description: '진하게 볶아낸 깊고 스모키한 향미를 좋아해요',
        ),
        FlavorDescriptionModel(
          name: '견과류/초콜릿향',
          emoji: '🍫',
          description: '다크초콜릿, 카카오의 깊고 묵직한 풍미',
        ),
        FlavorDescriptionModel(
          name: '스파이시향',
          emoji: '🌶️',
          description: '후추, 시나몬 같은 향신료의 자극적인 느낌',
        ),
        FlavorDescriptionModel(
          name: '우디향',
          emoji: '🌲',
          description: '오크, 삼나무 같은 나무의 따뜻하고 건조한 향',
        ),
      ];
    } else if (tastePref.contains('sweet')) {
      coffeeType = '달달파';
      description = '달콤하고 부드러운 커피를 즐기시네요 😊';
      tasteProfile = const TasteProfileModel(
        acidity: 40,
        sweetness: 85,
        bitterness: 35,
        body: 60,
        aroma: 70,
      );
      flavorDescriptions = const [
        FlavorDescriptionModel(
          name: '캐러멜향',
          emoji: '🍯',
          description: '달콤한 캐러멜, 토피, 꿀 같은 부드러운 단맛 향미',
        ),
        FlavorDescriptionModel(
          name: '견과류향',
          emoji: '🥜',
          description: '아몬드, 헤이즐넛의 고소하면서도 달콤한 풍미',
        ),
        FlavorDescriptionModel(
          name: '과일향',
          emoji: '🍒',
          description: '체리, 자두 같은 달콤한 과일의 잘 익은 향미',
        ),
        FlavorDescriptionModel(
          name: '바닐라향',
          emoji: '🍦',
          description: '바닐라, 크림 같은 부드럽고 포근한 향',
        ),
      ];
    } else {
      coffeeType = '밸런스파';
      description = '균형 잡힌 맛을 즐기시네요 😊';
      tasteProfile = const TasteProfileModel(
        acidity: 60,
        sweetness: 60,
        bitterness: 60,
        body: 60,
        aroma: 60,
      );
      flavorDescriptions = const [
        FlavorDescriptionModel(
          name: '과일향',
          emoji: '🍊',
          description: '적당한 산미와 함께 느껴지는 과일의 밝은 향',
        ),
        FlavorDescriptionModel(
          name: '견과류/초콜릿향',
          emoji: '🍫',
          description: '밀크초콜릿, 아몬드의 편안하고 고소한 풍미',
        ),
        FlavorDescriptionModel(
          name: '캐러멜향',
          emoji: '🍯',
          description: '캐러멜의 부드러운 달콤함이 은은하게 감도는 맛',
        ),
        FlavorDescriptionModel(
          name: '꽃향',
          emoji: '🌼',
          description: '살짝 느껴지는 플로럴 노트가 복합미를 더해요',
        ),
      ];
    }

    return SurveyResultModel(
      coffeeType: coffeeType,
      coffeeTypeDescription: description,
      tasteProfile: tasteProfile,
      flavorDescriptions: flavorDescriptions,
      recommendations: [
        CoffeeRecommendationModel(
          id: '1',
          name: '에티오피아 예가체프',
          origin: '에티오피아',
          roastLevel: '라이트',
          description: '꽃향과 시트러스 노트가 특징',
          originalPrice: 18000,
          discountPrice: 14400,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 85,
            sweetness: 70,
            bitterness: 25,
            body: 45,
            aroma: 90,
          ),
        ),
        CoffeeRecommendationModel(
          id: '2',
          name: '콜롬비아 수프리모',
          origin: '콜롬비아',
          roastLevel: '미디엄',
          description: '견과류와 카라멜 향이 특징',
          originalPrice: 16000,
          discountPrice: 12800,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 55,
            sweetness: 75,
            bitterness: 45,
            body: 65,
            aroma: 70,
          ),
        ),
        CoffeeRecommendationModel(
          id: '3',
          name: '과테말라 안티구아',
          origin: '과테말라',
          roastLevel: '미디엄',
          description: '초콜릿과 스파이시한 향이 특징',
          originalPrice: 17000,
          discountPrice: 13600,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 50,
            sweetness: 65,
            bitterness: 55,
            body: 70,
            aroma: 75,
          ),
        ),
      ],
    );
  }
}
