import 'dart:math' as math;

class CalculationUtils {
  CalculationUtils._();

  /// Monthly payment for an amortising loan.
  /// [principal] total loan amount, [annualRate] in %, [months] term.
  static double monthlyPayment({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (principal <= 0 || months <= 0) return 0;
    if (annualRate <= 0) return principal / months;

    final r = annualRate / 100 / 12;
    final factor = math.pow(1 + r, months);
    return principal * r * factor / (factor - 1);
  }

  /// Future value of regular monthly contributions (annuity).
  static double futureValueAnnuity({
    required double monthlyContribution,
    required double annualRate,
    required int months,
  }) {
    if (monthlyContribution <= 0) return 0;
    if (annualRate <= 0) return monthlyContribution * months;

    final r = annualRate / 100 / 12;
    return monthlyContribution * (math.pow(1 + r, months) - 1) / r;
  }

  /// Future value of a lump sum.
  static double futureValueLump({
    required double presentValue,
    required double annualRate,
    required int months,
  }) {
    if (presentValue <= 0) return 0;
    if (annualRate <= 0) return presentValue;

    final r = annualRate / 100 / 12;
    return presentValue * math.pow(1 + r, months);
  }

  /// Compound interest FV with optional periodic compounding.
  /// [n] = compounding periods per year (12 = monthly, 1 = annually).
  static double compoundInterest({
    required double principal,
    required double annualRate,
    required int years,
    int n = 12,
  }) {
    if (principal <= 0) return 0;
    if (annualRate <= 0) return principal;

    final r = annualRate / 100 / n;
    final periods = n * years;
    return principal * math.pow(1 + r, periods);
  }

  /// Required monthly saving to reach a target (sinking fund).
  static double monthlySavingRequired({
    required double targetAmount,
    required double annualRate,
    required int months,
  }) {
    if (targetAmount <= 0 || months <= 0) return 0;
    if (annualRate <= 0) return targetAmount / months;

    final r = annualRate / 100 / 12;
    return targetAmount * r / (math.pow(1 + r, months) - 1);
  }

  /// Amortisation schedule: list of {month, payment, principal, interest, balance}.
  static List<Map<String, double>> amortisationSchedule({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    if (principal <= 0 || months <= 0) return [];

    final payment = monthlyPayment(
      principal: principal,
      annualRate: annualRate,
      months: months,
    );
    final r = annualRate <= 0 ? 0.0 : annualRate / 100 / 12;
    double balance = principal;
    final schedule = <Map<String, double>>[];

    for (int m = 1; m <= months; m++) {
      final interest = balance * r;
      final principalPaid = payment - interest;
      balance = math.max(0, balance - principalPaid);
      schedule.add({
        'month': m.toDouble(),
        'payment': payment,
        'principal': principalPaid,
        'interest': interest,
        'balance': balance,
      });
    }
    return schedule;
  }

  /// DCA total principal for varying annual contribution increases.
  /// Returns [totalPrincipal, totalProfit, futureValue, List<{month, value}>].
  static Map<String, dynamic> dcaResult({
    required double monthlyInvestment,
    required double initialInvestment,
    required double annualReturnRate,
    required int years,
    double annualContributionIncrease = 0,
  }) {
    final months = years * 12;
    final monthlyRate = annualReturnRate / 100 / 12;

    double fv = initialInvestment * math.pow(1 + monthlyRate, months);
    double totalPrincipal = initialInvestment;
    double monthly = monthlyInvestment;
    final growth = <Map<String, double>>[];

    // Track value month-by-month for chart
    double runningFv = fv;
    double runningPrincipal = initialInvestment;

    for (int m = 1; m <= months; m++) {
      // Increase monthly contribution annually
      if (annualContributionIncrease > 0 && m > 1 && (m - 1) % 12 == 0) {
        monthly *= (1 + annualContributionIncrease / 100);
      }
      runningFv = (runningFv + monthly) * (1 + monthlyRate);
      runningPrincipal += monthly;
      totalPrincipal += monthly;

      if (m % (months <= 24 ? 1 : months ~/ 24) == 0 || m == months) {
        growth.add({'month': m.toDouble(), 'value': runningFv, 'principal': runningPrincipal});
      }
    }

    final futureValue = runningFv;
    final totalProfit = futureValue - totalPrincipal;

    return {
      'totalPrincipal': totalPrincipal,
      'totalProfit': totalProfit,
      'futureValue': futureValue,
      'growth': growth,
    };
  }
}
