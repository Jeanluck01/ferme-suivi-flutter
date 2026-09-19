import 'package:ferme_suivi/models/crop.dart';
import 'package:ferme_suivi/repositories/crop_repository.dart';
import 'package:ferme_suivi/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  late DatabaseService databaseService;
  late CropRepository repository;

  setUp(() {
    databaseService = DatabaseService(
      factory: databaseFactoryFfiNoIsolate,
      databaseName: inMemoryDatabasePath,
    );
    repository = CropRepository(databaseService);
  });

  tearDown(() async {
    await databaseService.close();
  });

  test('add() persiste une culture et lui attribue un id', () async {
    final crop = Crop(
      name: 'Tomates',
      type: 'Tomate',
      plot: 'Nord',
      plantingDate: DateTime(2026, 3, 12),
      stage: CropStage.semis,
    );

    final added = await repository.add(crop);

    expect(added.id, isNotNull);
    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.name, 'Tomates');
  });

  test('update() modifie une culture existante', () async {
    final added = await repository.add(
      Crop(
        name: 'Maïs',
        type: 'Maïs',
        plot: 'Est',
        plantingDate: DateTime(2026, 4, 1),
        stage: CropStage.semis,
      ),
    );

    await repository.update(added.copyWith(stage: CropStage.recolte));

    final updated = await repository.getById(added.id!);
    expect(updated?.stage, CropStage.recolte);
  });

  test('delete() supprime une culture', () async {
    final added = await repository.add(
      Crop(
        name: 'Courgettes',
        type: 'Courgette',
        plot: 'Sud',
        plantingDate: DateTime(2026, 5, 1),
        stage: CropStage.croissance,
      ),
    );

    await repository.delete(added.id!);

    expect(await repository.getById(added.id!), isNull);
    expect(await repository.getAll(), isEmpty);
  });

  test('getAll() trie les cultures par date de semis décroissante', () async {
    await repository.add(
      Crop(
        name: 'Ancienne',
        type: 'Type',
        plot: 'A',
        plantingDate: DateTime(2026, 1, 1),
        stage: CropStage.semis,
      ),
    );
    await repository.add(
      Crop(
        name: 'Récente',
        type: 'Type',
        plot: 'B',
        plantingDate: DateTime(2026, 6, 1),
        stage: CropStage.semis,
      ),
    );

    final all = await repository.getAll();

    expect(all.first.name, 'Récente');
    expect(all.last.name, 'Ancienne');
  });
}
