/// 질문 유형 enum
enum SurveyQuestionType {
  checkbox, // 기본 체크박스 (텍스트만)
  checkboxWithIcon, // 이모지 + 설명 포함 체크박스
  rating, // 👎😐👍 레이팅 스타일
  imageGrid, // 이미지 그리드 선택
  multiRating, // 여러 항목을 한 화면에서 레이팅 (맛취향, 향미취향)
}

/// Model for multi-rating items (used in multiRating question type)
/// Each item appears as a separate rating row on the same screen
class MultiRatingItem {
  final String id;
  final String question;
  final String description;
  final bool
  hasNeutral; // true: 3 options (싫어요/보통/좋아요), false: 2 options (싫어요/좋아요)

  const MultiRatingItem({
    required this.id,
    required this.question,
    required this.description,
    this.hasNeutral = true,
  });

  factory MultiRatingItem.fromJson(Map<String, dynamic> json) {
    return MultiRatingItem(
      id: json['id'] as String,
      question: json['question'] as String,
      description: json['description'] as String? ?? '',
      hasNeutral: json['hasNeutral'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'description': description,
      'hasNeutral': hasNeutral,
    };
  }
}

/// Model for survey questions
class SurveyQuestionModel {
  final int step;
  final String question;
  final String description;
  final List<SurveyOptionModel> options;
  final bool allowMultiple;
  final SurveyQuestionType questionType; // 질문 유형 (추가)
  final List<MultiRatingItem>? multiRatingItems; // For multiRating type
  final String? category; // 섹션 카테고리 (기본 맛 취향, 특성 향미 취향 등)

  const SurveyQuestionModel({
    required this.step,
    required this.question,
    required this.description,
    this.options = const [],
    this.allowMultiple = false,
    this.questionType = SurveyQuestionType.checkboxWithIcon, // 기본값
    this.multiRatingItems,
    this.category,
  });

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionModel(
      step: json['step'] as int,
      question: json['question'] as String,
      description: json['description'] as String? ?? '',
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
                .map(
                  (e) => SurveyOptionModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
      allowMultiple: json['allowMultiple'] as bool? ?? false,
      questionType: SurveyQuestionType.values.firstWhere(
        (e) => e.name == json['questionType'],
        orElse: () => SurveyQuestionType.checkboxWithIcon,
      ),
      multiRatingItems: json['multiRatingItems'] != null
          ? (json['multiRatingItems'] as List<dynamic>)
                .map((e) => MultiRatingItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'question': question,
      'description': description,
      'options': options.map((e) => e.toJson()).toList(),
      'allowMultiple': allowMultiple,
      'questionType': questionType.name,
      if (multiRatingItems != null)
        'multiRatingItems': multiRatingItems!.map((e) => e.toJson()).toList(),
      if (category != null) 'category': category,
    };
  }
}

/// Model for survey options
class SurveyOptionModel {
  final String id;
  final String label;
  final String? icon;
  final String? description;

  const SurveyOptionModel({
    required this.id,
    required this.label,
    this.icon,
    this.description,
  });

  factory SurveyOptionModel.fromJson(Map<String, dynamic> json) {
    return SurveyOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      if (icon != null) 'icon': icon,
      if (description != null) 'description': description,
    };
  }
}
