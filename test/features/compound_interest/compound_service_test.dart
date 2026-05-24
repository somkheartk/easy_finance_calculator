import 'package:flutter_test/flutter_test.dart';
import 'package:easy_finance_calculator/features/compound_interest/domain/compound_interest_model.dart';
import 'package:easy_finance_calculator/features/compound_interest/domain/compound_interest_service.dart';

void main() {
  const service = CompoundInterestService();

  group('CompoundInterestService', () {
    test('doubles approximate rule of 72 at 12% over 6 years', () {
      const input = CompoundInput(
        principal: 100000,
        annualRate: 12,
        years: 6,
        compoundingPerYear: 12,
      );
      final result = service.calculate(input);

      // Rule of 72: 72/12 = 6 years to double
      expect(result.futureValue, closeTo(200000, 5000));
    });

    test('growth data has correct number of years', () {
      const input = CompoundInput(
        principal: 50000,
        annualRate: 7,
        years: 15,
      );
      final result = service.calculate(input);

      expect(result.growthData.length, equals(15));
    });

    test('annual vs monthly compounding differs', () {
      const annualInput = CompoundInput(
        principal: 100000,
        annualRate: 10,
        years: 10,
        compoundingPerYear: 1,
      );
      const monthlyInput = CompoundInput(
        principal: 100000,
        annualRate: 10,
        years: 10,
        compoundingPerYear: 12,
      );

      final annual = service.calculate(annualInput);
      final monthly = service.calculate(monthlyInput);

      // More frequent compounding yields more
      expect(monthly.futureValue, greaterThan(annual.futureValue));
    });

    test('ROI calculation is correct', () {
      const input = CompoundInput(
        principal: 100000,
        annualRate: 5,
        years: 10,
      );
      final result = service.calculate(input);

      final expectedRoi = (result.totalInterest / 100000) * 100;
      expect(result.roi, closeTo(expectedRoi, 0.01));
    });
  });
}
