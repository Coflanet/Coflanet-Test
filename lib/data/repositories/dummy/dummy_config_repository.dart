import 'package:coflanet/data/models/bean_option_model.dart';
import 'package:coflanet/data/models/onboarding_option_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';

/// Dummy implementation of ConfigRepository
///
/// CI 테스트 모드(--dart-define=CI_TEST=true)에서 사용된다.
/// 네트워크 없이 항상 옵션을 반환하여 스플래시 프리로드/테스트를 안전하게 통과시킨다.
/// (기존 survey_reason_controller 의 하드코딩 fallback 옵션을 이곳으로 이전)
class DummyConfigRepository implements ConfigRepository {
  @override
  Future<List<OnboardingOption>> getOnboardingOptions() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const [
      OnboardingOption(
        optionKey: 'find_taste',
        label: '커피 취향을 찾고 싶어요.',
        displayOrder: 1,
      ),
      OnboardingOption(
        optionKey: 'subscribe_bean',
        label: '원두를 편하게 구독하고 싶어요.',
        displayOrder: 2,
      ),
      OnboardingOption(
        optionKey: 'try_variety',
        label: '다양한 원두를 시도해보고 싶어요.',
        displayOrder: 3,
      ),
      OnboardingOption(
        optionKey: 'community',
        label: '사람들과 커피에 대해 소통하고 싶어요.',
        displayOrder: 4,
      ),
      OnboardingOption(
        optionKey: 'learn_coffee',
        label: '커피에 대한 정보를 알고싶어요.',
        displayOrder: 5,
      ),
    ];
  }

  @override
  Future<BeanOptions> getBeanOptions() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const BeanOptions(
      roastLevels: [
        RoastOption(point: 1, levelCode: 'light', labelKo: '라이트'),
        RoastOption(point: 2, levelCode: 'light', labelKo: '라이트'),
        RoastOption(point: 3, levelCode: 'light', labelKo: '라이트'),
        RoastOption(point: 4, levelCode: 'medium', labelKo: '미디엄'),
        RoastOption(point: 5, levelCode: 'medium', labelKo: '미디엄'),
        RoastOption(point: 6, levelCode: 'medium_dark', labelKo: '미디엄 다크'),
        RoastOption(point: 7, levelCode: 'medium_dark', labelKo: '미디엄 다크'),
        RoastOption(point: 8, levelCode: 'dark', labelKo: '다크'),
        RoastOption(point: 9, levelCode: 'dark', labelKo: '다크'),
        RoastOption(point: 10, levelCode: 'dark', labelKo: '다크'),
      ],
      processMethods: [
        ProcessOption(code: 'washed', labelKo: '워시드'),
        ProcessOption(code: 'natural', labelKo: '내추럴'),
        ProcessOption(code: 'honey', labelKo: '허니'),
        ProcessOption(code: 'wet_hulled', labelKo: '웻 헐링'),
        ProcessOption(code: 'anaerobic', labelKo: '애너로빅'),
      ],
    );
  }
}
