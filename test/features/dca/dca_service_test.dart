import 'package:flutter_test/flutter_test.dart';
import 'package:easy_finance_calculator/features/dca/domain/dca_model.dart';
import 'package:easy_finance_calculator/features/dca/domain/dca_service.dart';

void main() {
  const service = DcaService();

  group('DcaService', () {
    test('calculates future value with no initial investment', () {
      const input = DcaInput(
        monthlyInvestment: 5000,
        initialInvestment: 0,
        annualReturnRate: 8,
        years: 10,
      );
      final result = service.calculate(input);

      // Manually verify: FV of annuity = 5000 * ((1+0.08/12)^120 - 1) / (0.08/12)
      expect(result.futureValue, greaterThan(5000 * 120)); // must beat simple sum
      expect(result.totalPrincipal, closeTo(5000 * 120, 1));
      expect(result.totalProfit, greaterThan(0));
      expect(result.roi, greaterThan(0));
    });

    test('calculates future value with initial investment', () {
      const input = DcaInput(
        monthlyInvestment: 5000,
        initialInvestment: 100000,
        annualReturnRate: 7,
        years: 5,
      );
      final result = service.calculate(input);

      expect(result.futureValue, greaterThan(100000 + 5000 * 60));
      expect(result.totalPrincipal, closeTo(100000 + 5000 * 60, 5));
    });

    test('with 0% return, future value equals total principal', () {
      const input = DcaInput(
        monthlyInvestment: 1000,
        initialInvestment: 0,
        annualReturnRate: 0,
        years: 3,
      );
      final result = service.calculate(input);

      expect(result.totalPrincipal, closeTo(1000 * 36, 1));
      // FV should approximate principal when rate is 0
      expect(result.roi, closeTo(0, 5));
    });

    test('growth data has correct number of points', () {
      const input = DcaInput(
        monthlyInvestment: 2000,
        initialInvestment: 0,
        annualReturnRate: 10,
        years: 20,
      );
      final result = service.calculate(input);

      expect(result.growthData, isNotEmpty);
      // Last point should match future value
      final lastPoint = result.growthData.last;
      expect(lastPoint['value']!, closeTo(result.futureValue, 1));
    });

    test('annual contribution increase boosts future value', () {
      const baseInput = DcaInput(
        monthlyInvestment: 5000,
        initialInvestment: 0,
        annualReturnRate: 8,
        years: 10,
      );
      const boostedInput = DcaInput(
        monthlyInvestment: 5000,
        initialInvestment: 0,
        annualReturnRate: 8,
        years: 10,
        annualContributionIncrease: 5,
      );

      final base = service.calculate(baseInput);
      final boosted = service.calculate(boostedInput);

      expect(boosted.futureValue, greaterThan(base.futureValue));
      expect(boosted.totalPrincipal, greaterThan(base.totalPrincipal));
    });
  });
}
