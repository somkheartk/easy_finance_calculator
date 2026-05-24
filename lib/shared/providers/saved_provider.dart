import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/shared/database/hive_service.dart';
import 'package:easy_finance_calculator/shared/models/saved_plan.dart';

final savedPlansProvider =
    StateNotifierProvider<SavedPlansNotifier, List<SavedPlan>>((ref) {
  return SavedPlansNotifier();
});

final favoritePlansProvider = Provider<List<SavedPlan>>((ref) {
  return ref.watch(savedPlansProvider).where((p) => p.isFavorite).toList();
});

final savedPlansByTypeProvider =
    Provider.family<List<SavedPlan>, String>((ref, type) {
  return ref.watch(savedPlansProvider).where((p) => p.type == type).toList();
});

class SavedPlansNotifier extends StateNotifier<List<SavedPlan>> {
  SavedPlansNotifier() : super([]) {
    _load();
  }

  void _load() {
    state = HiveService.instance.getAllSavedPlans();
  }

  Future<String> save({
    required String type,
    required String name,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> results,
  }) async {
    final id = await HiveService.instance.savePlan(
      type: type,
      name: name,
      inputs: inputs,
      results: results,
    );
    _load();
    return id;
  }

  Future<void> update(SavedPlan plan) async {
    await HiveService.instance.updatePlan(plan);
    _load();
  }

  Future<void> delete(String id) async {
    await HiveService.instance.deletePlan(id);
    state = state.where((p) => p.id != id).toList();
  }

  Future<void> toggleFavorite(String id) async {
    await HiveService.instance.toggleFavoritePlan(id);
    _load();
  }

  void reload() => _load();
}
