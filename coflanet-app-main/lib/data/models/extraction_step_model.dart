/// Extraction Step Type Enum
enum ExtractionStepType {
  preInfusion,
  blooming,
  mainExtraction,
  additionalExtraction,
}

/// Extraction Step Model for Espresso Settings
class ExtractionStep {
  final String id;
  final ExtractionStepType type;
  final String name;
  final Duration duration;
  final double pressure;
  final int temperature;
  final bool isRequired;

  const ExtractionStep({
    required this.id,
    required this.type,
    required this.name,
    required this.duration,
    required this.pressure,
    required this.temperature,
    this.isRequired = false,
  });

  ExtractionStep copyWith({
    String? id,
    ExtractionStepType? type,
    String? name,
    Duration? duration,
    double? pressure,
    int? temperature,
    bool? isRequired,
  }) {
    return ExtractionStep(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      pressure: pressure ?? this.pressure,
      temperature: temperature ?? this.temperature,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
