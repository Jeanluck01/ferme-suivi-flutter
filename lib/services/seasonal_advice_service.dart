import '../models/seasonal_tip.dart';

/// Fournit des conseils saisonniers statiques (contenu embarqué, hors ligne).
class SeasonalAdviceService {
  const SeasonalAdviceService();

  static const List<SeasonalTip> _tips = [
    SeasonalTip(
      season: Season.printemps,
      title: 'Préparer les semis',
      description:
          'Ameublissez le sol et démarrez les semis sous abri pour les cultures sensibles au gel.',
    ),
    SeasonalTip(
      season: Season.printemps,
      title: 'Surveiller les gelées tardives',
      description:
          'Protégez les jeunes plants avec un voile si des gelées sont encore possibles.',
    ),
    SeasonalTip(
      season: Season.ete,
      title: 'Arroser tôt le matin',
      description:
          'Arrosez tôt le matin ou en soirée pour limiter l\'évaporation et économiser l\'eau.',
    ),
    SeasonalTip(
      season: Season.ete,
      title: 'Pailler les cultures',
      description:
          'Le paillage limite le dessèchement du sol et réduit la fréquence d\'arrosage.',
    ),
    SeasonalTip(
      season: Season.automne,
      title: 'Récolter avant les premiers froids',
      description:
          'Anticipez la récolte des cultures sensibles avant les premières gelées.',
    ),
    SeasonalTip(
      season: Season.automne,
      title: 'Préparer le sol pour l\'hiver',
      description:
          'Ajoutez du compost et couvrez les parcelles libres pour protéger le sol.',
    ),
    SeasonalTip(
      season: Season.hiver,
      title: 'Planifier la saison suivante',
      description:
          'Profitez de l\'hiver pour organiser la rotation des cultures et commander les semences.',
    ),
    SeasonalTip(
      season: Season.hiver,
      title: 'Entretenir les outils',
      description:
          'Nettoyez et entretenez le matériel avant la reprise de l\'activité au printemps.',
    ),
  ];

  /// Retourne les conseils correspondant à la saison en cours.
  List<SeasonalTip> getTipsForDate(DateTime date) {
    final season = Season.fromDate(date);
    return _tips.where((tip) => tip.season == season).toList();
  }

  /// Retourne l'ensemble des conseils, groupés implicitement par saison.
  List<SeasonalTip> getAllTips() => List.unmodifiable(_tips);
}
