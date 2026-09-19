import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../widgets/crop_card.dart';
import '../../widgets/empty_state.dart';
import 'crop_detail_screen.dart';
import 'crop_form_screen.dart';

/// Liste des cultures suivies par l'utilisateur.
class CropListScreen extends StatelessWidget {
  const CropListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cultures')),
      body: Consumer<CropProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.crops.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.crops.isEmpty) {
            return const EmptyState(
              icon: Icons.eco_outlined,
              message:
                  'Aucune culture pour le moment.\nAjoutez votre première culture.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: provider.crops.length,
            itemBuilder: (context, index) {
              final crop = provider.crops[index];
              return CropCard(
                crop: crop,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CropDetailScreen(cropId: crop.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add-crop-fab'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CropFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
