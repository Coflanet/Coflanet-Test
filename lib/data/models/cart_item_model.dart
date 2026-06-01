/// 장바구니 항목 모델
///
/// [백엔드 API 연동 대기] 현재는 로컬(CartService)에서만 관리.
/// 서버 장바구니/주문 연동 시 동일 스키마로 매핑한다.
class CartItem {
  final String beanId;
  final String name;
  final String? imageUrl;

  /// 브랜드/산지 등 보조 라벨 — 선택
  final String? brand;

  /// 단가 (원)
  final int price;

  /// 수량
  final int quantity;

  const CartItem({
    required this.beanId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.brand,
    this.quantity = 1,
  });

  /// 라인 합계 (단가 × 수량)
  int get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      beanId: beanId,
      name: name,
      imageUrl: imageUrl,
      brand: brand,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  /// DB(snake_case) / 로컬(camelCase) 양방향 fallback 파싱
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      beanId: json['bean_id']?.toString() ?? json['beanId']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      brand: json['brand'] as String?,
      price: (json['price'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bean_id': beanId,
      'name': name,
      'image_url': imageUrl,
      'brand': brand,
      'price': price,
      'quantity': quantity,
    };
  }
}
