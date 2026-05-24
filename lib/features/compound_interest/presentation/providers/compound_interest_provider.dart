import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/features/compound_interest/domain/compound_interest_model.dart';
import 'package:easy_finance_calculator/features/compound_interest/domain/compound_interest_service.dart';

final compoundServiceProvider =
    Provider((_) => const CompoundInterestService());

final compoundResultProvider =
    StateNotifierProvider<CompoundNotifier, CompoundResult?>((ref) {
  return CompoundNotifier(ref.read(compoundServiceProvider));
});

class CompoundNotifier extends StateNotifier<CompoundResult?> {
  CompoundNotifier(this._service) : super(null);

  final CompoundInterestService _service;

  void calculate(CompoundInput input) {
    state = _service.calculate(input);
  }

  void reset() => state = null;
}
