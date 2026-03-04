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

  /// Aroma intensity (향의 진함) - 0.0 to 5.0
  final double? aromaIntensity;

  /// Origin country/region
  final String? origin;

  /// Roasting level (e.g., "Light", "Medium", "Dark")
  final String? roastLevel;

  /// Processing method (e.g., "Washed", "Natural", "Honey")
  final String? processMethod;

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
    this.processMethod,
    this.isHidden = false,
    this.sortOrder,
  });

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
    String? processMethod,
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
      processMethod: processMethod ?? this.processMethod,
      isHidden: isHidden ?? this.isHidden,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
