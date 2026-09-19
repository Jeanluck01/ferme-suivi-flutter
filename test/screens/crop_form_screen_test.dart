import 'package:ferme_suivi/providers/crop_provider.dart';
import 'package:ferme_suivi/repositories/crop_repository.dart';
import 'package:ferme_suivi/screens/crops/crop_form_screen.dart';
import 'package:ferme_suivi/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  Widget buildTestApp(CropProvider provider) {
    return MaterialApp(
      home: ChangeNotifierProvider<CropProvider>.value(
        value: provider,
        child: const CropFormScreen(),
      ),
    );
  }

  late CropProvider provider;

  setUp(() {
    final databaseService = DatabaseService(
      factory: databaseFactoryFfiNoIsolate,
      databaseName: inMemoryDatabasePath,
    );
    provider = CropProvider(CropRepository(databaseService));
  });

  // Agrandit la fenêtre de test pour que tout le formulaire tienne sans
  // défilement : un ListView ne construit ses enfants hors-écran qu'au
  // moment du scroll, ce qui empêche sinon `find.byKey` de les localiser.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets(
    'affiche des messages d\'erreur explicites quand le formulaire est vide',
    (tester) async {
      useTallSurface(tester);
      await tester.pumpWidget(buildTestApp(provider));

      await tester.tap(find.byKey(const Key('crop-save-button')));
      await tester.pumpAndSettle();

      expect(find.text('Le nom est requis.'), findsOneWidget);
      expect(find.text('Le type est requis.'), findsOneWidget);
      expect(find.text('La parcelle est requise.'), findsOneWidget);
      expect(find.text('La date de semis est requise.'), findsOneWidget);
      expect(provider.crops, isEmpty);
    },
  );

  testWidgets(
    'un formulaire complet (hors date) ne fait pas apparaître d\'erreur de champ texte',
    (tester) async {
      useTallSurface(tester);
      await tester.pumpWidget(buildTestApp(provider));

      await tester.enterText(
          find.byKey(const Key('crop-name-field')), 'Tomates');
      await tester.enterText(
          find.byKey(const Key('crop-type-field')), 'Tomate');
      await tester.enterText(
          find.byKey(const Key('crop-plot-field')), 'Nord');

      await tester.tap(find.byKey(const Key('crop-save-button')));
      await tester.pumpAndSettle();

      expect(find.text('Le nom est requis.'), findsNothing);
      expect(find.text('Le type est requis.'), findsNothing);
      expect(find.text('La parcelle est requise.'), findsNothing);
      // La date de semis n'a pas été renseignée : l'enregistrement est bloqué.
      expect(find.text('La date de semis est requise.'), findsOneWidget);
      expect(provider.crops, isEmpty);
    },
  );
}
