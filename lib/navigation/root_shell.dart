import 'package:flutter/material.dart';

import '../screens/advice/seasonal_advice_screen.dart';
import '../screens/crops/crop_list_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/reminders/reminder_list_screen.dart';

/// Coquille racine avec navigation principale par barre basse, préservant
/// l'état de chaque onglet grâce à un [IndexedStack].
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    CropListScreen(),
    ReminderListScreen(),
    SeasonalAdviceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.eco_outlined), label: 'Cultures'),
          NavigationDestination(
              icon: Icon(Icons.notifications_outlined), label: 'Rappels'),
          NavigationDestination(icon: Icon(Icons.wb_sunny_outlined), label: 'Conseils'),
        ],
      ),
    );
  }
}
