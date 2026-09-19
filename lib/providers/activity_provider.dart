import 'package:flutter/foundation.dart';

import '../models/activity.dart';
import '../repositories/activity_repository.dart';

/// Expose l'état des activités (carnet d'activités) à l'interface.
class ActivityProvider extends ChangeNotifier {
  ActivityProvider(this._repository);

  final ActivityRepository _repository;

  List<Activity> _activities = [];
  bool _isLoading = false;

  List<Activity> get activities => List.unmodifiable(_activities);
  bool get isLoading => _isLoading;

  List<Activity> get recent => _activities.take(5).toList();

  List<Activity> forCrop(int cropId) =>
      _activities.where((a) => a.cropId == cropId).toList();

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _activities = await _repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> add(Activity activity) async {
    final added = await _repository.add(activity);
    _activities = [added, ..._activities]
      ..sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    _activities = _activities.where((a) => a.id != id).toList();
    notifyListeners();
  }
}
