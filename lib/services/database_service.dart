import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Ouvre et gère la base de données SQLite locale de l'application.
///
/// Un [DatabaseFactory] personnalisé peut être fourni (ex: `databaseFactoryFfi`
/// dans les tests) pour exécuter SQLite sur une machine de développement sans
/// émulateur Android/iOS.
class DatabaseService {
  DatabaseService({this.factory, String? databaseName})
      : _databaseName = databaseName ?? 'ferme_suivi.db';

  final DatabaseFactory? factory;
  final String _databaseName;
  Database? _database;

  static const int schemaVersion = 1;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    final opened = await _open();
    _database = opened;
    return opened;
  }

  Future<Database> _open() async {
    final resolvedFactory = factory ?? databaseFactory;
    final path = _databaseName == inMemoryDatabasePath
        ? inMemoryDatabasePath
        : p.join(await resolvedFactory.getDatabasesPath(), _databaseName);

    return resolvedFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE crops (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              type TEXT NOT NULL,
              plot TEXT NOT NULL,
              planting_date TEXT NOT NULL,
              stage TEXT NOT NULL,
              expected_harvest_date TEXT,
              notes TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE activities (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              crop_id INTEGER NOT NULL,
              type TEXT NOT NULL,
              date TEXT NOT NULL,
              notes TEXT,
              FOREIGN KEY (crop_id) REFERENCES crops (id) ON DELETE CASCADE
            )
          ''');
          await db.execute('''
            CREATE TABLE reminders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              due_date TEXT NOT NULL,
              crop_id INTEGER,
              is_done INTEGER NOT NULL DEFAULT 0,
              notes TEXT,
              FOREIGN KEY (crop_id) REFERENCES crops (id) ON DELETE SET NULL
            )
          ''');
        },
      ),
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
