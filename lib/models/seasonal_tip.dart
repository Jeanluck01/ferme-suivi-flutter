/// Saison utilisée pour filtrer les conseils.
enum Season {
  printemps,
  ete,
  automne,
  hiver;

  String get label {
    switch (this) {
      case Season.printemps:
        return 'Printemps';
      case Season.ete:
        return 'Été';
      case Season.automne:
        return 'Automne';
      case Season.hiver:
        return 'Hiver';
    }
  }

  /// Détermine la saison (hémisphère nord) à partir d'une date donnée.
  factory Season.fromDate(DateTime date) {
    final month = date.month;
    if (month == 12 || month <= 2) return Season.hiver;
    if (month <= 5) return Season.printemps;
    if (month <= 8) return Season.ete;
    return Season.automne;
  }
}

/// Un conseil saisonnier, contenu statique embarqué (pas de persistance).
class SeasonalTip {
  final Season season;
  final String title;
  final String description;

  const SeasonalTip({
    required this.season,
    required this.title,
    required this.description,
  });
}
