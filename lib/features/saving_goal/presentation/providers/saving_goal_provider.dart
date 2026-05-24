import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/features/saving_goal/domain/saving_goal_model.dart';
import 'package:easy_finance_calculator/features/saving_goal/domain/saving_goal_service.dart';

final savingGoalServiceProvider = Provider((_) => const SavingGoalService());

final savingGoalResultProvider =
    StateNotifierProvider<SavingGoalNotifier, SavingGoalResult?>((ref) {
  return SavingGoalNotifier(ref.read(savingGoalServiceProvider));
});

class SavingGoalNotifier extends StateNotifier<SavingGoalResult?> {
  SavingGoalNotifier(this._service) : super(null);

  final SavingGoalService _service;

  void calculate(SavingGoalInput input) {
    state = _service.calculate(input);
  }

  void reset() => state = null;
}
