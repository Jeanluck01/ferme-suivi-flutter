import 'package:flutter/material.dart';

import '../models/crop.dart';

/// Carte présentant une culture dans une liste, avec Hero pour l'icône afin
/// d'animer la transition vers l'écran de détail.
class CropCard extends StatelessWidget {
  const CropCard({super.key, required this.crop, required this.onTap});

  final Crop crop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'crop-icon-${crop.id}',
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.eco, color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text('${crop.name} · ${crop.plot}'),
        subtitle: Text('Stade : ${crop.stage.label}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
