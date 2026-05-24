import 'package:flutter_test/flutter_test.dart';
import 'package:easy_finance_calculator/features/car_loan/domain/car_loan_model.dart';
import 'package:easy_finance_calculator/features/car_loan/domain/car_loan_service.dart';

void main() {
  const service = CarLoanService();

  group('CarLoanService', () {
    test('calculates monthly payment correctly', () {
      const input = CarLoanInput(
        carPrice: 1000000,
        downPayment: 200000,
        interestRate: 5,
        months: 60,
      );
      final result = service.calculate(input);

      // Principal = 800,000, 5%/yr, 60 months
      // Monthly rate = 0.05/12 ≈ 0.004167
      expect(result.loanAmount, closeTo(800000, 1));
      expect(result.monthlyPayment, closeTo(15099.17, 10));
      expect(result.totalPayment, closeTo(result.monthlyPayment * 60, 1));
      expect(result.totalInterest, closeTo(result.totalPayment - 800000, 1));
    });

    test('zero interest results in equal principal division', () {
      const input = CarLoanInput(
        carPrice: 600000,
        downPayment: 0,
        interestRate: 0,
        months: 60,
      );
      final result = service.calculate(input);

      expect(result.monthlyPayment, closeTo(10000, 1));
      expect(result.totalInterest, closeTo(0, 1));
    });

    test('loan amount equals car price minus down payment', () {
      const input = CarLoanInput(
        carPrice: 1500000,
        downPayment: 300000,
        interestRate: 3.5,
        months: 72,
      );
      final result = service.calculate(input);

      expect(result.loanAmount, closeTo(1200000, 1));
    });

    test('total payment exceeds loan amount with non-zero interest', () {
      const input = CarLoanInput(
        carPrice: 500000,
        downPayment: 0,
        interestRate: 7,
        months: 48,
      );
      final result = service.calculate(input);

      expect(result.totalPayment, greaterThan(500000));
      expect(result.totalInterest, greaterThan(0));
    });
  });
}
