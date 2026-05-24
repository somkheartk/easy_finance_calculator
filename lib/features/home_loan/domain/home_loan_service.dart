import 'package:easy_finance_calculator/core/utils/calculation_utils.dart';
import 'package:easy_finance_calculator/features/home_loan/domain/home_loan_model.dart';

class HomeLoanService {
  const HomeLoanService();

  HomeLoanResult calculate(HomeLoanInput input) {
    final loan = input.loanAmount;
    final monthly = CalculationUtils.monthlyPayment(
      principal: loan,
      annualRate: input.interestRate,
      months: input.months,
    );
    final schedule = CalculationUtils.amortisationSchedule(
      principal: loan,
      annualRate: input.interestRate,
      months: input.months,
    );
    final totalPayment = monthly * input.months;
    final totalInterest = totalPayment - loan;

    return HomeLoanResult(
      monthlyPayment: monthly,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      loanAmount: loan,
      schedule: schedule,
    );
  }
}
