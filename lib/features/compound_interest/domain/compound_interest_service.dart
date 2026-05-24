import 'dart:math' as math;
import 'package:easy_finance_calculator/features/compound_interest/domain/compound_interest_model.dart';

class CompoundInterestService {
  const CompoundInterestService();

  CompoundResult calculate(CompoundInput input) {
    final n = input.compoundingPerYear;
    final r = input.annualRate / 100 / n;
    final growthData = <Map<String, double>>[];

    double fv = input.principal;
    for (int y = 1; y <= input.years; y++) {
      fv = input.principal * math.pow(1 + r, n * y);
      growthData.add({'year': y.toDouble(), 'value': fv});
    }

    final totalInterest = fv - input.principal;
    final roi = input.principal > 0 ? (totalInterest / input.principal) * 100 : 0.0;

    return CompoundResult(
      futureValue: fv,
      totalInterest: totalInterest,
      roi: roi,
      growthData: growthData,
    );
  }
}
