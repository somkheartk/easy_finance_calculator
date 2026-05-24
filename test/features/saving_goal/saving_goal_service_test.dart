import 'package:flutter_test/flutter_test.dart';
import 'package:easy_finance_calculator/features/saving_goal/domain/saving_goal_model.dart';
import 'package:easy_finance_calculator/features/saving_goal/domain/saving_goal_service.dart';

void main() {
  const service = SavingGoalService();

  group('SavingGoalService', () {
    test('monthly * months approximates target with 0% interest', () {
      const input = SavingGoalInput(
        targetAmount: 120000,
        months: 12,
        annualRate: 0,
      );
      final result = service.calculate(input);

      expect(result.monthlySaving, closeTo(10000, 1));
      expect(result.totalSaved, closeTo(120000, 1));
    });

    test('with interest, monthly saving is less than simple division', () {
      const withInterest = SavingGoalInput(
        targetAmount: 500000,
        months: 60,
        annualRate: 5,
      );
      const withoutInterest = SavingGoalInput(
        targetAmount: 500000,
        months: 60,
        annualRate: 0,
      );

      final ri = service.calculate(withInterest);
      final rn = service.calculate(withoutInterest);

      expect(ri.monthlySaving, lessThan(rn.monthlySaving));
    });

    test('weekly saving is approx monthly * 12/52', () {
      const input = SavingGoalInput(
        targetAmount: 100000,
        months: 12,
        annualRate: 0,
      );
      final result = service.calculate(input);

      expect(result.weeklySaving,
          closeTo(result.monthlySaving * 12 / 52, 0.01));
    });

    test('daily saving is approx monthly * 12/365', () {
      const input = SavingGoalInput(
        targetAmount: 100000,
        months: 24,
        annualRate: 3,
      );
      final result = service.calculate(input);

      expect(result.dailySaving,
          closeTo(result.monthlySaving * 12 / 365, 0.01));
    });
  });
}
