import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/features/home_loan/domain/home_loan_model.dart';
import 'package:easy_finance_calculator/features/home_loan/domain/home_loan_service.dart';

final homeLoanServiceProvider = Provider((_) => const HomeLoanService());

final homeLoanResultProvider =
    StateNotifierProvider<HomeLoanNotifier, HomeLoanResult?>((ref) {
  return HomeLoanNotifier(ref.read(homeLoanServiceProvider));
});

class HomeLoanNotifier extends StateNotifier<HomeLoanResult?> {
  HomeLoanNotifier(this._service) : super(null);

  final HomeLoanService _service;

  void calculate(HomeLoanInput input) {
    state = _service.calculate(input);
  }

  void reset() => state = null;
}
