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
}
