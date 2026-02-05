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

  /// Get recipe by coffee type
  static TimerRecipeModel getRecipe(String coffeeType) {
    switch (coffeeType) {
      case 'handDrip':
        return handDripRecipe;
      case 'espresso':
        return espressoRecipe;
      case 'espressoDouble':
        return espressoDoubleRecipe;
      default:
        return handDripRecipe;
    }
  }
}
