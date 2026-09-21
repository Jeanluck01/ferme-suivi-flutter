# Cahier des charges — Ferme Suivi

## 1. Nom provisoire et contexte

**Nom provisoire :** Ferme Suivi

**Contexte :** de nombreux petits exploitants et jardiniers familiaux gèrent leurs cultures, leurs
tâches d'entretien et leurs rappels de manière informelle (carnet papier, mémoire, notes
éparses). Cela entraîne des oublis (arrosage, traitement, récolte au bon stade) et une absence
de suivi dans le temps. Ferme Suivi est une application mobile Flutter destinée à centraliser le
suivi des cultures d'une petite exploitation ou d'un jardin, entièrement utilisable hors ligne.

## 2. Problème / besoin

- Difficulté à se souvenir de l'état de chaque culture (stade, parcelle, date de semis).
- Absence de carnet centralisé des activités effectuées (arrosage, fertilisation, traitement,
  récolte).
- Oublis de tâches importantes faute de rappels (arrosage à date fixe, traitement à venir).
- Manque de repères saisonniers simples pour savoir quoi faire selon la période de l'année.

## 3. Utilisateurs cibles

- Petit exploitant agricole ou maraîcher indépendant gérant plusieurs parcelles/cultures.
- Jardinier amateur ou familial souhaitant structurer le suivi de son potager.
- Utilisateur ayant un accès internet limité ou intermittent sur le terrain (champ, serre) —
  d'où l'exigence de fonctionnement hors ligne.

## 4. Fonctionnalités

### 4.1 Fonctionnalités principales (obligatoires)

1. **Gestion des cultures** : créer, consulter, modifier, supprimer une culture (nom, type,
   parcelle, date de semis/plantation, stade, date de récolte prévue, notes).
2. **Carnet d'activités** : enregistrer une activité (arrosage, fertilisation, traitement,
   désherbage, récolte, autre) liée à une culture, avec date et notes ; consulter l'historique.
3. **Rappels / alertes** : créer des rappels de tâches (avec échéance, culture associée
   optionnelle), les marquer comme faits, visualiser les rappels en retard et à venir.
4. **Tableau de bord** : vue d'ensemble à l'ouverture de l'application — nombre de cultures
   actives, prochains rappels, dernières activités, conseil du moment.
5. **Conseils saisonniers** : liste de conseils pratiques classés par saison, filtrés
   automatiquement selon la saison en cours.

### 4.2 Fonctionnalités optionnelles (si le temps le permet)

- Filtrage et recherche des cultures par parcelle ou par stade.
- Statistiques simples (nombre d'activités par type sur les 30 derniers jours).
- Thème clair/sombre.
- Export/partage du carnet d'activités d'une culture (texte simple).

## 5. Données manipulées

| Entité | Attributs principaux |
| --- | --- |
| Culture (`Crop`) | id, nom, type, parcelle, date de semis, stade, date de récolte prévue, notes |
| Activité (`Activity`) | id, culture associée, type, date, notes |
| Rappel (`Reminder`) | id, titre, échéance, culture associée (optionnelle), fait/à faire, notes |
| Conseil saisonnier (`SeasonalTip`) | id, saison, titre, description (contenu embarqué, non modifiable par l'utilisateur) |

## 6. Localisation des données

Les données (cultures, activités, rappels) sont **stockées localement** sur l'appareil via une
base **SQLite** (package `sqflite`). Ce choix est justifié par :

- le besoin d'un fonctionnement **hors ligne total** (terrain sans réseau) ;
- l'absence de besoin de synchronisation multi-appareil pour un usage individuel ;
- la simplicité de mise en œuvre et l'absence de dépendance à un service distant (pas de
  compte Firebase à configurer), ce qui limite aussi les risques de sécurité liés aux données.

Les conseils saisonniers sont des données **statiques embarquées** dans l'application (pas de
stockage nécessaire).

## 7. Exigences non fonctionnelles

- **Ergonomie** : navigation simple par barre de navigation basse (4 sections), formulaires
  courts avec validation et messages d'erreur explicites, retour visuel immédiat après action.
- **Performance** : listes chargées de façon asynchrone, pas de reconstruction inutile de
  widgets (usage ciblé de `Consumer`/`Selector`), images/icônes vectorielles uniquement.
- **Sécurité** : aucune donnée sensible (pas de mot de passe, pas de paiement) ; les données
  restent locales à l'appareil de l'utilisateur.
- **Accès hors ligne** : fonctionnement à 100 % sans connexion réseau, aucune fonctionnalité ne
  dépend d'un appel réseau.
- **Sobriété numérique** : pas d'images lourdes, pas d'appel réseau superflu, requêtes SQLite
  ciblées (pas de chargement de toutes les données à chaque écran).

## 8. Critères de réussite et limites du projet

### Critères de réussite

- Les 5 fonctionnalités principales sont opérationnelles de bout en bout (créer une culture,
  logger une activité, créer/valider un rappel, consulter le tableau de bord et les conseils).
- L'application fonctionne entièrement hors ligne.
- Le code est organisé (modèles / services / repositories / providers / écrans), testé
  (au moins un test unitaire, un test de widget, un test de parcours utilisateur) et versionné
  sur GitHub avec un historique de commits lisible.

### Limites assumées du projet

- Pas de compte utilisateur ni d'authentification (usage individuel, mono-utilisateur).
- Pas de synchronisation cloud ni de sauvegarde distante des données.
- Pas de notifications système programmées (les rappels sont consultés dans l'application,
  pas de notification push/local en arrière-plan) — piste d'évolution future.
- Les conseils saisonniers sont un contenu fixe embarqué, non modifiable par l'utilisateur.
