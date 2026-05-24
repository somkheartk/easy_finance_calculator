class DcaInput {
  const DcaInput({
    required this.monthlyInvestment,
    required this.initialInvestment,
    required this.annualReturnRate,
    required this.years,
    this.annualContributionIncrease = 0,
  });

  final double monthlyInvestment;
  final double initialInvestment;
  final double annualReturnRate;
  final int years;
  final double annualContributionIncrease;

  Map<String, dynamic> toMap() => {
        'monthlyInvestment': monthlyInvestment,
        'initialInvestment': initialInvestment,
        'annualReturnRate': annualReturnRate,
        'years': years,
        'annualContributionIncrease': annualContributionIncrease,
      };

  factory DcaInput.fromMap(Map<String, dynamic> m) => DcaInput(
        monthlyInvestment: (m['monthlyInvestment'] as num).toDouble(),
        initialInvestment: (m['initialInvestment'] as num).toDouble(),
        annualReturnRate: (m['annualReturnRate'] as num).toDouble(),
        years: (m['years'] as num).toInt(),
        annualContributionIncrease:
            (m['annualContributionIncrease'] as num?)?.toDouble() ?? 0,
      );
}

class DcaResult {
  const DcaResult({
    required this.totalPrincipal,
    required this.totalProfit,
    required this.futureValue,
    required this.roi,
    required this.growthData,
  });

  final double totalPrincipal;
  final double totalProfit;
  final double futureValue;
  final double roi;
  final List<Map<String, double>> growthData;

  Map<String, dynamic> toResultMap() => {
        'totalPrincipal': totalPrincipal,
        'totalProfit': totalProfit,
        'futureValue': futureValue,
        'roi': roi,
      };
}
