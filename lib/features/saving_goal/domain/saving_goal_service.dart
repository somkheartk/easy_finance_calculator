import 'package:easy_finance_calculator/core/utils/calculation_utils.dart';
import 'package:easy_finance_calculator/features/saving_goal/domain/saving_goal_model.dart';

class SavingGoalService {
  const SavingGoalService();

  SavingGoalResult calculate(SavingGoalInput input) {
    final monthly = CalculationUtils.monthlySavingRequired(
      targetAmount: input.targetAmount,
      annualRate: input.annualRate,
      months: input.months,
    );
    final totalSaved = monthly * input.months;
    final interestEarned = input.targetAmount - totalSaved;

    return SavingGoalResult(
      monthlySaving: monthly,
      weeklySaving: monthly * 12 / 52,
      dailySaving: monthly * 12 / 365,
      totalSaved: totalSaved,
      interestEarned: interestEarned > 0 ? interestEarned : 0,
    );
  }
}
