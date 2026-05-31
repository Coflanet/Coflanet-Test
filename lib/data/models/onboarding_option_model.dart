/// 온보딩 가입 이유 옵션 모델
///
/// 서버 `onboarding_survey` 테이블 / `get_onboarding_options` RPC 응답에 대응.
/// DB는 snake_case(`option_key`, `display_order`), 로컬 더미는 camelCase를
/// 사용할 수 있어 [fromJson]에서 양방향 fallback으로 파싱한다.
class OnboardingOption {
  /// 선택 식별자 (서버 option_key). 저장 RPC(save_onboarding_reasons) 검증 키.
  final String optionKey;

  /// 화면에 표시되는 라벨
  final String label;

  /// 정렬 순서
  final int displayOrder;

  const OnboardingOption({
    required this.optionKey,
    required this.label,
    this.displayOrder = 0,
  });

  /// View 호환용 별칭 (기존 SurveyReasonOption.id 역할)
  String get id => optionKey;

  factory OnboardingOption.fromJson(Map<String, dynamic> json) {
    return OnboardingOption(
      optionKey:
          json['option_key'] as String? ??
          json['optionKey'] as String? ??
          json['slug'] as String? ??
          json['id']?.toString() ??
          '',
      label: json['label'] as String? ?? json['name'] as String? ?? '',
      displayOrder:
          (json['display_order'] as num?)?.toInt() ??
          (json['displayOrder'] as num?)?.toInt() ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
    'option_key': optionKey,
    'label': label,
    'display_order': displayOrder,
  };
}
