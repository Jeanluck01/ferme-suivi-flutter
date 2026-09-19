# Dossier de conception technique Flutter — Ferme Suivi

## 1. Architecture générale

Architecture en couches, inspirée d'un pattern repository simple :

```
lib/
├── main.dart                 # Point d'entrée, initialisation DB, MultiProvider
├── app.dart                  # MaterialApp, thème, RootShell
├── models/                   # Classes métier (entités)
│   ├── crop.dart
│   ├── activity.dart
│   ├── reminder.dart
│   └── seasonal_tip.dart
├── services/
│   ├── database_service.dart     # Ouverture DB SQLite, création des tables
│   └── seasonal_advice_service.dart # Données statiques des conseils
├── repositories/             # Accès aux données (CRUD), isolent sqflite du reste de l'app
│   ├── crop_repository.dart
│   ├── activity_repository.dart
│   └── reminder_repository.dart
├── providers/                 # State management (ChangeNotifier + Provider)
│   ├── crop_provider.dart
│   ├── activity_provider.dart
│   └── reminder_provider.dart
├── screens/                   # Écrans (pages)
│   ├── dashboard/
│   ├── crops/
│   ├── reminders/
│   ├── advice/
│   └── settings/
└── widgets/                   # Widgets réutilisables (cartes, états vides, champs de formulaire)
```

Ce découpage `models / services / repositories / providers / screens / widgets` correspond
directement à la structure demandée dans l'énoncé du projet.

## 2. Classes métier

| Classe | Rôle | Attributs principaux |
| --- | --- | --- |
| `Crop` | Représente une culture suivie | `id`, `name`, `type`, `plot`, `plantingDate`, `stage` (enum `CropStage`), `expectedHarvestDate?`, `notes?` |
| `Activity` | Représente une action effectuée sur une culture | `id`, `cropId`, `type` (enum `ActivityType`), `date`, `notes?` |
| `Reminder` | Représente une tâche à faire avec échéance | `id`, `title`, `dueDate`, `cropId?`, `isDone`, `notes?` |
| `SeasonalTip` | Conseil saisonnier statique (pas de persistance) | `season` (enum `Season`), `title`, `description` |

Chaque modèle mutable (`Crop`, `Activity`, `Reminder`) expose `toMap()` / `fromMap()` pour la
sérialisation SQLite, et une méthode `copyWith()` pour faciliter les mises à jour immuables.

## 3. Gestion des données

- **Stockage local uniquement**, via `sqflite` (SQLite embarqué).
- `DatabaseService` (singleton) : ouvre la base `ferme_suivi.db`, crée les tables `crops`,
  `activities`, `reminders` au premier lancement (`onCreate`), gère les migrations de schéma
  (`onUpgrade`) pour les évolutions futures.
- Les `Repository` (un par entité) encapsulent les requêtes SQL (`insert`, `update`, `delete`,
  `query`) et exposent des méthodes métier (`getAll()`, `getById()`, `getByCrop(cropId)`,
  `getUpcoming()`, etc.). Aucune autre couche de l'application ne manipule SQL directement.
- Les conseils saisonniers (`SeasonalTip`) sont une liste Dart statique dans
  `SeasonalAdviceService`, filtrée par saison courante (déduite du mois via `DateTime.now()`) —
  pas de stockage nécessaire pour un contenu fixe.
- Pas de cache réseau : l'application est 100 % hors ligne, il n'y a donc pas de
  synchronisation à gérer.

## 4. Gestion d'état

Choix retenu : **Provider** (`package:provider`), adapté à la taille du projet (3 entités,
CRUD simple) sans la complexité additionnelle de Bloc/Riverpod.

- `CropProvider`, `ActivityProvider`, `ReminderProvider` : `ChangeNotifier` qui chargent les
  données depuis leur repository respectif, exposent une liste observable et des méthodes
  `add`/`update`/`delete`/`toggleDone` qui persistent en base puis rafraîchissent l'état local
  avant de notifier les écouteurs.
