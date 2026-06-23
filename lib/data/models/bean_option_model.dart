// 원두 옵션 lookup 모델 (get_bean_options RPC)
// DB는 snake_case, 로컬 더미는 camelCase를 쓸 수 있어 양방향 fallback 파싱.

/// 로스팅 단계 — roast_point(1~10) + 4단계 라벨
class RoastOption {
  final int point;
  final String levelCode;
  final String labelKo;

  const RoastOption({
    required this.point,
    required this.levelCode,
    required this.labelKo,
  });

  factory RoastOption.fromJson(Map<String, dynamic> json) {
    return RoastOption(
      point: (json['point'] as num?)?.toInt() ?? 0,
      levelCode:
          json['level_code'] as String? ?? json['levelCode'] as String? ?? '',
      labelKo: json['label_ko'] as String? ?? json['labelKo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'point': point,
    'level_code': levelCode,
    'label_ko': labelKo,
  };
}

/// 가공 방식
class ProcessOption {
  final String code;
  final String labelKo;

  const ProcessOption({required this.code, required this.labelKo});

  factory ProcessOption.fromJson(Map<String, dynamic> json) {
    return ProcessOption(
      code: json['code'] as String? ?? '',
      labelKo: json['label_ko'] as String? ?? json['labelKo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'label_ko': labelKo};
}

/// 향미 descriptor (SCA 플레이버 휠)
class FlavorDescriptor {
  final String category;
  final String? subCategory;
  final String descriptor;
  final String descriptorKo;

  const FlavorDescriptor({
    required this.category,
    this.subCategory,
    required this.descriptor,
    required this.descriptorKo,
  });

  factory FlavorDescriptor.fromJson(Map<String, dynamic> json) {
    return FlavorDescriptor(
      category: json['category'] as String? ?? '',
      subCategory:
          json['sub_category'] as String? ?? json['subCategory'] as String?,
      descriptor: json['descriptor'] as String? ?? '',
      descriptorKo:
          json['descriptor_ko'] as String? ??
          json['descriptorKo'] as String? ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'sub_category': subCategory,
    'descriptor': descriptor,
    'descriptor_ko': descriptorKo,
  };
}

/// get_bean_options 응답 묶음
class BeanOptions {
  final List<RoastOption> roastLevels;
  final List<ProcessOption> processMethods;
  final List<FlavorDescriptor> flavorDescriptors;

  const BeanOptions({
    this.roastLevels = const [],
    this.processMethods = const [],
    this.flavorDescriptors = const [],
  });

  factory BeanOptions.fromJson(Map<String, dynamic> json) {
    List<T> parse<T>(String key, T Function(Map<String, dynamic>) fromJson) {
      final list = json[key];
      if (list is List) {
        return list.whereType<Map<String, dynamic>>().map(fromJson).toList();
      }
      return <T>[];
    }

    return BeanOptions(
      roastLevels: parse('roast_levels', RoastOption.fromJson),
      processMethods: parse('process_methods', ProcessOption.fromJson),
      flavorDescriptors: parse('flavor_descriptors', FlavorDescriptor.fromJson),
    );
  }
}
