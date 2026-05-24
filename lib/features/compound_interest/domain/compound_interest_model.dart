class CompoundInput {
  const CompoundInput({
    required this.principal,
    required this.annualRate,
    required this.years,
    this.compoundingPerYear = 12,
  });

  final double principal;
  final double annualRate;
  final int years;
  final int compoundingPerYear;

  Map<String, dynamic> toMap() => {
        'principal': principal,
        'annualRate': annualRate,
        'years': years,
        'compoundingPerYear': compoundingPerYear,
      };

  factory CompoundInput.fromMap(Map<String, dynamic> m) => CompoundInput(
        principal: (m['principal'] as num).toDouble(),
        annualRate: (m['annualRate'] as num).toDouble(),
        years: (m['years'] as num).toInt(),
        compoundingPerYear: (m['compoundingPerYear'] as num?)?.toInt() ?? 12,
      );
}

class CompoundResult {
  const CompoundResult({
    required this.futureValue,
    required this.totalInterest,
    required this.roi,
    required this.growthData,
  });

  final double futureValue;
  final double totalInterest;
  final double roi;
  final List<Map<String, double>> growthData;

  Map<String, dynamic> toResultMap() => {
        'futureValue': futureValue,
        'totalInterest': totalInterest,
        'roi': roi,
      };
}
