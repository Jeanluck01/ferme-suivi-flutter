import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/reminder.dart';
import '../../providers/crop_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../widgets/empty_state.dart';
import 'reminder_form_screen.dart';

/// Liste des rappels, permettant de les cocher comme faits.
class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Rappels')),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.reminders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.reminders.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none,
              message: 'Aucun rappel pour le moment.\nAjoutez votre premier rappel.',
            );
          }
          final reminders = [...provider.reminders]
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final cropName = reminder.cropId == null
                  ? null
                  : context.watch<CropProvider>().getById(reminder.cropId!)?.name;
              return CheckboxListTile(
                key: Key('reminder-tile-${reminder.id}'),
                value: reminder.isDone,
                onChanged: (_) => provider.toggleDone(reminder),
                title: Text(
                  reminder.title,
                  style: reminder.isDone
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                subtitle: Text(
                  [
                    'Échéance : ${dateFormat.format(reminder.dueDate)}',
                    ?cropName,
                  ].join(' · '),
                  style: reminder.isOverdue
                      ? TextStyle(color: Theme.of(context).colorScheme.error)
                      : null,
                ),
                secondary: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, provider, reminder),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add-reminder-fab'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReminderFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ReminderProvider provider,
    Reminder reminder,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rappel ?'),
        content: Text('Le rappel "${reminder.title}" sera supprimé.'),
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
    if (confirmed == true && reminder.id != null) {
      await provider.delete(reminder.id!);
    }
  }
}
