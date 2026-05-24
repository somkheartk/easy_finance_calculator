import 'package:easy_finance_calculator/core/utils/calculation_utils.dart';
import 'package:easy_finance_calculator/features/car_loan/domain/car_loan_model.dart';

class CarLoanService {
  const CarLoanService();

  CarLoanResult calculate(CarLoanInput input) {
    final loanAmount = input.loanAmount;
    final monthly = CalculationUtils.monthlyPayment(
      principal: loanAmount,
      annualRate: input.interestRate,
      months: input.months,
    );
    final totalPayment = monthly * input.months;
    final totalInterest = totalPayment - loanAmount;

    return CarLoanResult(
      monthlyPayment: monthly,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      loanAmount: loanAmount,
    );
  }
}
