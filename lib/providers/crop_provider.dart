import 'package:flutter/foundation.dart';

import '../models/crop.dart';
import '../repositories/crop_repository.dart';

/// Expose l'état des cultures à l'interface et orchestre les accès au
/// [CropRepository] (persistance SQLite).
class CropProvider extends ChangeNotifier {
  CropProvider(this._repository);

  final CropRepository _repository;

  List<Crop> _crops = [];
  bool _isLoading = false;

  List<Crop> get crops => List.unmodifiable(_crops);
  bool get isLoading => _isLoading;
  int get activeCropCount =>
      _crops.where((c) => c.stage != CropStage.terminee).length;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _crops = await _repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Crop? getById(int id) {
    for (final crop in _crops) {
      if (crop.id == id) return crop;
    }
    return null;
  }

  Future<void> add(Crop crop) async {
    final added = await _repository.add(crop);
    _crops = [added, ..._crops];
    notifyListeners();
  }

  Future<void> update(Crop crop) async {
    await _repository.update(crop);
    _crops = [
      for (final existing in _crops)
        if (existing.id == crop.id) crop else existing,
    ];
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    _crops = _crops.where((c) => c.id != id).toList();
    notifyListeners();
  }
}
