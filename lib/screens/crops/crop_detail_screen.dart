import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/crop.dart';
import '../../providers/activity_provider.dart';
import '../../providers/crop_provider.dart';
import '../../widgets/empty_state.dart';
import '../activities/activity_form_screen.dart';
import 'crop_form_screen.dart';

/// Fiche détaillée d'une culture, avec son historique d'activités.
class CropDetailScreen extends StatelessWidget {
  const CropDetailScreen({super.key, required this.cropId});

  final int cropId;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final crop = context.watch<CropProvider>().getById(cropId);

    if (crop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Culture')),
        body: const EmptyState(
          icon: Icons.error_outline,
          message: 'Cette culture a été supprimée.',
        ),
      );
    }

    final activities = context.watch<ActivityProvider>().forCrop(cropId);

    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CropFormScreen(existingCrop: crop),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, crop),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Hero(
              tag: 'crop-icon-${crop.id}',
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.eco,
                  size: 32,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Type', value: crop.type),
          _InfoRow(label: 'Parcelle', value: crop.plot),
          _InfoRow(
            label: 'Semis',
            value: dateFormat.format(crop.plantingDate),
          ),
          _InfoRow(label: 'Stade', value: crop.stage.label),
          if (crop.expectedHarvestDate != null)
            _InfoRow(
              label: 'Récolte prévue',
              value: dateFormat.format(crop.expectedHarvestDate!),
            ),
          if (crop.notes != null && crop.notes!.isNotEmpty)
            _InfoRow(label: 'Notes', value: crop.notes!),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activités liées', style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                key: const Key('add-activity-button'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityFormScreen(cropId: cropId),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Activité'),
              ),
            ],
          ),
          if (activities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Aucune activité enregistrée pour cette culture.'),
            )
          else
            ...activities.map(
              (activity) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(activity.type.label),
                subtitle: Text(dateFormat.format(activity.date)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Crop crop) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la culture ?'),
        content: Text(
          'La culture "${crop.name}" et son historique seront définitivement supprimés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true && crop.id != null && context.mounted) {
      await context.read<CropProvider>().delete(crop.id!);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
