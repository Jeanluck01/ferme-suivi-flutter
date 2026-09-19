import '../models/crop.dart';
import '../services/database_service.dart';

/// Accès aux données des cultures. Isole le SQL du reste de l'application.
class CropRepository {
  CropRepository(this._databaseService);

  final DatabaseService _databaseService;

  Future<List<Crop>> getAll() async {
    final db = await _databaseService.database;
    final rows = await db.query('crops', orderBy: 'planting_date DESC');
    return rows.map(Crop.fromMap).toList();
  }

  Future<Crop?> getById(int id) async {
    final db = await _databaseService.database;
    final rows = await db.query('crops', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Crop.fromMap(rows.first);
  }

  Future<Crop> add(Crop crop) async {
    final db = await _databaseService.database;
    final id = await db.insert('crops', crop.toMap()..remove('id'));
    return crop.copyWith(id: id);
  }

  Future<void> update(Crop crop) async {
    assert(crop.id != null, 'Impossible de mettre à jour une culture sans id.');
    final db = await _databaseService.database;
    await db.update(
      'crops',
      crop.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [crop.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _databaseService.database;
    await db.delete('crops', where: 'id = ?', whereArgs: [id]);
  }
}
