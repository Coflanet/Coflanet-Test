/// Step type for determining UI rendering
enum TimerStepType {
  /// Preparation step - shows illustration, manual "다음" advance
  preparation,

  /// Brewing/extraction step - shows circular countdown timer
  brewing,

  /// Waiting step - shows timer, user waits for drip-through
  waiting,
}

/// Model for coffee timer steps
class TimerStepModel {
  final int stepNumber;
  final String title;
  final String description;
  final int durationSeconds;
  final int? waterAmount; // in grams
  final TimerStepType stepType;
  final String? illustrationEmoji; // Placeholder emoji for illustration area
  final String? actionText; // Emphasized instruction (e.g. "원두 18g을 균일하게 분쇄")

  const TimerStepModel({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.durationSeconds,
    this.waterAmount,
    this.stepType = TimerStepType.brewing,
    this.illustrationEmoji,
    this.actionText,
  });

  /// Whether this step shows a countdown timer
  bool get hasTimer =>
      stepType == TimerStepType.brewing || stepType == TimerStepType.waiting;

  /// Whether this step is a manual preparation step
  bool get isPreparation => stepType == TimerStepType.preparation;

  factory TimerStepModel.fromJson(Map<String, dynamic> json) {
    return TimerStepModel(
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      durationSeconds: json['durationSeconds'] as int,
      waterAmount: json['waterAmount'] as int?,
      stepType: TimerStepType.values.firstWhere(
        (e) => e.name == (json['stepType'] as String? ?? 'brewing'),
        orElse: () => TimerStepType.brewing,
      ),
      illustrationEmoji: json['illustrationEmoji'] as String?,
      actionText: json['actionText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'title': title,
      'description': description,
      'durationSeconds': durationSeconds,
      if (waterAmount != null) 'waterAmount': waterAmount,
      'stepType': stepType.name,
      if (illustrationEmoji != null) 'illustrationEmoji': illustrationEmoji,
      if (actionText != null) 'actionText': actionText,
    };
  }
}

/// Flavor/aroma tag for completion screen
class AromaTagModel {
  final String emoji;
  final String name;

  const AromaTagModel({required this.emoji, required this.name});

  factory AromaTagModel.fromJson(Map<String, dynamic> json) {
    return AromaTagModel(
      emoji: json['emoji'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'emoji': emoji, 'name': name};
  }
}

/// Timer recipe configuration
class TimerRecipeModel {
  final String id;
  final String name;
  final String coffeeType; // 'handDrip' or 'espresso'
  final int coffeeAmount; // in grams
  final int waterAmount; // in ml
  final int totalDurationSeconds;
  final List<TimerStepModel> steps;
  final String? completionMessage;
  final String? aromaDescription;
  final List<AromaTagModel> aromaTags;

  const TimerRecipeModel({
    required this.id,
    required this.name,
    required this.coffeeType,
    required this.coffeeAmount,
    required this.waterAmount,
    required this.totalDurationSeconds,
    required this.steps,
    this.completionMessage,
    this.aromaDescription,
    this.aromaTags = const [],
  });

  factory TimerRecipeModel.fromJson(Map<String, dynamic> json) {
    return TimerRecipeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      coffeeType: json['coffeeType'] as String,
      coffeeAmount: json['coffeeAmount'] as int,
      waterAmount: json['waterAmount'] as int,
      totalDurationSeconds: json['totalDurationSeconds'] as int,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => TimerStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      completionMessage: json['completionMessage'] as String?,
      aromaDescription: json['aromaDescription'] as String?,
      aromaTags: json['aromaTags'] != null
          ? (json['aromaTags'] as List<dynamic>)
                .map((e) => AromaTagModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coffeeType': coffeeType,
      'coffeeAmount': coffeeAmount,
      'waterAmount': waterAmount,
      'totalDurationSeconds': totalDurationSeconds,
      'steps': steps.map((e) => e.toJson()).toList(),
      if (completionMessage != null) 'completionMessage': completionMessage,
      if (aromaDescription != null) 'aromaDescription': aromaDescription,
      if (aromaTags.isNotEmpty)
        'aromaTags': aromaTags.map((e) => e.toJson()).toList(),
    };
  }
}
