import 'package:coflanet/data/models/timer_step_model.dart';

/// Dummy data for coffee timer recipes
class DummyTimerData {
  DummyTimerData._();

  /// Hand drip recipe — Figma 6-step flow (총 2:30, 210ml)
  static const TimerRecipeModel handDripRecipe = TimerRecipeModel(
    id: 'hand_drip_basic',
    name: '핸드드립 기본',
    coffeeType: 'handDrip',
    coffeeAmount: 18,
    waterAmount: 210,
    totalDurationSeconds: 150, // 2:30
    completionMessage: '맛있는 커피가 완성되었어요!',
    aromaDescription: '화사한 꽃향과 부드러운 과일의 단맛이 어우러진 커피입니다',
    aromaTags: [
      AromaTagModel(emoji: '🍑', name: '복숭아'),
      AromaTagModel(emoji: '🌸', name: '자스민'),
      AromaTagModel(emoji: '🍯', name: '꿀'),
      AromaTagModel(emoji: '🍋', name: '레몬'),
    ],
    steps: [
      // Step 1: 원두 분쇄 (Preparation — no timer)
      TimerStepModel(
        stepNumber: 1,
        title: '원두 분쇄',
        description: '물의 흐름과 추출 시간을 좌우하는 준비 단계예요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '⚙️',
        actionText: '원두 18g을 1,000μm 정도로 균일하게 분쇄해주세요',
      ),
      // Step 2: 예열하기 (Preparation — no timer)
      TimerStepModel(
        stepNumber: 2,
        title: '예열하기',
        description: '추출 온도를 일정하게 유지하기 위한 준비 단계예요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '♨️',
        actionText: '서버와 드리퍼를 뜨거운 물로 충분히 예열해주세요',
      ),
      // Step 3: 뜸 들이기 (Brewing — 30s timer)
      TimerStepModel(
        stepNumber: 3,
        title: '뜸 들이기',
        description: '주요 향미가 추출되는 핵심 구간이에요',
        durationSeconds: 30,
        waterAmount: 30,
        stepType: TimerStepType.brewing,
        actionText: '물 30ml을 원두 전체에 골고루 부어주세요',
      ),
      // Step 4: 1차 추출 (Brewing — 60s timer)
      TimerStepModel(
        stepNumber: 4,
        title: '1차 추출',
        description: '주요 향미가 추출되는 핵심 구간이에요',
        durationSeconds: 60,
        waterAmount: 100,
        stepType: TimerStepType.brewing,
        actionText: '물 100ml을 중심에서 바깥으로 천천히 부어주세요',
      ),
      // Step 5: 2차 추출 (Brewing — 30s timer)
      TimerStepModel(
        stepNumber: 5,
        title: '2차 추출',
        description: '밸런스를 맞추는 마지막 추출 단계예요',
        durationSeconds: 30,
        waterAmount: 80,
        stepType: TimerStepType.brewing,
        actionText: '물 80ml을 같은 방식으로 부어주세요',
      ),
      // Step 6: 마무리 (Waiting — 30s timer)
      TimerStepModel(
        stepNumber: 6,
        title: '추출 완료 대기',
        description: '남은 물이 모두 내려갈 때까지 기다려주세요',
        durationSeconds: 30,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
      ),
    ],
  );

  /// Espresso recipe (약 30초)
  static const TimerRecipeModel espressoRecipe = TimerRecipeModel(
    id: 'espresso_single',
    name: '에스프레소 싱글샷',
    coffeeType: 'espresso',
    coffeeAmount: 18,
    waterAmount: 30,
    totalDurationSeconds: 30,
    completionMessage: '완벽한 에스프레소가 완성되었어요!',
    aromaDescription: '진하고 묵직한 크레마 위로 초콜릿과 캐러멜 향이 감돕니다',
    aromaTags: [
      AromaTagModel(emoji: '🍫', name: '초콜릿'),
      AromaTagModel(emoji: '🍯', name: '캐러멜'),
      AromaTagModel(emoji: '🌰', name: '헤이즐넛'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '추출 중',
        description: '크레마가 고르게 형성되는지 확인하세요',
        durationSeconds: 25,
        stepType: TimerStepType.brewing,
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '마무리',
        description: '추출이 거의 완료되었습니다',
        durationSeconds: 5,
        stepType: TimerStepType.waiting,
      ),
    ],
  );

