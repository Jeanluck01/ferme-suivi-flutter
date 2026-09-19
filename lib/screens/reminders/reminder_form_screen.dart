import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/reminder.dart';
import '../../providers/crop_provider.dart';
import '../../providers/reminder_provider.dart';

/// Formulaire de création d'un rappel, avec culture associée optionnelle.
class ReminderFormScreen extends StatefulWidget {
  const ReminderFormScreen({super.key});

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _dueDate;
  int? _cropId;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _dueDate == null) {
      setState(() {});
      return;
    }
    setState(() => _isSaving = true);
    final reminder = Reminder(
      title: _titleController.text.trim(),
      dueDate: _dueDate!,
      cropId: _cropId,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    await context.read<ReminderProvider>().add(reminder);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final crops = context.watch<CropProvider>().crops;
    final dueDateError = _dueDate == null ? 'L\'échéance est requise.' : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau rappel')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('reminder-title-field'),
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre *'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Le titre est requis.'
                  : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_dueDate == null
                  ? 'Échéance *'
                  : 'Échéance : ${_dateFormat.format(_dueDate!)}'),
              subtitle: dueDateError != null
                  ? Text(
                      dueDateError,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : null,
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            DropdownButtonFormField<int?>(
              key: const Key('reminder-crop-field'),
              initialValue: _cropId,
              decoration:
                  const InputDecoration(labelText: 'Culture associée (optionnel)'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('Aucune')),
                ...crops.map(
                  (crop) => DropdownMenuItem<int?>(
                    value: crop.id,
                    child: Text(crop.name),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _cropId = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('reminder-notes-field'),
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('reminder-save-button'),
              onPressed: _isSaving ? null : _submit,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
