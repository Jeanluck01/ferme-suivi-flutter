import 'package:flutter/material.dart';

import '../../models/seasonal_tip.dart';
import '../../services/seasonal_advice_service.dart';

/// Liste des conseils saisonniers, filtrés sur la saison en cours.
class SeasonalAdviceScreen extends StatelessWidget {
  const SeasonalAdviceScreen({
    super.key,
    this.adviceService = const SeasonalAdviceService(),
  });

  final SeasonalAdviceService adviceService;

  static const _seasonIcons = {
    Season.printemps: '🌱',
    Season.ete: '☀️',
    Season.automne: '🍂',
    Season.hiver: '❄️',
  };

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final season = Season.fromDate(now);
    final tips = adviceService.getTipsForDate(now);

    return Scaffold(
      appBar: AppBar(title: Text('Conseils - ${season.label}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(
                _seasonIcons[tip.season] ?? '🌿',
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(tip.title),
              subtitle: Text(tip.description),
            ),
          );
        },
      ),
    );
  }
}
