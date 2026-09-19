import 'package:ferme_suivi/models/crop.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Crop', () {
    test('toMap/fromMap round-trip conserve toutes les données', () {
      final crop = Crop(
        id: 1,
        name: 'Tomates',
        type: 'Tomate',
        plot: 'Parcelle Nord',
        plantingDate: DateTime(2026, 3, 12),
        stage: CropStage.croissance,
        expectedHarvestDate: DateTime(2026, 7, 15),
        notes: 'Variété cœur de bœuf',
      );

      final restored = Crop.fromMap(crop.toMap());

      expect(restored, equals(crop));
    });

    test('fromMap gère une date de récolte absente', () {
      final map = {
        'id': 2,
        'name': 'Maïs',
        'type': 'Maïs',
        'plot': 'Parcelle Est',
        'planting_date': DateTime(2026, 4, 1).toIso8601String(),
        'stage': 'semis',
        'expected_harvest_date': null,
        'notes': null,
      };

      final crop = Crop.fromMap(map);

      expect(crop.expectedHarvestDate, isNull);
      expect(crop.stage, CropStage.semis);
    });

    test('copyWith remplace uniquement les champs fournis', () {
      final crop = Crop(
        name: 'Tomates',
        type: 'Tomate',
        plot: 'Nord',
        plantingDate: DateTime(2026, 3, 12),
        stage: CropStage.semis,
      );

      final updated = crop.copyWith(stage: CropStage.recolte);

      expect(updated.stage, CropStage.recolte);
      expect(updated.name, crop.name);
      expect(updated.plantingDate, crop.plantingDate);
    });

    test('CropStage.fromName retombe sur semis pour une valeur inconnue', () {
      expect(CropStage.fromName('inconnu'), CropStage.semis);
      expect(CropStage.fromName('recolte'), CropStage.recolte);
    });
  });
}
