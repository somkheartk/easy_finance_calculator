class SavedPlan {
  SavedPlan({
    required this.id,
    required this.type,
    required this.name,
    required this.inputs,
    required this.results,
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
  });

  final String id;
  final String type;
  final String name;
  final Map<String, dynamic> inputs;
  final Map<String, dynamic> results;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;

  SavedPlan copyWith({
    String? name,
    Map<String, dynamic>? inputs,
    Map<String, dynamic>? results,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return SavedPlan(
      id: id,
      type: type,
      name: name ?? this.name,
      inputs: inputs ?? this.inputs,
      results: results ?? this.results,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'name': name,
        'inputs': inputs,
        'results': results,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isFavorite': isFavorite,
      };

  factory SavedPlan.fromMap(Map<dynamic, dynamic> map) => SavedPlan(
        id: map['id'] as String,
        type: map['type'] as String,
        name: map['name'] as String,
        inputs: Map<String, dynamic>.from(map['inputs'] as Map),
        results: Map<String, dynamic>.from(map['results'] as Map),
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: map['updatedAt'] != null
            ? DateTime.parse(map['updatedAt'] as String)
            : null,
        isFavorite: map['isFavorite'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SavedPlan && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
