/// 원두 카탈로그 항목 모델 (검색 결과)
///
/// `get_coffee_catalog` RPC 응답의 `beans[]` 한 건을 표현한다.
/// 서버는 snake_case 로 내려주며, 로컬 더미 대비 camelCase fallback 도 둔다.
class CatalogBean {
  final String id;
  final String name;

  /// 산지 — 서버에서 text[] (배열)로 내려옴
  final List<String> origin;
  final String? roastLevel;
  final String? description;
  final String? imageUrl;
  final int? originalPrice;
  final int? discountPrice;
  final int? discountPercent;

  /// 향미 태그(한글 descriptor) 목록
  final List<String> flavorTags;

  /// 내 원두 목록에 이미 담겨있는지
  final bool isInMyList;

  const CatalogBean({
    required this.id,
    required this.name,
    this.origin = const [],
    this.roastLevel,
    this.description,
    this.imageUrl,
    this.originalPrice,
    this.discountPrice,
    this.discountPercent,
    this.flavorTags = const [],
    this.isInMyList = false,
  });

  /// 산지 표시 라벨 (예: '에티오피아, 케냐')
  String get originLabel => origin.join(', ');

  /// 표시 가격 — 할인가 우선, 없으면 정가
  int? get displayPrice => discountPrice ?? originalPrice;

  factory CatalogBean.fromJson(Map<String, dynamic> json) {
    return CatalogBean(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      origin: _parseStringList(json['origin']),
      roastLevel: (json['roast_level'] ?? json['roastLevel']) as String?,
      description: json['description'] as String?,
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      originalPrice: (json['original_price'] as num?)?.toInt(),
      discountPrice: (json['discount_price'] as num?)?.toInt(),
      discountPercent: (json['discount_percent'] as num?)?.toInt(),
      flavorTags: _parseFlavorTags(json['flavor_tags'] ?? json['flavorTags']),
      isInMyList:
          (json['is_in_my_list'] ?? json['isInMyList'] ?? false) as bool,
    );
  }

  /// origin 이 배열/문자열/null 어느 형태든 안전하게 `List<String>` 로 변환
  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    }
    if (value is String && value.isNotEmpty) return [value];
    return const [];
  }

  /// flavor_tags 의 각 항목에서 한글 descriptor 를 추출
  static List<String> _parseFlavorTags(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((e) {
          if (e is Map) {
            return (e['descriptor_ko'] ?? e['descriptor'] ?? '').toString();
          }
          return e.toString();
        })
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
