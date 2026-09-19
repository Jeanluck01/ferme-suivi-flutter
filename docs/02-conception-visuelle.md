# Dossier de conception visuelle mobile — Ferme Suivi

> Plan UI/UX simple (wireframes texte + description), pas un design graphique final.

## 1. Layout général mobile

- **AppBar** en haut de chaque écran : titre de la section + action contextuelle éventuelle
  (ex. bouton filtre sur la liste des cultures).
- **BottomNavigationBar** à 4 entrées pour la navigation principale :
  1. Accueil (tableau de bord)
  2. Cultures
  3. Rappels
  4. Conseils
- Le **carnet d'activités** est accessible depuis le détail d'une culture et depuis le tableau
  de bord (pas d'onglet dédié, pour rester à 4 onglets — cohérent avec la contrainte
  "4 à 8 écrans principaux").
- **FloatingActionButton** (+) sur les écrans de liste (Cultures, Rappels) pour ajouter un
  élément rapidement.
- Écran **Paramètres** accessible depuis l'AppBar de l'accueil (icône engrenage).

## 2. Wireframes des écrans clés (description structurée)

### 2.1 Accueil / Tableau de bord

```
┌─────────────────────────────┐
│ Ferme Suivi          ⚙      │  AppBar
├─────────────────────────────┤
│  Bonjour 👋                  │
│  [3 cultures actives]        │  Carte résumé
│  [2 rappels en retard]       │
├─────────────────────────────┤
│ Conseil du moment             │
│ 🌱 "Automne : ..."            │  Carte conseil saisonnier
├─────────────────────────────┤
│ Prochains rappels             │
│  • Arroser tomates - demain   │
│  • Traiter pommiers - 3j      │  Liste courte (max 5)
├─────────────────────────────┤
│ Activités récentes            │
│  • Arrosage - Tomates - hier  │
├─────────────────────────────┤
│ [Accueil][Cultures][Rappels][Conseils]│  BottomNav
└─────────────────────────────┘
```

### 2.2 Liste des cultures

```
┌─────────────────────────────┐
│ Cultures                    │
├─────────────────────────────┤
│ 🍅 Tomates - Parcelle Nord   │
│    Stade : Croissance    >  │
├─────────────────────────────┤
│ 🌽 Maïs - Parcelle Est       │
│    Stade : Semis         >  │
├─────────────────────────────┤
│              (+)             │  FAB ajout
│ [Accueil][Cultures][Rappels][Conseils]│
└─────────────────────────────┘
```

État vide : icône + message "Aucune culture pour le moment. Ajoutez votre première culture."

### 2.3 Détail d'une culture

```
┌─────────────────────────────┐
│ < Tomates - Parcelle Nord   │
├─────────────────────────────┤
│ 🍅  (icône Hero)             │
│ Type : Tomate                │
│ Parcelle : Nord               │
│ Semis : 12/03/2026            │
│ Stade : Croissance             │
│ Récolte prévue : 15/07/2026   │
│ Notes : ...                    │
├─────────────────────────────┤
│ Activités liées                │
│  • Arrosage - 14/03            │
│  • Fertilisation - 20/03       │
│              (+ activité)        │
├─────────────────────────────┤
│ [Modifier]   [Supprimer]        │
└─────────────────────────────┘
```

### 2.4 Formulaire culture (ajout / modification)

```
┌─────────────────────────────┐
│ < Nouvelle culture           │
├─────────────────────────────┤
│ Nom * [______________]       │
│ Type * [_____________]       │
│ Parcelle [___________]       │
│ Date de semis * [__/__/____] │
│ Stade * [Dropdown ▾]         │
│ Récolte prévue [__/__/____]  │
│ Notes [______________]       │
├─────────────────────────────┤
│         [Enregistrer]         │
└─────────────────────────────┘
```

Champs marqués `*` obligatoires ; message d'erreur explicite sous le champ si vide
(ex. "Le nom est requis.").

### 2.5 Formulaire activité