  /// Espresso double shot (약 30초)
  static const TimerRecipeModel espressoDoubleRecipe = TimerRecipeModel(
    id: 'espresso_double',
    name: '에스프레소 더블샷',
    coffeeType: 'espresso',
    coffeeAmount: 18,
    waterAmount: 60,
    totalDurationSeconds: 30,
    completionMessage: '더블샷 에스프레소가 완성되었어요!',
    aromaDescription: '두 배로 진한 풍미와 풍성한 크레마를 즐겨보세요',
    aromaTags: [
      AromaTagModel(emoji: '🍫', name: '다크초콜릿'),
      AromaTagModel(emoji: '🔥', name: '스모키'),
      AromaTagModel(emoji: '🌰', name: '아몬드'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '추출 중',
        description: '크레마가 고르게 형성되는지 확인하세요',
        durationSeconds: 25,
        stepType: TimerStepType.brewing,
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '마무리',
        description: '추출이 거의 완료되었습니다',
        durationSeconds: 5,
        stepType: TimerStepType.waiting,
      ),
    ],
  );

  /// Moka Pot recipe (약 3분)
  static const TimerRecipeModel mokaPotRecipe = TimerRecipeModel(
    id: 'moka_pot_basic',
    name: '모카포트',
    coffeeType: 'mokaPot',
    coffeeAmount: 15,
    waterAmount: 150,
    totalDurationSeconds: 180, // 3:00
    completionMessage: '진한 모카포트 커피가 완성되었어요!',
    aromaDescription: '에스프레소처럼 진하면서도 부드러운 바디감이 특징입니다',
    aromaTags: [
      AromaTagModel(emoji: '🍫', name: '다크초콜릿'),
      AromaTagModel(emoji: '🌰', name: '호두'),
      AromaTagModel(emoji: '🔥', name: '로스티'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '물 채우기',
        description: '하단 챔버에 물을 안전 밸브 아래까지 채워주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '💧',
        actionText: '물 150ml을 하단 챔버에 채워주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '원두 담기',
        description: '필터 바스켓에 원두를 담고 평평하게 정리해주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '☕',
        actionText: '원두 15g을 필터에 담고 누르지 마세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '가열 추출',
        description: '중약불에서 천천히 추출합니다',
        durationSeconds: 150,
        stepType: TimerStepType.brewing,
        actionText: '쉭쉭 소리가 나면 불을 끄세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '추출 완료',
        description: '잔여 열로 마지막 추출이 완료됩니다',
        durationSeconds: 30,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
      ),
    ],
  );

  /// French Press recipe (약 4분)
  static const TimerRecipeModel frenchPressRecipe = TimerRecipeModel(
    id: 'french_press_basic',
    name: '프렌치프레스',
    coffeeType: 'frenchPress',
    coffeeAmount: 30,
    waterAmount: 500,
    totalDurationSeconds: 240, // 4:00
    completionMessage: '풍부한 바디감의 커피가 완성되었어요!',
    aromaDescription: '오일이 살아있는 풀바디 커피로 깊은 풍미를 느낄 수 있습니다',
    aromaTags: [
      AromaTagModel(emoji: '🍯', name: '캐러멜'),
      AromaTagModel(emoji: '🌰', name: '땅콩'),
      AromaTagModel(emoji: '🍞', name: '토스트'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '원두 준비',
        description: '굵게 분쇄한 원두를 프레스에 넣어주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '⚙️',
        actionText: '원두 30g을 굵게 분쇄해주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '물 붓기',
        description: '뜨거운 물을 원두 위에 골고루 부어주세요',
        durationSeconds: 30,
        waterAmount: 500,
        stepType: TimerStepType.brewing,
        actionText: '93°C 물 500ml을 천천히 부어주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '우려내기',
        description: '뚜껑을 덮고 커피가 우러나도록 기다려주세요',
        durationSeconds: 180,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
        actionText: '플런저를 올린 상태로 기다려주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '플런저 누르기',
        description: '천천히 플런저를 눌러 커피를 분리해주세요',
        durationSeconds: 30,
        stepType: TimerStepType.brewing,
        actionText: '30초에 걸쳐 천천히 눌러주세요',
      ),
    ],
  );

