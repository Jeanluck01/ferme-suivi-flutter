import 'package:ferme_suivi/models/reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reminder.isOverdue', () {
    test('un rappel non fait avec échéance passée est en retard', () {
      final reminder = Reminder(
        title: 'Arroser',
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(reminder.isOverdue, isTrue);
    });

    test('un rappel non fait avec échéance future n\'est pas en retard', () {
      final reminder = Reminder(
        title: 'Arroser',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );

      expect(reminder.isOverdue, isFalse);
    });

    test('un rappel fait n\'est jamais en retard, même en retard de date', () {
      final reminder = Reminder(
        title: 'Arroser',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        isDone: true,
      );

      expect(reminder.isOverdue, isFalse);
    });

    test('un rappel dont l\'échéance est aujourd\'hui n\'est pas en retard', () {
      final reminder = Reminder(title: 'Arroser', dueDate: DateTime.now());

      expect(reminder.isOverdue, isFalse);
    });
  });

  group('Reminder', () {
    test('toMap/fromMap round-trip conserve toutes les données', () {
      final reminder = Reminder(
        id: 5,
        title: 'Traiter les pommiers',
        dueDate: DateTime(2026, 9, 20),
        cropId: 3,
        isDone: true,
        notes: 'Traitement bio',
      );

      final restored = Reminder.fromMap(reminder.toMap());

      expect(restored, equals(reminder));
    });
  });
}
