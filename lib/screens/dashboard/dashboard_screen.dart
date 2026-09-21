import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../providers/crop_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../services/seasonal_advice_service.dart';
import '../settings/settings_screen.dart';

/// Tableau de bord affiché à l'ouverture de l'application.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.adviceService = const SeasonalAdviceService(),
  });

  final SeasonalAdviceService adviceService;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final cropProvider = context.watch<CropProvider>();
    final reminderProvider = context.watch<ReminderProvider>();
    final activityProvider = context.watch<ActivityProvider>();
    final tips = adviceService.getTipsForDate(DateTime.now());
    final featuredTip = tips.isNotEmpty ? tips.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferme Suivi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Bonjour 👋', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.eco,
                  label: 'Cultures actives',
                  value: '${cropProvider.activeCropCount}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.warning_amber_rounded,
                  label: 'Rappels en retard',
                  value: '${reminderProvider.overdueCount}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (featuredTip != null) ...[
            Text('Conseil du moment',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Text('🌱', style: TextStyle(fontSize: 24)),
                title: Text(featuredTip.title),
                subtitle: Text(featuredTip.description),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text('Prochains rappels', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (reminderProvider.upcoming.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Aucun rappel à venir.'),
            )
          else
            ...reminderProvider.upcoming.map(
              (reminder) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  reminder.isOverdue
                      ? Icons.error_outline
                      : Icons.notifications_none,
                  color: reminder.isOverdue
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
                title: Text(reminder.title),
                subtitle: Text('Échéance : ${dateFormat.format(reminder.dueDate)}'),
              ),
            ),
          const SizedBox(height: 24),
          Text('Activités récentes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (activityProvider.recent.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Aucune activité enregistrée.'),
            )
          else
            ...activityProvider.recent.map(
              (activity) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: Text(activity.type.label),
                subtitle: Text(dateFormat.format(activity.date)),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineMedium),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