  /// Aeropress recipe (약 2분)
  static const TimerRecipeModel aeropressRecipe = TimerRecipeModel(
    id: 'aeropress_basic',
    name: '에어로프레스',
    coffeeType: 'aeropress',
    coffeeAmount: 17,
    waterAmount: 220,
    totalDurationSeconds: 120, // 2:00
    completionMessage: '깔끔한 에어로프레스 커피가 완성되었어요!',
    aromaDescription: '깔끔하고 밝은 산미와 함께 달콤한 여운이 남습니다',
    aromaTags: [
      AromaTagModel(emoji: '🍎', name: '사과'),
      AromaTagModel(emoji: '🍯', name: '꿀'),
      AromaTagModel(emoji: '🌸', name: '플로럴'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '필터 준비',
        description: '필터를 캡에 넣고 뜨거운 물로 린싱해주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '💧',
        actionText: '종이 필터를 적셔 종이 냄새를 제거해주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '원두 넣기',
        description: '인버트 방식으로 원두를 넣어주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '☕',
        actionText: '원두 17g을 중간 굵기로 분쇄해 넣어주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '물 붓기',
        description: '물을 붓고 저어주세요',
        durationSeconds: 30,
        waterAmount: 220,
        stepType: TimerStepType.brewing,
        actionText: '물 220ml을 붓고 10초간 저어주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '우려내기',
        description: '커피가 충분히 우러나도록 기다려주세요',
        durationSeconds: 60,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
      ),
      TimerStepModel(
        stepNumber: 5,
        title: '프레스',
        description: '뒤집어서 천천히 눌러 추출해주세요',
        durationSeconds: 30,
        stepType: TimerStepType.brewing,
        actionText: '30초에 걸쳐 일정한 힘으로 눌러주세요',
      ),
    ],
  );

  /// Cold Brew recipe (준비 중심)
  static const TimerRecipeModel coldBrewRecipe = TimerRecipeModel(
    id: 'cold_brew_basic',
    name: '콜드브루',
    coffeeType: 'coldBrew',
    coffeeAmount: 100,
    waterAmount: 1000,
    totalDurationSeconds: 60, // 준비 시간만 (실제 추출은 12-24시간)
    completionMessage: '콜드브루 준비가 완료되었어요! 12-24시간 후 즐겨주세요.',
    aromaDescription: '부드럽고 달콤한 맛이 특징인 저온 추출 커피입니다',
    aromaTags: [
      AromaTagModel(emoji: '🍫', name: '밀크초콜릿'),
      AromaTagModel(emoji: '🍒', name: '체리'),
      AromaTagModel(emoji: '🍬', name: '캔디'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '원두 준비',
        description: '굵게 분쇄한 원두를 용기에 넣어주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '⚙️',
        actionText: '원두 100g을 굵게 분쇄해주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '물 붓기',
        description: '차가운 물을 원두 위에 부어주세요',
        durationSeconds: 30,
        waterAmount: 1000,
        stepType: TimerStepType.brewing,
        actionText: '차가운 물 1L를 천천히 부어주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '냉장 보관',
        description: '냉장고에서 12-24시간 우려주세요',
        durationSeconds: 30,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '❄️',
        actionText: '뚜껑을 덮고 냉장고에 보관해주세요',
      ),
    ],
  );

  /// Chemex recipe (약 4분)
  static const TimerRecipeModel chemexRecipe = TimerRecipeModel(
    id: 'chemex_basic',
    name: '케멕스',
    coffeeType: 'chemex',
    coffeeAmount: 42,
    waterAmount: 700,
    totalDurationSeconds: 240, // 4:00
    completionMessage: '깨끗한 케멕스 커피가 완성되었어요!',
    aromaDescription: '두꺼운 필터로 오일이 걸러져 깔끔하고 밝은 맛이 특징입니다',
    aromaTags: [
      AromaTagModel(emoji: '🍊', name: '오렌지'),
      AromaTagModel(emoji: '🌸', name: '자스민'),
      AromaTagModel(emoji: '🍵', name: '홍차'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '필터 준비',
        description: '케멕스 필터를 접어 세팅하고 린싱해주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '💧',
        actionText: '3겹이 주둥이 쪽으로 오도록 세팅해주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '뜸 들이기',
        description: '원두 전체를 적셔 가스를 빼주세요',
        durationSeconds: 45,
        waterAmount: 100,
        stepType: TimerStepType.brewing,
        actionText: '물 100ml로 원두를 골고루 적셔주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '1차 추출',
        description: '중심에서 바깥으로 원을 그리며 부어주세요',
        durationSeconds: 75,
        waterAmount: 300,
        stepType: TimerStepType.brewing,
        actionText: '물 300ml을 천천히 부어주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '2차 추출',
        description: '같은 방식으로 나머지 물을 부어주세요',
        durationSeconds: 75,
        waterAmount: 300,
        stepType: TimerStepType.brewing,
        actionText: '물 300ml을 추가로 부어주세요',
      ),
      TimerStepModel(
        stepNumber: 5,
        title: '추출 완료',
        description: '모든 물이 내려갈 때까지 기다려주세요',
        durationSeconds: 45,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
      ),
    ],
  );

