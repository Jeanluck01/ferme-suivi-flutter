/// Type d'activité agricole réalisée sur une culture.
enum ActivityType {
  arrosage,
  fertilisation,
  traitement,
  desherbage,
  recolte,
  autre;

  String get label {
    switch (this) {
      case ActivityType.arrosage:
        return 'Arrosage';
      case ActivityType.fertilisation:
        return 'Fertilisation';
      case ActivityType.traitement:
        return 'Traitement';
      case ActivityType.desherbage:
        return 'Désherbage';
      case ActivityType.recolte:
        return 'Récolte';
      case ActivityType.autre:
        return 'Autre';
    }
  }

  static ActivityType fromName(String name) {
    return ActivityType.values.firstWhere(
      (type) => type.name == name,
      orElse: () => ActivityType.autre,
    );
  }
}

/// Une activité effectuée sur une culture (arrosage, fertilisation, etc.).
class Activity {
  final int? id;
  final int cropId;
  final ActivityType type;
  final DateTime date;
  final String? notes;

  const Activity({
    this.id,
    required this.cropId,
    required this.type,
    required this.date,
    this.notes,
  });

  Activity copyWith({
    int? id,
    int? cropId,
    ActivityType? type,
    DateTime? date,
    String? notes,
  }) {
    return Activity(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      type: type ?? this.type,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'crop_id': cropId,
      'type': type.name,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Activity.fromMap(Map<String, Object?> map) {
    return Activity(
      id: map['id'] as int?,
      cropId: map['crop_id'] as int,
      type: ActivityType.fromName(map['type'] as String),
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cropId == other.cropId &&
          type == other.type &&
          date == other.date &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(id, cropId, type, date, notes);
}
