import 'package:flutter_test/flutter_test.dart';
import 'package:easy_finance_calculator/features/home_loan/domain/home_loan_model.dart';
import 'package:easy_finance_calculator/features/home_loan/domain/home_loan_service.dart';

void main() {
  const service = HomeLoanService();

  group('HomeLoanService', () {
    test('generates correct number of schedule entries', () {
      const input = HomeLoanInput(
        housePrice: 5000000,
        downPayment: 1000000,
        interestRate: 4,
        years: 30,
      );
      final result = service.calculate(input);

      expect(result.schedule.length, equals(360));
      expect(result.loanAmount, closeTo(4000000, 1));
    });

    test('schedule balance reaches near zero at end', () {
      const input = HomeLoanInput(
        housePrice: 3000000,
        downPayment: 600000,
        interestRate: 3.5,
        years: 20,
      );
      final result = service.calculate(input);

      final lastEntry = result.schedule.last;
      expect(lastEntry['balance']!, closeTo(0, 10));
    });

    test('sum of principal payments approximates loan amount', () {
      const input = HomeLoanInput(
        housePrice: 2000000,
        downPayment: 400000,
        interestRate: 5,
        years: 15,
      );
      final result = service.calculate(input);

      final totalPrincipalPaid =
          result.schedule.fold<double>(0, (s, e) => s + e['principal']!);
      expect(totalPrincipalPaid, closeTo(1600000, 50));
    });

    test('total interest is positive with non-zero rate', () {
      const input = HomeLoanInput(
        housePrice: 4000000,
        downPayment: 800000,
        interestRate: 6,
        years: 25,
      );
      final result = service.calculate(input);

      expect(result.totalInterest, greaterThan(0));
      expect(result.totalPayment, greaterThan(result.loanAmount));
    });

    test('30yr schedule has decreasing interest per month', () {
      const input = HomeLoanInput(
        housePrice: 3500000,
        downPayment: 700000,
        interestRate: 4.5,
        years: 10,
      );
      final result = service.calculate(input);

      // Interest should decrease over time (amortisation)
      final firstInterest = result.schedule.first['interest']!;
      final lastInterest = result.schedule.last['interest']!;
      expect(firstInterest, greaterThan(lastInterest));
    });
  });
}
