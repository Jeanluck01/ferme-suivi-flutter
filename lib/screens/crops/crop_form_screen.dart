import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/crop.dart';
import '../../providers/crop_provider.dart';

/// Formulaire de création ou de modification d'une culture.
class CropFormScreen extends StatefulWidget {
  const CropFormScreen({super.key, this.existingCrop});

  final Crop? existingCrop;

  bool get isEditing => existingCrop != null;

  @override
  State<CropFormScreen> createState() => _CropFormScreenState();
}

class _CropFormScreenState extends State<CropFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _plotController;
  late final TextEditingController _notesController;

  DateTime? _plantingDate;
  DateTime? _expectedHarvestDate;
  late CropStage _stage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final crop = widget.existingCrop;
    _nameController = TextEditingController(text: crop?.name ?? '');
    _typeController = TextEditingController(text: crop?.type ?? '');
    _plotController = TextEditingController(text: crop?.plot ?? '');
    _notesController = TextEditingController(text: crop?.notes ?? '');
    _plantingDate = crop?.plantingDate;
    _expectedHarvestDate = crop?.expectedHarvestDate;
    _stage = crop?.stage ?? CropStage.semis;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _plotController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isPlantingDate}) async {
    final initial = (isPlantingDate ? _plantingDate : _expectedHarvestDate) ??
        DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isPlantingDate) {
        _plantingDate = picked;
      } else {
        _expectedHarvestDate = picked;
      }
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _plantingDate == null) {
      if (_plantingDate == null) {
        setState(() {}); // force le rebuild pour afficher l'erreur de date
      }
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<CropProvider>();
    final crop = Crop(
      id: widget.existingCrop?.id,
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      plot: _plotController.text.trim(),
      plantingDate: _plantingDate!,
      stage: _stage,
      expectedHarvestDate: _expectedHarvestDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (widget.isEditing) {
      await provider.update(crop);
    } else {
      await provider.add(crop);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final plantingDateError =
        _plantingDate == null ? 'La date de semis est requise.' : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier la culture' : 'Nouvelle culture'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('crop-name-field'),
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom *'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Le nom est requis.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('crop-type-field'),
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type *'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Le type est requis.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('crop-plot-field'),
              controller: _plotController,
              decoration: const InputDecoration(labelText: 'Parcelle *'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'La parcelle est requise.'
                  : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_plantingDate == null
                  ? 'Date de semis *'
                  : 'Semis : ${_dateFormat.format(_plantingDate!)}'),
              subtitle: plantingDateError != null
                  ? Text(
                      plantingDateError,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : null,
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isPlantingDate: true),
            ),
            DropdownButtonFormField<CropStage>(
              key: const Key('crop-stage-field'),
              initialValue: _stage,
              decoration: const InputDecoration(labelText: 'Stade *'),
              items: CropStage.values
                  .map((stage) => DropdownMenuItem(
                        value: stage,
                        child: Text(stage.label),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _stage = value);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_expectedHarvestDate == null
                  ? 'Récolte prévue (optionnel)'
                  : 'Récolte prévue : ${_dateFormat.format(_expectedHarvestDate!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isPlantingDate: false),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('crop-notes-field'),
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('crop-save-button'),
              onPressed: _isSaving ? null : _submit,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
