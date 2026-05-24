import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/features/car_loan/domain/car_loan_model.dart';
import 'package:easy_finance_calculator/features/car_loan/domain/car_loan_service.dart';

final carLoanServiceProvider = Provider((_) => const CarLoanService());

final carLoanResultProvider =
    StateNotifierProvider<CarLoanNotifier, CarLoanResult?>((ref) {
  return CarLoanNotifier(ref.read(carLoanServiceProvider));
});

class CarLoanNotifier extends StateNotifier<CarLoanResult?> {
  CarLoanNotifier(this._service) : super(null);

  final CarLoanService _service;

  void calculate(CarLoanInput input) {
    state = _service.calculate(input);
  }

  void reset() => state = null;
}
