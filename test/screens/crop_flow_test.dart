import 'package:ferme_suivi/providers/crop_provider.dart';
import 'package:ferme_suivi/repositories/crop_repository.dart';
import 'package:ferme_suivi/screens/crops/crop_list_screen.dart';
import 'package:ferme_suivi/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  testWidgets(
    'parcours utilisateur : ajouter une culture depuis la liste vide '
    'jusqu\'à son apparition dans la liste',
    (tester) async {
      final databaseService = DatabaseService(
        factory: databaseFactoryFfiNoIsolate,
        databaseName: inMemoryDatabasePath,
      );
      final provider = CropProvider(CropRepository(databaseService));
      await provider.load();

      // Agrandit la fenêtre de test pour que tout le formulaire tienne sans
      // défilement (un ListView ne construit ses enfants hors-écran qu'au
      // moment du scroll).
      tester.view.physicalSize = const Size(1080, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Le provider doit englober le MaterialApp (et non l'inverse) pour
      // rester accessible aux écrans poussés sur la pile de navigation
      // (CropFormScreen), qui sont des routes distinctes de l'écran initial.
      await tester.pumpWidget(
        ChangeNotifierProvider<CropProvider>.value(
          value: provider,
          child: const MaterialApp(home: CropListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // 1. La liste est vide au démarrage.
      expect(find.text('Aucune culture pour le moment.\nAjoutez votre première culture.'),
          findsOneWidget);

      // 2. On ouvre le formulaire d'ajout.
      await tester.tap(find.byKey(const Key('add-crop-fab')));
      await tester.pumpAndSettle();

      // 3. On remplit les champs obligatoires.
      await tester.enterText(
          find.byKey(const Key('crop-name-field')), 'Tomates cerises');
      await tester.enterText(
          find.byKey(const Key('crop-type-field')), 'Tomate');
      await tester.enterText(
          find.byKey(const Key('crop-plot-field')), 'Parcelle Nord');

      // 4. On choisit la date de semis proposée par défaut (aujourd'hui).
      await tester.tap(find.text('Date de semis *'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // 5. On enregistre.
      await tester.tap(find.byKey(const Key('crop-save-button')));
      await tester.pumpAndSettle();

      // 6. La culture est bien revenue dans la liste.
      expect(find.text('Tomates cerises · Parcelle Nord'), findsOneWidget);
      expect(provider.crops, hasLength(1));
      expect(provider.crops.first.name, 'Tomates cerises');

      await databaseService.close();
    },
  );
}
