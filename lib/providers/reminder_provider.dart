import 'package:flutter/foundation.dart';

import '../models/reminder.dart';
import '../repositories/reminder_repository.dart';

/// Expose l'état des rappels à l'interface et gère leur persistance.
class ReminderProvider extends ChangeNotifier {
  ReminderProvider(this._repository);

  final ReminderRepository _repository;

  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => List.unmodifiable(_reminders);
  bool get isLoading => _isLoading;

  List<Reminder> get upcoming {
    final pending = _reminders.where((r) => !r.isDone).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return pending.take(5).toList();
  }

  int get overdueCount => _reminders.where((r) => r.isOverdue).length;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _reminders = await _repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> add(Reminder reminder) async {
    final added = await _repository.add(reminder);
    _reminders = [..._reminders, added]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  Future<void> toggleDone(Reminder reminder) async {
    final updated = reminder.copyWith(isDone: !reminder.isDone);
    await _repository.update(updated);
    _reminders = [
      for (final existing in _reminders)
        if (existing.id == updated.id) updated else existing,
    ];
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    _reminders = _reminders.where((r) => r.id != id).toList();
    notifyListeners();
  }
}
