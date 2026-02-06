import 'package:coflanet/data/models/survey_question_model.dart';
import 'package:coflanet/data/models/survey_result_model.dart';

/// Dummy survey questions
class DummySurveyData {
  static const List<SurveyQuestionModel> questions = [
    // Q0: 커플래닛을 찾게 된 이유 (10-survey-reason) - 텍스트만, 아이콘 없음
    SurveyQuestionModel(
      step: 0,
      question: '커플래닛을 찾게 된 이유를 알려주세요.',
      description: '중복 선택 가능해요.',
      allowMultiple: true,
      questionType: SurveyQuestionType.checkbox, // 텍스트만
      options: [
        SurveyOptionModel(id: 'find_taste', label: '커피 취향을 찾고 싶어요.'),
        SurveyOptionModel(
          id: 'subscribe_bean',
          label: '좋아하는 원두를 편하게 구독하고 싶어요.',
        ),
        SurveyOptionModel(id: 'try_various', label: '다양한 원두를 시도해보고 싶어요.'),
        SurveyOptionModel(id: 'communicate', label: '사람들과 커피에 대해 소통하고 싶어요.'),
        SurveyOptionModel(id: 'get_info', label: '커피에 대한 정보를 알고싶어요.'),
      ],
    ),

    // Q1: 커피를 마시는 이유 - 이모지 + 라벨
    SurveyQuestionModel(
      step: 1,
      question: '커피를 마시는 주된 이유가 무엇인가요?',
      description: '가장 큰 이유를 선택해 주세요',
      questionType: SurveyQuestionType.checkboxWithIcon,
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

    // Q3: 과일 향 - 레이팅 스타일 (👎😐👍)
    SurveyQuestionModel(
      step: 3,
      question: '산미가 있는 커피 어떠세요?',
      description: '산미는 과일의 상큼함과 유사한 긍정적인 신맛이에요',
      questionType: SurveyQuestionType.rating,
      options: [
        SurveyOptionModel(id: 'dislike', label: '싫어요', icon: '👎'),
        SurveyOptionModel(id: 'neutral', label: '보통', icon: '😐'),
        SurveyOptionModel(id: 'like', label: '좋아요', icon: '👍'),
      ],
    ),

    // Q4: 커피 숙련도 - 이모지 + 설명 (스토리보드 매칭)
    SurveyQuestionModel(
      step: 4,
      question: '커피와 얼마나 친하신가요?',
      description: '중복 선택 가능해요.',
      questionType: SurveyQuestionType.checkboxWithIcon,
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
          description: '커피 추출이 직업이에요',
        ),
      ],
    ),

    // Q5: 커피 추출 방식 - 이미지 그리드 (스토리보드 05-survey-02)
    SurveyQuestionModel(
      step: 5,
      question: '어떤 기구로 커피를 마시나요?',
      description: '중복 선택 가능해요.',
      allowMultiple: true,
      questionType: SurveyQuestionType.imageGrid,
      options: [
        SurveyOptionModel(id: 'espresso', label: '에스프레소 머신'),
        SurveyOptionModel(id: 'auto', label: '자동 커피머신'),
        SurveyOptionModel(id: 'handdrip', label: '핸드드립'),
        SurveyOptionModel(id: 'capsule', label: '캡슐 머신'),
        SurveyOptionModel(id: 'coldbrew', label: '콜드브루'),
      ],
    ),