  /// Siphon recipe (약 5분)
  static const TimerRecipeModel siphonRecipe = TimerRecipeModel(
    id: 'siphon_basic',
    name: '사이폰',
    coffeeType: 'siphon',
    coffeeAmount: 25,
    waterAmount: 360,
    totalDurationSeconds: 300, // 5:00
    completionMessage: '우아한 사이폰 커피가 완성되었어요!',
    aromaDescription: '진공 추출로 깨끗하면서도 풍부한 향미를 느낄 수 있습니다',
    aromaTags: [
      AromaTagModel(emoji: '🍷', name: '와인'),
      AromaTagModel(emoji: '🫐', name: '베리'),
      AromaTagModel(emoji: '🌹', name: '장미'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '물 가열',
        description: '하부 플라스크에 물을 넣고 가열해주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '🔥',
        actionText: '물 360ml을 하부에 넣고 가열해주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '상부 결합',
        description: '물이 끓기 시작하면 상부를 결합해주세요',
        durationSeconds: 120,
        stepType: TimerStepType.brewing,
        actionText: '물이 상부로 올라오면 원두를 넣어주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '교반',
        description: '원두와 물을 골고루 섞어주세요',
        durationSeconds: 30,
        stepType: TimerStepType.brewing,
        actionText: '대나무 스틱으로 부드럽게 저어주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '추출',
        description: '불을 줄이고 커피가 우러나도록 해주세요',
        durationSeconds: 60,
        stepType: TimerStepType.brewing,
        actionText: '약불로 줄이고 1분간 추출해주세요',
      ),
      TimerStepModel(
        stepNumber: 5,
        title: '하강',
        description: '불을 끄고 커피가 내려오도록 해주세요',
        durationSeconds: 90,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
        actionText: '진공 압력으로 커피가 하부로 내려옵니다',
      ),
    ],
  );

  /// Turkish Coffee recipe (약 3분)
  static const TimerRecipeModel turkishRecipe = TimerRecipeModel(
    id: 'turkish_basic',
    name: '터키시 커피',
    coffeeType: 'turkish',
    coffeeAmount: 10,
    waterAmount: 100,
    totalDurationSeconds: 180, // 3:00
    completionMessage: '전통 터키시 커피가 완성되었어요!',
    aromaDescription: '가장 곱게 분쇄한 원두로 만든 진하고 달콤한 커피입니다',
    aromaTags: [
      AromaTagModel(emoji: '🍫', name: '다크초콜릿'),
      AromaTagModel(emoji: '🌶️', name: '스파이시'),
      AromaTagModel(emoji: '🍬', name: '캐러멜'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '재료 준비',
        description: '이브릭에 물, 커피, 설탕을 넣어주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '☕',
        actionText: '물 100ml, 커피 10g, 설탕을 넣어주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '1차 가열',
        description: '약불에서 천천히 가열해주세요',
        durationSeconds: 90,
        stepType: TimerStepType.brewing,
        actionText: '거품이 올라오면 불에서 내려주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '2차 가열',
        description: '다시 불에 올려 거품을 만들어주세요',
        durationSeconds: 60,
        stepType: TimerStepType.brewing,
        actionText: '거품이 다시 올라오면 내려주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '서빙',
        description: '잔에 따르고 가루가 가라앉도록 기다려주세요',
        durationSeconds: 30,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
        actionText: '2-3분 후 위의 맑은 부분만 드세요',
      ),
    ],
  );

