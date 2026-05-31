import 'package:flutter/material.dart';
import 'package:coflanet/widgets/charts/flavor_radar_chart.dart';

/// Coffee Item Model for Select Coffee View
class CoffeeItem {
  final String id;
  final String name;
  final String description;
  final Color color;
  final String? imageUrl;

  /// Brand name (브랜드명)
  final String? brand;

  /// Flavor profile for radar chart (산미, 바디감, 단맛, 쓴맛, 밸런스)
  final FlavorProfile? flavorProfile;

  /// Common flavor tags (공통 향미) - e.g., ["과일 향", "다크초콜릿"]
  final List<String>? commonFlavors;

  /// Characteristic flavor tags (특성 향미) - e.g., ["자스민", "베리", "로스팅 향"]
  final List<String>? characteristicFlavors;

  /// Aroma intensity (향의 진함) - 0 to 100
  final double? aromaIntensity;

  /// Origin country/region
  final String? origin;

  /// Roasting level code (light/medium/medium_dark/dark)
  final String? roastLevel;

  /// Roasting point (1~10, refs roast_point) — roastLevel과 함께 저장
  final int? roastPoint;

  /// Processing method (e.g., "Washed", "Natural", "Honey")
  final String? processMethod;

  /// 네이버 쇼핑 상품 ID
  final String? naverProductId;

  /// 네이버 쇼핑 상품 링크
  final String? naverLink;

  /// 네이버 쇼핑 이미지 URL (우선 표시)
  final String? naverImageUrl;

  /// 네이버 쇼핑 최저가 (원)
  final int? naverLprice;

  /// 네이버 쇼핑 최고가 (원)
  final int? naverHprice;

  /// 네이버 쇼핑 판매처명
  final String? naverMallName;

  /// Whether the bean is hidden from the main list
  final bool isHidden;

  /// Order index for sorting
  final int? sortOrder;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.imageUrl,
    this.brand,
    this.flavorProfile,
    this.commonFlavors,
    this.characteristicFlavors,
    this.aromaIntensity,
    this.origin,
    this.roastLevel,
    this.roastPoint,
    this.processMethod,
    this.naverProductId,
    this.naverLink,
    this.naverImageUrl,
    this.naverLprice,
    this.naverHprice,
    this.naverMallName,
    this.isHidden = false,
    this.sortOrder,
  });

  /// 표시용 이미지 URL (네이버 이미지 우선, 없으면 기본 imageUrl)
  String? get displayImageUrl => naverImageUrl ?? imageUrl;

  /// Get all flavor tags combined
  List<String> get allFlavorTags => [
    ...?commonFlavors,
    ...?characteristicFlavors,
  ];

  /// Copy with new values
  CoffeeItem copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    String? imageUrl,
    String? brand,
    FlavorProfile? flavorProfile,
    List<String>? commonFlavors,
    List<String>? characteristicFlavors,
    double? aromaIntensity,
    String? origin,
    String? roastLevel,
    int? roastPoint,
    String? processMethod,
    String? naverProductId,
    String? naverLink,
    String? naverImageUrl,
    int? naverLprice,
    int? naverHprice,
    String? naverMallName,
    bool? isHidden,
    int? sortOrder,
  }) {
    return CoffeeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      flavorProfile: flavorProfile ?? this.flavorProfile,
      commonFlavors: commonFlavors ?? this.commonFlavors,
      characteristicFlavors:
          characteristicFlavors ?? this.characteristicFlavors,
      aromaIntensity: aromaIntensity ?? this.aromaIntensity,
      origin: origin ?? this.origin,
      roastLevel: roastLevel ?? this.roastLevel,
      roastPoint: roastPoint ?? this.roastPoint,
      processMethod: processMethod ?? this.processMethod,
      naverProductId: naverProductId ?? this.naverProductId,
      naverLink: naverLink ?? this.naverLink,
      naverImageUrl: naverImageUrl ?? this.naverImageUrl,
      naverLprice: naverLprice ?? this.naverLprice,
      naverHprice: naverHprice ?? this.naverHprice,
      naverMallName: naverMallName ?? this.naverMallName,
      isHidden: isHidden ?? this.isHidden,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
