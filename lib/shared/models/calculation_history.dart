class CalculationHistory {
  CalculationHistory({
    required this.id,
    required this.type,
    required this.inputs,
    required this.results,
    required this.calculatedAt,
  });

  final String id;
  final String type;
  final Map<String, dynamic> inputs;
  final Map<String, dynamic> results;
  final DateTime calculatedAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'inputs': inputs,
        'results': results,
        'calculatedAt': calculatedAt.toIso8601String(),
      };

  factory CalculationHistory.fromMap(Map<dynamic, dynamic> map) =>
      CalculationHistory(
        id: map['id'] as String,
        type: map['type'] as String,
        inputs: Map<String, dynamic>.from(map['inputs'] as Map),
        results: Map<String, dynamic>.from(map['results'] as Map),
        calculatedAt: DateTime.parse(map['calculatedAt'] as String),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalculationHistory && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