    // Q6: 음용 시간대 - 이모지 + 라벨
    SurveyQuestionModel(
      step: 6,
      question: '커피를 주로 마시는 시간대는?',
      description: '',
      questionType: SurveyQuestionType.checkboxWithIcon,
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
          matchPercent: 95,
          flavorTags: ['과일 향', '꽃 향', '시트러스'],
          tasteProfile: const TasteProfileModel(
            acidity: 85,
            sweetness: 70,
            bitterness: 25,
            body: 45,
            aroma: 90,
            balance: 75,
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
          matchPercent: 70,
          flavorTags: ['견과류', '카라멜', '다크초콜릿'],
          tasteProfile: const TasteProfileModel(
            acidity: 55,
            sweetness: 75,
            bitterness: 45,
            body: 65,
            aroma: 70,
            balance: 80,
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
          matchPercent: 65,
          flavorTags: ['다크초콜릿', '스파이시', '로스팅 향'],
          tasteProfile: const TasteProfileModel(
            acidity: 50,
            sweetness: 65,
            bitterness: 55,
            body: 70,
            aroma: 75,
            balance: 85,
          ),
        ),
        CoffeeRecommendationModel(
          id: '4',
          name: '케냐 AA',
          origin: '케냐',
          roastLevel: '라이트',
          description: '와인 같은 산미와 블랙커런트 향이 특징',
          originalPrice: 22000,
          discountPrice: 17600,
          discountPercent: 20,
          weight: '200g',
          matchPercent: 55,
          flavorTags: ['과일 향', '와인', '베리'],
          tasteProfile: const TasteProfileModel(
            acidity: 90,
            sweetness: 55,
            bitterness: 35,
            body: 60,
            aroma: 85,
            balance: 70,
          ),
        ),
        CoffeeRecommendationModel(
          id: '5',
          name: '브라질 산토스',
          origin: '브라질',
          roastLevel: '미디엄',
          description: '부드럽고 고소한 견과류 풍미',
          originalPrice: 15000,
          discountPrice: 12000,
          discountPercent: 20,
          weight: '200g',
          matchPercent: 45,
          flavorTags: ['견과류', '고소함', '밸런스'],
          tasteProfile: const TasteProfileModel(
            acidity: 35,
            sweetness: 65,
            bitterness: 50,
            body: 70,
            aroma: 60,
            balance: 90,
          ),
        ),
        CoffeeRecommendationModel(
          id: '6',
          name: '인도네시아 만델링',
          origin: '인도네시아',
          roastLevel: '다크',
          description: '묵직한 바디감과 허브 향이 특징',
          originalPrice: 19000,
          discountPrice: 15200,
          discountPercent: 20,
          matchPercent: 30,
          flavorTags: ['로스팅 향', '허브', '스모키'],
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 25,
            sweetness: 45,
            bitterness: 80,
            body: 90,
            aroma: 65,
          ),
        ),
        CoffeeRecommendationModel(
          id: '7',
          name: '코스타리카 따라주',
          origin: '코스타리카',
          roastLevel: '미디엄',
          description: '깔끔한 산미와 꿀 같은 단맛',
          originalPrice: 20000,
          discountPrice: 16000,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 70,
            sweetness: 80,
            bitterness: 40,
            body: 55,
            aroma: 75,
          ),
        ),
        CoffeeRecommendationModel(
          id: '8',
          name: '파나마 게이샤',
          origin: '파나마',
          roastLevel: '라이트',
          description: '자스민 향과 복숭아 노트의 프리미엄 원두',
          originalPrice: 45000,
          discountPrice: 38250,
          discountPercent: 15,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 85,
            sweetness: 90,
            bitterness: 15,
            body: 35,
            aroma: 95,
          ),
        ),
        CoffeeRecommendationModel(
          id: '9',
          name: '르완다 킨보',
          origin: '르완다',
          roastLevel: '라이트',
          description: '레드베리와 플로럴 노트가 특징',
          originalPrice: 21000,
          discountPrice: 16800,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 80,
            sweetness: 70,
            bitterness: 30,
            body: 50,
            aroma: 80,
          ),
        ),
        CoffeeRecommendationModel(
          id: '10',
          name: '에티오피아 시다모',
          origin: '에티오피아',
          roastLevel: '라이트',
          description: '블루베리와 레몬 향의 프루티한 맛',
          originalPrice: 19000,
          discountPrice: 15200,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 88,
            sweetness: 75,
            bitterness: 20,
            body: 40,
            aroma: 88,
          ),
        ),
        CoffeeRecommendationModel(
          id: '11',
          name: '탄자니아 킬리만자로',
          origin: '탄자니아',
          roastLevel: '미디엄',
          description: '와인 같은 산미와 복합적인 풍미',
          originalPrice: 18000,
          discountPrice: 14400,
          discountPercent: 20,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 75,
            sweetness: 60,
            bitterness: 45,
            body: 65,
            aroma: 70,
          ),
        ),
        CoffeeRecommendationModel(
          id: '12',
          name: '하와이 코나',
          origin: '하와이',
          roastLevel: '미디엄',
          description: '부드러운 바디와 버터 같은 질감',
          originalPrice: 38000,
          discountPrice: 32300,
          discountPercent: 15,
          weight: '200g',
          tasteProfile: const TasteProfileModel(
            acidity: 45,
            sweetness: 70,
            bitterness: 40,
            body: 75,
            aroma: 80,
          ),
        ),
      ],
    );
  }
}