  /// Vietnamese Coffee recipe (약 4분)
  static const TimerRecipeModel vietnameseRecipe = TimerRecipeModel(
    id: 'vietnamese_basic',
    name: '베트남 커피',
    coffeeType: 'vietnamese',
    coffeeAmount: 25,
    waterAmount: 100,
    totalDurationSeconds: 240, // 4:00
    completionMessage: '달콤한 베트남 커피가 완성되었어요!',
    aromaDescription: '연유와 어우러진 진하고 달콤한 커피입니다',
    aromaTags: [
      AromaTagModel(emoji: '🥛', name: '연유'),
      AromaTagModel(emoji: '🍫', name: '초콜릿'),
      AromaTagModel(emoji: '🍯', name: '캐러멜'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '연유 준비',
        description: '잔 바닥에 연유를 넣어주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '🥛',
        actionText: '연유 2-3스푼을 잔에 넣어주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '핀 세팅',
        description: '핀 필터에 원두를 넣고 눌러주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '☕',
        actionText: '원두 25g을 넣고 프레스로 눌러주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '뜸 들이기',
        description: '소량의 물로 원두를 적셔주세요',
        durationSeconds: 30,
        waterAmount: 20,
        stepType: TimerStepType.brewing,
        actionText: '물 20ml로 원두를 적셔주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '추출',
        description: '나머지 물을 붓고 천천히 추출해주세요',
        durationSeconds: 210,
        waterAmount: 80,
        stepType: TimerStepType.brewing,
        actionText: '물 80ml을 붓고 뚜껑을 덮어주세요',
      ),
    ],
  );

  /// Clever Dripper recipe (약 3분)
  static const TimerRecipeModel cleverDripperRecipe = TimerRecipeModel(
    id: 'clever_dripper_basic',
    name: '클레버 드리퍼',
    coffeeType: 'cleverDripper',
    coffeeAmount: 20,
    waterAmount: 300,
    totalDurationSeconds: 180, // 3:00
    completionMessage: '균일한 클레버 드리퍼 커피가 완성되었어요!',
    aromaDescription: '침출과 드립의 장점을 모두 살린 균형 잡힌 커피입니다',
    aromaTags: [
      AromaTagModel(emoji: '🍎', name: '사과'),
      AromaTagModel(emoji: '🍯', name: '꿀'),
      AromaTagModel(emoji: '🌰', name: '아몬드'),
    ],
    steps: [
      TimerStepModel(
        stepNumber: 1,
        title: '필터 준비',
        description: '필터를 세팅하고 뜨거운 물로 린싱해주세요',
        durationSeconds: 0,
        stepType: TimerStepType.preparation,
        illustrationEmoji: '💧',
        actionText: '필터를 적셔 종이 냄새를 제거해주세요',
      ),
      TimerStepModel(
        stepNumber: 2,
        title: '물 붓기',
        description: '원두를 넣고 물을 부어주세요',
        durationSeconds: 30,
        waterAmount: 300,
        stepType: TimerStepType.brewing,
        actionText: '원두 20g에 물 300ml을 부어주세요',
      ),
      TimerStepModel(
        stepNumber: 3,
        title: '우려내기',
        description: '뚜껑을 덮고 커피가 우러나도록 기다려주세요',
        durationSeconds: 120,
        stepType: TimerStepType.waiting,
        illustrationEmoji: '⏳',
        actionText: '2분간 침출시켜주세요',
      ),
      TimerStepModel(
        stepNumber: 4,
        title: '드립',
        description: '서버 위에 올려 커피를 내려주세요',
        durationSeconds: 30,
        stepType: TimerStepType.brewing,
        actionText: '밸브가 열리며 커피가 내려옵니다',
      ),
    ],
  );

  /// Get recipe by coffee type
  static TimerRecipeModel getRecipe(String coffeeType) {
    switch (coffeeType) {
      case 'handDrip':
        return handDripRecipe;
      case 'espresso':
        return espressoRecipe;
      case 'espressoDouble':
        return espressoDoubleRecipe;
      case 'mokaPot':
        return mokaPotRecipe;
      case 'frenchPress':
        return frenchPressRecipe;
      case 'aeropress':
        return aeropressRecipe;
      case 'coldBrew':
        return coldBrewRecipe;
      case 'chemex':
        return chemexRecipe;
      case 'siphon':
        return siphonRecipe;
      case 'turkish':
        return turkishRecipe;
      case 'vietnamese':
        return vietnameseRecipe;
      case 'cleverDripper':
        return cleverDripperRecipe;
      default:
        return handDripRecipe;
    }
  }
}