- Injection via `MultiProvider` au niveau de `main.dart`, consommation via `Consumer<T>` ou
  `context.watch<T>()` dans les écrans, pour limiter les reconstructions aux widgets qui
  dépendent réellement des données modifiées.

## 5. Navigation

- Navigation principale par `BottomNavigationBar` (4 sections : Accueil, Cultures, Rappels,
  Conseils) au sein d'un `RootShell` (widget racine avec `IndexedStack` pour préserver l'état
  de chaque onglet).
- Navigation secondaire (détail, formulaires) via `Navigator.push` avec `MaterialPageRoute`,
  passage de paramètres simples par constructeur (ex. `CropFormScreen(existingCrop: crop)`,
  `CropDetailScreen(cropId: id)`).
- Retour automatique à la liste après enregistrement (`Navigator.pop(context, true)` pour
  signaler un rafraîchissement si nécessaire).

## 6. Packages et plugins prévus

| Package | Usage |
| --- | --- |
| `provider` | Gestion d'état (ChangeNotifier + injection de dépendances simple) |
| `sqflite` | Base de données locale SQLite (cultures, activités, rappels) |
| `path` | Construction du chemin du fichier de base de données |
| `intl` | Formatage des dates en français (`dd/MM/yyyy`) |
| `flutter_lints` *(dev)* | Règles de lint recommandées |
| `sqflite_common_ffi` *(dev)* | Exécution de SQLite en mémoire pour les tests sur machine de développement (sans émulateur) |

Liste volontairement limitée (4 packages "métier") pour rester dans le périmètre conseillé
("2 à 5 packages importants").

## 7. Tests prévus

| Type de test | Cible | Emplacement |
| --- | --- | --- |
| Test unitaire (modèles) | Sérialisation `Crop`/`Reminder`/`Activity` (`toMap`/`fromMap`), logique `Reminder.isOverdue` | `test/models/` |
| Test unitaire (repository) | CRUD complet de `CropRepository` sur base SQLite en mémoire (`sqflite_common_ffi`) | `test/repositories/` |
| Test de widget | Validation du formulaire `CropFormScreen` (champs obligatoires, messages d'erreur) | `test/screens/` |
| Test de parcours (intégration légère) | Ajout d'une culture depuis la liste vide jusqu'à son apparition dans la liste, via `CropProvider` + repository en mémoire | `test/screens/` |

Les tests sont pensés dès la conception, avant le développement des écrans, afin de guider les
interfaces des repositories et des providers (méthodes prévisibles, retours testables).

## 8. Debugging et performance

- Utilisation de **Flutter DevTools** pendant le développement pour :
  - observer les **rebuilds** inutiles (Widget Rebuild Stats) et resserrer l'usage de
    `Consumer`/`Selector` si besoin ;
  - vérifier l'absence de **fuite mémoire** sur les écrans à listes longues ;
  - inspecter le **réseau** (aucun appel attendu — vérifie la conformité hors ligne) ;
  - profiler la **fluidité UI** (pas de jank en dessous de 16 ms/frame sur les listes).
- Journalisation via `debugPrint` ciblée aux points sensibles (erreurs de base de données) pour
  faciliter le débogage sans dépendre uniquement du débogueur visuel.

## 9. Déploiement

- Icône d'application dédiée et nom d'application ("Ferme Suivi") configurés dans
  `android/app/src/main/AndroidManifest.xml` et les ressources `mipmap`.
- Configuration Android minimale vérifiée (`applicationId`, `minSdkVersion` compatible avec les
  packages utilisés).
- Build d'un **App Bundle** (`flutter build appbundle`) pour une éventuelle publication ou
  installation de test.
- `README.md` à la racine du dépôt décrivant le projet, les fonctionnalités, les prérequis et
  les étapes d'installation, avec lien vers ce dossier de conception.
