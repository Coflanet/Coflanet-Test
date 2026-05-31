import 'package:coflanet/data/models/bean_option_model.dart';
import 'package:coflanet/data/models/onboarding_option_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

/// Supabase implementation of ConfigRepository
///
/// 앱 전역 lookup/상수 데이터를 RPC로 조회한다.
/// 주의: 여기서는 예외를 잡아 fallback 하지 않고 그대로 전파한다.
/// 호출자(AppConfigService)가 error 상태로 전환하여 재시도 UI를 띄울 수 있게 함.
class SupabaseConfigRepository implements ConfigRepository {
  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<List<OnboardingOption>> getOnboardingOptions() async {
    final result = await _db.rpc('get_onboarding_options');
    if (result is List) {
      return result
          .whereType<Map<String, dynamic>>()
          .map(OnboardingOption.fromJson)
          .toList();
    }
    return <OnboardingOption>[];
  }

  @override
  Future<BeanOptions> getBeanOptions() async {
    final result = await _db.rpc('get_bean_options');
    if (result is Map<String, dynamic>) {
      return BeanOptions.fromJson(result);
    }
    return const BeanOptions();
  }
}
