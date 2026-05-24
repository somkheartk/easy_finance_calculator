import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/shared/models/calculation_history.dart';
import 'package:easy_finance_calculator/shared/models/saved_plan.dart';
import 'package:uuid/uuid.dart';

class HiveService {
  HiveService._();

  static final instance = HiveService._();

  late Box _savedBox;
  late Box _historyBox;
  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _savedBox = await Hive.openBox(AppConstants.savedPlansBox);
    _historyBox = await Hive.openBox(AppConstants.historyBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // ── Settings ─────────────────────────────────────────────────────────────

  dynamic getSetting(String key, {dynamic defaultValue}) =>
      _settingsBox.get(key, defaultValue: defaultValue);

  Future<void> setSetting(String key, dynamic value) =>
      _settingsBox.put(key, value);

  // ── Saved Plans ───────────────────────────────────────────────────────────

  List<SavedPlan> getAllSavedPlans() {
    return _savedBox.values
        .map((v) => SavedPlan.fromMap(v as Map))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<String> savePlan({
    required String type,
    required String name,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
  }) async {
    final id = const Uuid().v4();
    final plan = SavedPlan(
      id: id,
      type: type,
      name: name,
      inputs: inputs,
      results: results,
      createdAt: DateTime.now(),
    );
    await _savedBox.put(id, plan.toMap());
    return id;
  }

  Future<void> updatePlan(SavedPlan plan) async {
    await _savedBox.put(
      plan.id,
      plan.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  }

  Future<void> deletePlan(String id) async {
    await _savedBox.delete(id);
  }

  Future<void> toggleFavoritePlan(String id) async {
    final raw = _savedBox.get(id);
    if (raw == null) return;
    final plan = SavedPlan.fromMap(raw as Map);
    await _savedBox.put(id, plan.copyWith(isFavorite: !plan.isFavorite).toMap());
  }

  // ── History ────────────────────────────────────────────────────────────────

  List<CalculationHistory> getHistory({String? type}) {
    final all = _historyBox.values
        .map((v) => CalculationHistory.fromMap(v as Map))
        .toList()
      ..sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
    if (type != null) return all.where((h) => h.type == type).toList();
    return all;
  }

  Future<void> addHistory({
    required String type,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
  }) async {
    final id = const Uuid().v4();
    final entry = CalculationHistory(
      id: id,
      type: type,
      inputs: inputs,
      results: results,
      calculatedAt: DateTime.now(),
    );
    await _historyBox.put(id, entry.toMap());
    await _trimHistory();
  }

  Future<void> _trimHistory() async {
    final keys = _historyBox.keys.toList();
    if (keys.length <= AppConstants.maxHistoryItems) return;

    final all = _historyBox.values
        .map((v) => CalculationHistory.fromMap(v as Map))
        .toList()
      ..sort((a, b) => a.calculatedAt.compareTo(b.calculatedAt));

    final toRemove = all.take(keys.length - AppConstants.maxHistoryItems);
    await _historyBox.deleteAll(toRemove.map((e) => e.id));
  }

  Future<void> clearHistory() async => _historyBox.clear();

  Future<void> deleteHistoryEntry(String id) => _historyBox.delete(id);
}
