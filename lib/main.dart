import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/activity_provider.dart';
import 'providers/crop_provider.dart';
import 'providers/reminder_provider.dart';
import 'repositories/activity_repository.dart';
import 'repositories/crop_repository.dart';
import 'repositories/reminder_repository.dart';
import 'services/database_service.dart';

void main() {
  final databaseService = DatabaseService();
  final cropRepository = CropRepository(databaseService);
  final activityRepository = ActivityRepository(databaseService);
  final reminderRepository = ReminderRepository(databaseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CropProvider(cropRepository)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(activityRepository)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(reminderRepository)..load(),
        ),
      ],
      child: const FermeSuiviApp(),
    ),
  );
}
