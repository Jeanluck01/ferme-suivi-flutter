import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../providers/activity_provider.dart';

/// Formulaire d'ajout d'une activité, pré-rempli avec la culture d'origine.
class ActivityFormScreen extends StatefulWidget {
  const ActivityFormScreen({super.key, required this.cropId});

  final int cropId;

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _notesController = TextEditingController();

  ActivityType _type = ActivityType.arrosage;
  DateTime _date = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    final activity = Activity(
      cropId: widget.cropId,
      type: _type,
      date: _date,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    await context.read<ActivityProvider>().add(activity);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle activité')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<ActivityType>(
            key: const Key('activity-type-field'),
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type *'),
            items: ActivityType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Date : ${_dateFormat.format(_date)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('activity-notes-field'),
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('activity-save-button'),
            onPressed: _isSaving ? null : _submit,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
