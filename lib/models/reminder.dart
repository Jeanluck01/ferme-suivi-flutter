/// Un rappel de tâche à effectuer, avec une échéance.
class Reminder {
  final int? id;
  final String title;
  final DateTime dueDate;
  final int? cropId;
  final bool isDone;
  final String? notes;

  const Reminder({
    this.id,
    required this.title,
    required this.dueDate,
    this.cropId,
    this.isDone = false,
    this.notes,
  });

  /// Un rappel est en retard s'il n'est pas fait et que son échéance est passée.
  bool get isOverdue {
    if (isDone) return false;
    final today = DateTime.now();
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return dueDateOnly.isBefore(todayOnly);
  }

  Reminder copyWith({
    int? id,
    String? title,
    DateTime? dueDate,
    int? cropId,
    bool clearCropId = false,
    bool? isDone,
    String? notes,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      cropId: clearCropId ? null : (cropId ?? this.cropId),
      isDone: isDone ?? this.isDone,
      notes: notes ?? this.notes,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'due_date': dueDate.toIso8601String(),
      'crop_id': cropId,
      'is_done': isDone ? 1 : 0,
      'notes': notes,
    };
  }

  factory Reminder.fromMap(Map<String, Object?> map) {
    return Reminder(
      id: map['id'] as int?,
      title: map['title'] as String,
      dueDate: DateTime.parse(map['due_date'] as String),
      cropId: map['crop_id'] as int?,
      isDone: (map['is_done'] as int) == 1,
      notes: map['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reminder &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          dueDate == other.dueDate &&
          cropId == other.cropId &&
          isDone == other.isDone &&
          notes == other.notes;

  @override
  int get hashCode =>
      Object.hash(id, title, dueDate, cropId, isDone, notes);
}
