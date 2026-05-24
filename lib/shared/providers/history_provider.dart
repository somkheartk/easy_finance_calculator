import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/shared/database/hive_service.dart';
import 'package:easy_finance_calculator/shared/models/calculation_history.dart';

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<CalculationHistory>>((ref) {
  return HistoryNotifier();
});

final filteredHistoryProvider =
    Provider.family<List<CalculationHistory>, String?>((ref, type) {
  final history = ref.watch(historyProvider);
  if (type == null) return history;
  return history.where((h) => h.type == type).toList();
});

class HistoryNotifier extends StateNotifier<List<CalculationHistory>> {
  HistoryNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = HiveService.instance.getHistory();
  }

  Future<void> add({
    required String type,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
  }) async {
    await HiveService.instance.addHistory(
      type: type,
      inputs: inputs,
      results: results,
    );
    _load();
  }

  Future<void> clearAll() async {
    await HiveService.instance.clearHistory();
    state = [];
  }

  Future<void> deleteEntry(String id) async {
    await HiveService.instance.deleteHistoryEntry(id);
    state = state.where((h) => h.id != id).toList();
  }

  void reload() => _load();
}
