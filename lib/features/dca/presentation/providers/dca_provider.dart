import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/features/dca/domain/dca_model.dart';
import 'package:easy_finance_calculator/features/dca/domain/dca_service.dart';

final dcaServiceProvider = Provider((_) => const DcaService());

final dcaResultProvider =
    StateNotifierProvider<DcaNotifier, DcaResult?>((ref) {
  return DcaNotifier(ref.read(dcaServiceProvider));
});

class DcaNotifier extends StateNotifier<DcaResult?> {
  DcaNotifier(this._service) : super(null);

  final DcaService _service;

  void calculate(DcaInput input) {
    state = _service.calculate(input);
  }

  void reset() => state = null;
}
