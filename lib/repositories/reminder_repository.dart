import '../models/reminder.dart';
import '../services/database_service.dart';

/// Accès aux données des rappels.
class ReminderRepository {
  ReminderRepository(this._databaseService);

  final DatabaseService _databaseService;

  Future<List<Reminder>> getAll() async {
    final db = await _databaseService.database;
    final rows = await db.query('reminders', orderBy: 'due_date ASC');
    return rows.map(Reminder.fromMap).toList();
  }

  Future<List<Reminder>> getUpcoming({int limit = 5}) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'reminders',
      where: 'is_done = 0',
      orderBy: 'due_date ASC',
      limit: limit,
    );
    return rows.map(Reminder.fromMap).toList();
  }

  Future<Reminder> add(Reminder reminder) async {
    final db = await _databaseService.database;
    final id = await db.insert('reminders', reminder.toMap()..remove('id'));
    return reminder.copyWith(id: id);
  }

  Future<void> update(Reminder reminder) async {
    assert(reminder.id != null, 'Impossible de mettre à jour un rappel sans id.');
    final db = await _databaseService.database;
    await db.update(
      'reminders',
      reminder.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _databaseService.database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
