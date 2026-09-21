/// Stade de développement d'une culture.
enum CropStage {
  semis,
  croissance,
  floraison,
  recolte,
  terminee;

  String get label {
    switch (this) {
      case CropStage.semis:
        return 'Semis';
      case CropStage.croissance:
        return 'Croissance';
      case CropStage.floraison:
        return 'Floraison';
      case CropStage.recolte:
        return 'Récolte';
      case CropStage.terminee:
        return 'Terminée';
    }
  }

  static CropStage fromName(String name) {
    return CropStage.values.firstWhere(
      (stage) => stage.name == name,
      orElse: () => CropStage.semis,
    );
  }
}

/// Une culture suivie par l'utilisateur (ex: "Tomates - Parcelle Nord").
class Crop {
  final int? id;
  final String name;
  final String type;
  final String plot;
  final DateTime plantingDate;
  final CropStage stage;
  final DateTime? expectedHarvestDate;
  final String? notes;

  const Crop({
    this.id,
    required this.name,
    required this.type,
    required this.plot,
    required this.plantingDate,
    required this.stage,
    this.expectedHarvestDate,
    this.notes,
  });

  Crop copyWith({
    int? id,
    String? name,
    String? type,
    String? plot,
    DateTime? plantingDate,
    CropStage? stage,
    DateTime? expectedHarvestDate,
    bool clearExpectedHarvestDate = false,
    String? notes,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      plot: plot ?? this.plot,
      plantingDate: plantingDate ?? this.plantingDate,
      stage: stage ?? this.stage,
      expectedHarvestDate: clearExpectedHarvestDate
          ? null
          : (expectedHarvestDate ?? this.expectedHarvestDate),
      notes: notes ?? this.notes,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'plot': plot,
      'planting_date': plantingDate.toIso8601String(),
      'stage': stage.name,
      'expected_harvest_date': expectedHarvestDate?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Crop.fromMap(Map<String, Object?> map) {
    return Crop(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      plot: map['plot'] as String,
      plantingDate: DateTime.parse(map['planting_date'] as String),
      stage: CropStage.fromName(map['stage'] as String),
      expectedHarvestDate: map['expected_harvest_date'] != null
          ? DateTime.parse(map['expected_harvest_date'] as String)
          : null,
      notes: map['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Crop &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          plot == other.plot &&
          plantingDate == other.plantingDate &&
          stage == other.stage &&
          expectedHarvestDate == other.expectedHarvestDate &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        type,
        plot,
        plantingDate,
        stage,
        expectedHarvestDate,
        notes,
      );
}
