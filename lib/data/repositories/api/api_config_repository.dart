import 'package:coflanet/core/api/api_client.dart';
import 'package:coflanet/data/models/onboarding_option_model.dart';
import 'package:coflanet/data/repositories/repository_interfaces.dart';
import 'package:get/get.dart';

/// API implementation of ConfigRepository
///
/// REST API 모드용 스텁. 현재 프로젝트는 Supabase 모드를 사용하며
/// API 모드는 미완성 상태이다. ([백엔드 API 연동 대기])
class ApiConfigRepository implements ConfigRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  static const String _onboardingOptionsEndpoint = '/config/onboarding-options';

  @override
  Future<List<OnboardingOption>> getOnboardingOptions() async {
    final response = await _apiClient.get(_onboardingOptionsEndpoint);
    final List<dynamic> data = response.data['options'] as List<dynamic>? ?? [];
    return data
        .map((e) => OnboardingOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
