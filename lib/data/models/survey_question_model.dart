/// 질문 유형 enum
enum SurveyQuestionType {
  checkbox, // 기본 체크박스 (텍스트만)
  checkboxWithIcon, // 이모지 + 설명 포함 체크박스
  rating, // 👎😐👍 레이팅 스타일
  imageGrid, // 이미지 그리드 선택
}

/// Model for survey questions
class SurveyQuestionModel {
  final int step;
  final String question;
  final String description;
  final List<SurveyOptionModel> options;
  final bool allowMultiple;
  final SurveyQuestionType questionType; // 질문 유형 (추가)

  const SurveyQuestionModel({
    required this.step,
    required this.question,
    required this.description,
    required this.options,
    this.allowMultiple = false,
    this.questionType = SurveyQuestionType.checkboxWithIcon, // 기본값
  });

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionModel(
      step: json['step'] as int,
      question: json['question'] as String,
      description: json['description'] as String? ?? '',
      options: (json['options'] as List<dynamic>)
          .map((e) => SurveyOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowMultiple: json['allowMultiple'] as bool? ?? false,
      questionType: SurveyQuestionType.values.firstWhere(
        (e) => e.name == json['questionType'],
        orElse: () => SurveyQuestionType.checkboxWithIcon,
      ),
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
