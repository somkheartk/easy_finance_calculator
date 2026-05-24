import 'package:easy_finance_calculator/core/utils/calculation_utils.dart';
import 'package:easy_finance_calculator/features/dca/domain/dca_model.dart';

class DcaService {
  const DcaService();

  DcaResult calculate(DcaInput input) {
    final raw = CalculationUtils.dcaResult(
      monthlyInvestment: input.monthlyInvestment,
      initialInvestment: input.initialInvestment,
      annualReturnRate: input.annualReturnRate,
      years: input.years,
      annualContributionIncrease: input.annualContributionIncrease,
    );

    final totalPrincipal = raw['totalPrincipal'] as double;
    final totalProfit = raw['totalProfit'] as double;
    final futureValue = raw['futureValue'] as double;
    final growthData = raw['growth'] as List<Map<String, double>>;
    final roi = totalPrincipal > 0 ? (totalProfit / totalPrincipal) * 100 : 0.0;

    return DcaResult(
      totalPrincipal: totalPrincipal,
      totalProfit: totalProfit,
      futureValue: futureValue,
      roi: roi,
      growthData: growthData,
    );
  }
}
