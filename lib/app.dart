import 'package:flutter/material.dart';

import 'navigation/root_shell.dart';

/// Racine de l'application : configuration du thème et de la coquille de
/// navigation.
class FermeSuiviApp extends StatelessWidget {
  const FermeSuiviApp({super.key});

  static const _seedColor = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferme Suivi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F3),
      ),
      home: const RootShell(),
    );
  }
}
