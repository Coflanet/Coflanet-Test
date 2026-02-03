/// Model for survey questions
class SurveyQuestionModel {
  final int step;
  final String question;
  final String description;
  final List<SurveyOptionModel> options;
  final bool allowMultiple;

  const SurveyQuestionModel({
    required this.step,
    required this.question,
    required this.description,
    required this.options,
    this.allowMultiple = false,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'question': question,
      'description': description,
      'options': options.map((e) => e.toJson()).toList(),
      'allowMultiple': allowMultiple,
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
