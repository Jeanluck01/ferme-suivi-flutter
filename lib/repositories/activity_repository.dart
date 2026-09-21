import '../models/activity.dart';
import '../services/database_service.dart';

/// Accès aux données des activités (carnet d'activités).
class ActivityRepository {
  ActivityRepository(this._databaseService);

  final DatabaseService _databaseService;

  Future<List<Activity>> getAll() async {
    final db = await _databaseService.database;
    final rows = await db.query('activities', orderBy: 'date DESC');
    return rows.map(Activity.fromMap).toList();
  }

  Future<List<Activity>> getByCrop(int cropId) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'activities',
      where: 'crop_id = ?',
      whereArgs: [cropId],
      orderBy: 'date DESC',
    );
    return rows.map(Activity.fromMap).toList();
  }

  Future<List<Activity>> getRecent({int limit = 5}) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      'activities',
      orderBy: 'date DESC',
      limit: limit,
    );
    return rows.map(Activity.fromMap).toList();
  }

  Future<Activity> add(Activity activity) async {
    final db = await _databaseService.database;
    final id = await db.insert('activities', activity.toMap()..remove('id'));
    return activity.copyWith(id: id);
  }

  Future<void> update(Activity activity) async {
    assert(activity.id != null, 'Impossible de mettre à jour une activité sans id.');
    final db = await _databaseService.database;
    await db.update(
      'activities',
      activity.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _databaseService.database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }
}
