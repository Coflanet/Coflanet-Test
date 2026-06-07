/// 배너 노출 슬롯 — 서버 `banners.slot` 대응
enum BannerSlot {
  homeCarousel('home_carousel'),
  homePromo('home_promo');

  final String value;
  const BannerSlot(this.value);

  /// 서버 값 → enum (알 수 없는 값은 null)
  static BannerSlot? fromValue(String? value) {
    for (final slot in BannerSlot.values) {
      if (slot.value == value) return slot;
    }
    return null;
  }
}

/// 배너 탭 동작 — 서버 `banners.action_type` 대응
enum BannerActionType {
  none('none'),
  openUrl('open_url'),
  openBean('open_bean'),
  claimCoupon('claim_coupon');

  final String value;
  const BannerActionType(this.value);

  /// 서버 값 → enum (알 수 없는 값은 none)
  static BannerActionType fromValue(String? value) {
    for (final type in BannerActionType.values) {
      if (type.value == value) return type;
    }
    return BannerActionType.none;
  }
}

/// 홈 배너 모델
///
/// 서버 `banners` 테이블 / `get_active_banners` RPC 응답에 대응.
/// DB는 snake_case, 로컬 더미는 camelCase를 사용할 수 있어
/// [fromJson]에서 양방향 fallback으로 파싱한다.
class BannerModel {
  final String id;

  /// 노출 위치 (캐러셀 / 프로모)
  final BannerSlot slot;

  /// 배너 타이틀 (캐러셀: 이미지 위 오버레이, 최대 2줄)
  final String title;

  /// 보조 문구 (프로모 배너 하단 문구)
  final String? subtitle;

  /// 배너 이미지 URL (banner-images 버킷)
  final String? imageUrl;

  /// 배경색 hex (프로모 배너, 예: '#F553DA')
  final String? bgColor;

  /// 탭 동작
  final BannerActionType actionType;

  /// 동작 파라미터 — {"url":...} | {"bean_id":...} | {"coupon_id":...}
  final Map<String, dynamic>? actionPayload;

  /// 슬롯 내 정렬 우선순위 (높을수록 앞)
  final int priority;

  const BannerModel({
    required this.id,
    required this.slot,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.bgColor,
    this.actionType = BannerActionType.none,
    this.actionPayload,
    this.priority = 0,
  });

  /// open_url 동작의 대상 URL
  String? get url => actionPayload?['url'] as String?;

  /// open_bean 동작의 대상 원두 ID
  String? get beanId => actionPayload?['bean_id'] as String?;

  /// claim_coupon 동작의 대상 쿠폰 ID
  String? get couponId => actionPayload?['coupon_id'] as String?;

  /// 알 수 없는 slot 이면 null 을 반환한다 (호출부에서 필터링).
  static BannerModel? fromJson(Map<String, dynamic> json) {
    final slot = BannerSlot.fromValue(
      json['slot'] as String? ?? json['bannerSlot'] as String?,
    );
    if (slot == null) return null;

    final rawPayload = json['action_payload'] ?? json['actionPayload'];

    return BannerModel(
      id: json['id']?.toString() ?? '',
      slot: slot,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      bgColor: json['bg_color'] as String? ?? json['bgColor'] as String?,
      actionType: BannerActionType.fromValue(
        json['action_type'] as String? ?? json['actionType'] as String?,
      ),
      actionPayload: rawPayload is Map<String, dynamic> ? rawPayload : null,
      priority:
          (json['priority'] as num?)?.toInt() ??
          (json['displayOrder'] as num?)?.toInt() ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slot': slot.value,
    'title': title,
    'subtitle': subtitle,
    'image_url': imageUrl,
    'bg_color': bgColor,
    'action_type': actionType.value,
    'action_payload': actionPayload,
    'priority': priority,
  };
}
