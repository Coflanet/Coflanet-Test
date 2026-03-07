/// Model for a single brew log entry
class BrewLogModel {
  final String id;
  final String? beanId;
  final String? beanName;
  final String? brewMethodId;
  final String? brewMethodName;
  final String? brewMethodSlug;
  final String? recipeId;
  final String? recipeName;
  final double? coffeeAmountG;
  final double? waterTempC;
  final int? grindSizeUm;
  final double? totalWaterMl;
  final double? totalYieldG;
  final int? totalDurationSeconds;
  final int? cups;
  final String? strength;
  final int? rating; // 1-5
  final String? notes;
  final DateTime brewedAt;

  const BrewLogModel({
    required this.id,
    this.beanId,
    this.beanName,
    this.brewMethodId,
    this.brewMethodName,
    this.brewMethodSlug,
    this.recipeId,
    this.recipeName,
    this.coffeeAmountG,
    this.waterTempC,
    this.grindSizeUm,
    this.totalWaterMl,
    this.totalYieldG,
    this.totalDurationSeconds,
    this.cups,
    this.strength,
    this.rating,
    this.notes,
    required this.brewedAt,
  });

  factory BrewLogModel.fromJson(Map<String, dynamic> json) {
    // RPC returns nested objects: bean: {id, name, ...}, brew_method: {id, name, slug, ...}
    final bean = json['bean'] as Map<String, dynamic>?;
    final brewMethod = json['brew_method'] as Map<String, dynamic>?;

    return BrewLogModel(
      id: (json['id'] ?? '').toString(),
      beanId: bean?['id'] as String? ?? json['bean_id'] as String?,
      beanName: bean?['name'] as String? ?? json['bean_name'] as String?,
      brewMethodId:
          brewMethod?['id'] as String? ?? json['brew_method_id'] as String?,
      brewMethodName:
          brewMethod?['name'] as String? ?? json['brew_method_name'] as String?,
      brewMethodSlug:
          brewMethod?['slug'] as String? ?? json['brew_method_slug'] as String?,
      recipeId: json['recipe_id'] as String?,
      recipeName: json['recipe_name'] as String?,
      coffeeAmountG: _toDoubleNullable(json['coffee_amount_g']),
      waterTempC: _toDoubleNullable(json['water_temp_c']),
      grindSizeUm: _toIntNullable(json['grind_size_um']),
      totalWaterMl: _toDoubleNullable(json['total_water_ml']),
      totalYieldG: _toDoubleNullable(json['total_yield_g']),
      totalDurationSeconds: _toIntNullable(json['total_duration_seconds']),
      cups: _toIntNullable(json['cups']),
      strength: json['strength'] as String?,
      rating: _toIntNullable(json['rating']),
      notes: json['notes'] as String?,
      brewedAt: json['brewed_at'] != null
          ? DateTime.parse(json['brewed_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (beanId != null) 'bean_id': beanId,
      if (beanName != null) 'bean_name': beanName,
      if (brewMethodId != null) 'brew_method_id': brewMethodId,
      if (brewMethodName != null) 'brew_method_name': brewMethodName,
      if (brewMethodSlug != null) 'brew_method_slug': brewMethodSlug,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeName != null) 'recipe_name': recipeName,
      if (coffeeAmountG != null) 'coffee_amount_g': coffeeAmountG,
      if (waterTempC != null) 'water_temp_c': waterTempC,
      if (grindSizeUm != null) 'grind_size_um': grindSizeUm,
      if (totalWaterMl != null) 'total_water_ml': totalWaterMl,
      if (totalYieldG != null) 'total_yield_g': totalYieldG,
      if (totalDurationSeconds != null)
        'total_duration_seconds': totalDurationSeconds,
      if (cups != null) 'cups': cups,
      if (strength != null) 'strength': strength,
      if (rating != null) 'rating': rating,
      if (notes != null) 'notes': notes,
      'brewed_at': brewedAt.toIso8601String(),
    };
  }

  static double? _toDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _toIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
