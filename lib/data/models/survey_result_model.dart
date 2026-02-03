/// Model for survey results
class SurveyResultModel {
  final String coffeeType;
  final String coffeeTypeDescription;
  final TasteProfileModel tasteProfile;
  final List<CoffeeRecommendationModel> recommendations;

  const SurveyResultModel({
    required this.coffeeType,
    required this.coffeeTypeDescription,
    required this.tasteProfile,
    required this.recommendations,
  });

  factory SurveyResultModel.fromJson(Map<String, dynamic> json) {
    return SurveyResultModel(
      coffeeType: json['coffeeType'] as String,
      coffeeTypeDescription: json['coffeeTypeDescription'] as String,
      tasteProfile: TasteProfileModel.fromJson(
          json['tasteProfile'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) =>
              CoffeeRecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coffeeType': coffeeType,
      'coffeeTypeDescription': coffeeTypeDescription,
      'tasteProfile': tasteProfile.toJson(),
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
    };
  }
}

/// Model for taste profile
class TasteProfileModel {
  final int acidity;
  final int sweetness;
  final int bitterness;
  final int body;
  final int aroma;

  const TasteProfileModel({
    required this.acidity,
    required this.sweetness,
    required this.bitterness,
    required this.body,
    required this.aroma,
  });

  factory TasteProfileModel.fromJson(Map<String, dynamic> json) {
    return TasteProfileModel(
      acidity: json['acidity'] as int,
      sweetness: json['sweetness'] as int,
      bitterness: json['bitterness'] as int,
      body: json['body'] as int,
      aroma: json['aroma'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acidity': acidity,
      'sweetness': sweetness,
      'bitterness': bitterness,
      'body': body,
      'aroma': aroma,
    };
  }
}

/// Model for coffee recommendations
class CoffeeRecommendationModel {
  final String id;
  final String name;
  final String origin;
  final String roastLevel;
  final String description;
  final String? imageUrl;
  final TasteProfileModel tasteProfile;

  const CoffeeRecommendationModel({
    required this.id,
    required this.name,
    required this.origin,
    required this.roastLevel,
    required this.description,
    this.imageUrl,
    required this.tasteProfile,
  });

  factory CoffeeRecommendationModel.fromJson(Map<String, dynamic> json) {
    return CoffeeRecommendationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      origin: json['origin'] as String,
      roastLevel: json['roastLevel'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      tasteProfile: TasteProfileModel.fromJson(
          json['tasteProfile'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'roastLevel': roastLevel,
      'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'tasteProfile': tasteProfile.toJson(),
    };
  }
}
