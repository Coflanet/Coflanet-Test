/// 시음 노트(커피 저널) 단일 항목 모델.
///
/// GetStorage(JSON) 저장용 — [toJson]/[fromJson] 로 직렬화한다.
/// 맛 5축([tasteValues])은 0~5 스케일로 보관해 [FlavorProfile]/레이더 차트와
/// 그대로 호환된다(키: acidity/body/sweetness/bitterness/balance).
class TastingNoteModel {
  /// 고유 id (생성 시각 기반)
  final String id;

  /// 원두명
  final String beanName;

  /// 시음 날짜
  final DateTime date;

  /// 별점 (1~5)
  final int rating;

  /// 맛 5축 값 (0~5). 키: acidity/body/sweetness/bitterness/balance
  final Map<String, double> tasteValues;

  /// 향미 태그
  final List<String> flavorTags;

  /// 메모
  final String memo;

  const TastingNoteModel({
    required this.id,
    required this.beanName,
    required this.date,
    required this.rating,
    required this.tasteValues,
    required this.flavorTags,
    required this.memo,
  });

  /// 맛 5축 기본값(중앙) — 신규 작성 폼 초기값
  static Map<String, double> get defaultTasteValues => {
    'acidity': 2.5,
    'body': 2.5,
    'sweetness': 2.5,
    'bitterness': 2.5,
    'balance': 2.5,
  };

  /// 맛 5축 키 순서 (산미/바디감/단맛/쓴맛/밸런스)
  static const List<String> tasteKeys = [
    'acidity',
    'body',
    'sweetness',
    'bitterness',
    'balance',
  ];

  /// 맛 축 키 → 한글 라벨
  static const Map<String, String> tasteLabels = {
    'acidity': '산미',
    'body': '바디감',
    'sweetness': '단맛',
    'bitterness': '쓴맛',
    'balance': '밸런스',
  };

  TastingNoteModel copyWith({
    String? id,
    String? beanName,
    DateTime? date,
    int? rating,
    Map<String, double>? tasteValues,
    List<String>? flavorTags,
    String? memo,
  }) {
    return TastingNoteModel(
      id: id ?? this.id,
      beanName: beanName ?? this.beanName,
      date: date ?? this.date,
      rating: rating ?? this.rating,
      tasteValues: tasteValues ?? this.tasteValues,
      flavorTags: flavorTags ?? this.flavorTags,
      memo: memo ?? this.memo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bean_name': beanName,
      'date': date.toIso8601String(),
      'rating': rating,
      'taste_values': tasteValues,
      'flavor_tags': flavorTags,
      'memo': memo,
    };
  }

  factory TastingNoteModel.fromJson(Map<String, dynamic> json) {
    final rawTaste = (json['taste_values'] as Map?) ?? const {};
    final taste = <String, double>{};
    rawTaste.forEach((key, value) {
      taste[key.toString()] = _toDouble(value);
    });

    final rawTags = (json['flavor_tags'] as List?) ?? const [];

    return TastingNoteModel(
      id: (json['id'] ?? '').toString(),
      beanName: (json['bean_name'] ?? '') as String,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      rating: _toInt(json['rating']),
      tasteValues: taste.isEmpty ? defaultTasteValues : taste,
      flavorTags: rawTags.map((e) => e.toString()).toList(),
      memo: (json['memo'] ?? '') as String,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
