# Ferme Suivi

Application mobile Flutter de suivi de cultures pour petits exploitants et jardiniers,
**entièrement fonctionnelle hors ligne**. Projet réalisé dans le cadre du cours
*Développement Mobile — Niveau approfondi* (OIF / DCLIC).

## Fonctionnalités

- **Tableau de bord** : nombre de cultures actives, rappels en retard, conseil du moment,
  prochains rappels et activités récentes.
- **Gestion des cultures** : créer, consulter, modifier, supprimer une culture (nom, type,
  parcelle, date de semis, stade, date de récolte prévue, notes).
- **Carnet d'activités** : enregistrer une activité (arrosage, fertilisation, traitement,
  désherbage, récolte, autre) liée à une culture et consulter son historique.
- **Rappels / alertes** : créer des rappels avec échéance, les associer à une culture, les
  marquer comme faits, visualiser les retards.
- **Conseils saisonniers** : conseils pratiques filtrés automatiquement selon la saison en
  cours (contenu embarqué, pas de connexion requise).

Toutes les données (cultures, activités, rappels) sont stockées **localement** sur
l'appareil via SQLite (`sqflite`) : l'application fonctionne à 100 % sans connexion réseau.

## Documentation de conception (semaine 5)

- [`docs/01-cahier-des-charges.md`](docs/01-cahier-des-charges.md)
- [`docs/02-conception-visuelle.md`](docs/02-conception-visuelle.md) — wireframes, flux
  utilisateurs, style
- [`docs/03-conception-technique.md`](docs/03-conception-technique.md) — architecture,
  classes métier, packages, tests, déploiement

## Architecture

```
lib/
├── main.dart          # Point d'entrée, injection des providers
├── app.dart            # MaterialApp, thème
├── models/              # Crop, Activity, Reminder, SeasonalTip
├── services/             # DatabaseService (SQLite), SeasonalAdviceService
├── repositories/          # Accès aux données (CRUD), isolent le SQL
├── providers/              # ChangeNotifier (state management via Provider)
├── screens/                 # Écrans (dashboard, crops, reminders, advice, settings)
├── widgets/                  # Widgets réutilisables
└── navigation/                 # Coquille de navigation (BottomNavigationBar)
```

Voir [`docs/03-conception-technique.md`](docs/03-conception-technique.md) pour le détail des
choix techniques (gestion d'état, stockage, packages, tests, performance).

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal stable, testé avec
  Flutter 3.47.5 / Dart 3.13.4).
- Un appareil ou émulateur Android/iOS pour l'exécution (Android Studio / Xcode selon la
  plateforme).

## Installation et lancement

```bash
git clone <url-du-depot>
cd ferme-suivi-flutter
flutter pub get
flutter run
```

## Tests

```bash
flutter analyze   # analyse statique — aucun problème
flutter test      # 16 tests : modèles, repository SQLite, widgets, parcours utilisateur
```

Les tests de repository et d'écrans utilisent `sqflite_common_ffi` (mode
`databaseFactoryFfiNoIsolate`) pour exécuter une vraie base SQLite en mémoire sans émulateur.

Couverture :
- **Tests unitaires** : sérialisation des modèles (`Crop`, `Reminder`), logique métier
  (`Reminder.isOverdue`).
- **Test de repository** : CRUD complet de `CropRepository` sur une base SQLite en mémoire.
- **Tests de widgets** : validation du formulaire de culture (messages d'erreur explicites).
- **Test de parcours utilisateur** : ajout d'une culture depuis la liste vide jusqu'à son
  apparition dans la liste, à travers l'UI réelle (formulaire, sélecteur de date, navigation).

## Préparer une version installable

```bash
flutter build appbundle   # Android App Bundle (.aab)
# ou
flutter build apk         # APK installable directement
```

*(Nécessite l'Android SDK configuré localement ; non exécuté dans cet environnement de
développement qui ne dispose pas du SDK Android.)*

## Démonstration

L'application s'ouvre sur le tableau de bord. Parcours de démonstration suggéré :

1. Ajouter une culture depuis l'onglet **Cultures** (bouton `+`).
2. Ouvrir la fiche de la culture et enregistrer une activité (arrosage, fertilisation…).
3. Créer un rappel depuis l'onglet **Rappels**, l'associer à la culture.
4. Revenir à l'**Accueil** pour voir le résumé (cultures actives, prochains rappels,
   activités récentes, conseil du moment).
5. Consulter l'onglet **Conseils** pour les recommandations de la saison en cours.

## Limites assumées

- Pas de compte utilisateur ni de synchronisation cloud (usage individuel, hors ligne).
- Pas de notifications système programmées (rappels consultés dans l'application).
- Conseils saisonniers en contenu fixe embarqué (non modifiable par l'utilisateur).

Détails complets dans [`docs/01-cahier-des-charges.md`](docs/01-cahier-des-charges.md).