```
┌─────────────────────────────┐
│ < Nouvelle activité           │
├─────────────────────────────┤
│ Culture * [Dropdown ▾]        │
│ Type * [Dropdown ▾]           │
│ Date * [__/__/____]           │
│ Notes [______________]        │
├─────────────────────────────┤
│         [Enregistrer]          │
└─────────────────────────────┘
```

### 2.6 Liste des rappels

```
┌─────────────────────────────┐
│ Rappels                      │
├─────────────────────────────┤
│ ☐ Arroser tomates             │
│    Échéance : demain      >  │
├─────────────────────────────┤
│ ☑ Traiter pommiers (fait)     │
│    Échéance : 10/03       >  │
├─────────────────────────────┤
│              (+)              │
│ [Accueil][Cultures][Rappels][Conseils]│
└─────────────────────────────┘
```

Rappels en retard affichés en rouge/orange ; case à cocher pour marquer "fait" directement
depuis la liste (sans ouvrir le détail).

### 2.7 Formulaire rappel

```
┌─────────────────────────────┐
│ < Nouveau rappel              │
├─────────────────────────────┤
│ Titre * [_____________]       │
│ Échéance * [__/__/____]       │
│ Culture associée [Dropdown ▾] │
│ Notes [______________]        │
├─────────────────────────────┤
│         [Enregistrer]          │
└─────────────────────────────┘
```

### 2.8 Conseils saisonniers

```
┌─────────────────────────────┐
│ Conseils - Automne            │
├─────────────────────────────┤
│ 🍂 Préparer le sol...          │
│ 🍂 Récolter avant le gel...    │
│ 🍂 Pailler les cultures...     │
├─────────────────────────────┤
│ [Accueil][Cultures][Rappels][Conseils]│
└─────────────────────────────┘
```

### 2.9 Paramètres

```
┌─────────────────────────────┐
│ < Paramètres                  │
├─────────────────────────────┤
│ À propos de l'application      │
│ Réinitialiser les données       │
└─────────────────────────────┘
```

## 3. Flux utilisateurs essentiels

### Flux 1 — Ajouter une culture

`Accueil / Cultures → FAB (+) → Formulaire culture → Enregistrer (validation) →
Retour à la liste des cultures (nouvelle carte visible)`

### Flux 2 — Consulter une fiche et logger une activité

`Liste des cultures → Sélection d'une carte → Détail culture → (+ activité) →
Formulaire activité (culture pré-remplie) → Enregistrer → Retour au détail
(activité visible dans l'historique)`

### Flux 3 — Créer un rappel et le marquer fait

`Rappels → FAB (+) → Formulaire rappel → Enregistrer → Retour à la liste des rappels →
Cocher la case du rappel une fois la tâche effectuée`

## 4. Style de base

- **Palette de couleurs** : vert principal `#2E7D32` (identité "agriculture/nature"), vert
  clair `#81C784` pour les accents, fond neutre `#F5F7F3`, alerte/retard `#D84315`.
- **Typographie** : police système par défaut (Roboto/San Francisco selon plateforme), titres
  en gras, tailles suffisantes pour lecture en extérieur (16sp minimum pour le texte courant).
- **Icônes** : Material Icons (feuille, goutte d'eau, calendrier, cloche) pour une
  reconnaissance rapide sans texte.
- **Boutons** : boutons pleins pour l'action principale (Enregistrer), boutons texte pour les
  actions secondaires (Annuler), FAB pour l'ajout rapide.
- **Messages d'erreur** : affichés sous le champ concerné, en rouge, avec un texte explicite
  (jamais un simple astérisque ou une bordure rouge seule).

## 5. Accessibilité simple

- Contraste suffisant entre texte et fond (respect des ratios Material Design).
- Zones tactiles (boutons, cases à cocher, cartes de liste) d'au moins 48x48 dp.
- Labels explicites sur les champs de formulaire et les icônes (pas d'icône seule sans
  texte pour une action destructive comme "Supprimer").
- Taille de police lisible, pas de texte en dessous de 12sp.

## 6. Outils utilisés pour ce dossier

Wireframes texte structurés (schémas ASCII ci-dessus), rédigés directement en Markdown pour
rester synchronisés avec le code au fil du développement.
