import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:coflanet/data/models/bean_option_model.dart';
import 'package:coflanet/data/models/onboarding_option_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:coflanet/data/repositories/repository_provider.dart';

/// 설정 로드 상태
enum ConfigLoadStatus { idle, loading, ready, error }

/// 앱 전역 설정/상수(lookup) 서비스
///
/// 앱 최초 로딩(스플래시) 시 서버에서 상수 데이터를 한 번에 프리로드하여
/// 메모리에 보관한다. 각 화면은 하드코딩 fallback 대신 이 서비스를 참조한다.
///
/// 새 lookup 추가 절차:
///   1) data/models 에 모델 추가
///   2) ConfigRepository 에 조회 메서드 추가 (+ 3개 구현체)
///   3) [loadAll] 의 Future.wait 에 한 줄 추가
///   4) Rx 필드 + getter 한 쌍 추가
class AppConfigService extends GetxService {
  final ConfigRepository _repo = RepositoryProvider.configRepository;

  // ─── 로드 상태 ───
  final _status = ConfigLoadStatus.idle.obs;
  ConfigLoadStatus get status => _status.value;
  bool get isLoading => _status.value == ConfigLoadStatus.loading;
  bool get isReady => _status.value == ConfigLoadStatus.ready;
  bool get hasError => _status.value == ConfigLoadStatus.error;

  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;

  // ─── lookup 데이터 ───
  final _onboardingOptions = <OnboardingOption>[].obs;
  List<OnboardingOption> get onboardingOptions => _onboardingOptions;

  final _roastLevels = <RoastOption>[].obs;
  List<RoastOption> get roastLevels => _roastLevels;

  final _processMethods = <ProcessOption>[].obs;
  List<ProcessOption> get processMethods => _processMethods;

  final _flavorDescriptors = <FlavorDescriptor>[].obs;
  List<FlavorDescriptor> get flavorDescriptors => _flavorDescriptors;

  /// 모든 lookup 데이터를 병렬로 로드한다.
  /// 하나라도 실패하면 error 상태로 전환되어 재시도가 가능하다.
  Future<void> loadAll() async {
    if (_status.value == ConfigLoadStatus.loading) return;
    _status.value = ConfigLoadStatus.loading;
    _errorMessage.value = null;

    try {
      final results = await Future.wait([
        _repo.getOnboardingOptions(),
        _repo.getBeanOptions(),
      ]);

      _onboardingOptions.assignAll(results[0] as List<OnboardingOption>);
      final beanOptions = results[1] as BeanOptions;
      _roastLevels.assignAll(beanOptions.roastLevels);
      _processMethods.assignAll(beanOptions.processMethods);
      _flavorDescriptors.assignAll(beanOptions.flavorDescriptors);
      // 빈 리스트도 ready 로 둔다(서버 시딩 전 [] 반환 시 앱 진행 가능).
      _status.value = ConfigLoadStatus.ready;
    } catch (e) {
      _errorMessage.value = e.toString();
      _status.value = ConfigLoadStatus.error;
      if (kDebugMode) debugPrint('[AppConfigService] loadAll error: $e');
    }
  }

  /// 실패한 로드를 다시 시도한다.
  Future<void> retry() => loadAll();
}
