import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/crop_provider.dart';
import '../../providers/reminder_provider.dart';

/// Écran des paramètres : informations sur l'application et réinitialisation.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('À propos'),
            subtitle: Text(
              'Ferme Suivi v1.0.0 — Application de suivi de cultures, hors ligne, '
              'données stockées localement sur cet appareil.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Réinitialiser les données'),
            subtitle: const Text(
              'Supprime toutes les cultures, activités et rappels enregistrés.',
            ),
            onTap: () => _confirmReset(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser les données ?'),
        content: const Text(
          'Toutes les cultures, activités et rappels seront définitivement supprimés. '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final cropProvider = context.read<CropProvider>();
    final activityProvider = context.read<ActivityProvider>();
    final reminderProvider = context.read<ReminderProvider>();

    for (final reminder in List.of(reminderProvider.reminders)) {
      await reminderProvider.delete(reminder.id!);
    }
    for (final activity in List.of(activityProvider.activities)) {
      await activityProvider.delete(activity.id!);
    }
    for (final crop in List.of(cropProvider.crops)) {
      await cropProvider.delete(crop.id!);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données réinitialisées.')),
      );
    }
  }
}
