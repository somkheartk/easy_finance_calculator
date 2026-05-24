class SavingGoalInput {
  const SavingGoalInput({
    required this.targetAmount,
    required this.months,
    this.annualRate = 0,
  });

  final double targetAmount;
  final int months;
  final double annualRate;

  Map<String, dynamic> toMap() => {
        'targetAmount': targetAmount,
        'months': months,
        'annualRate': annualRate,
      };

  factory SavingGoalInput.fromMap(Map<String, dynamic> m) => SavingGoalInput(
        targetAmount: (m['targetAmount'] as num).toDouble(),
        months: (m['months'] as num).toInt(),
        annualRate: (m['annualRate'] as num?)?.toDouble() ?? 0,
      );
}

class SavingGoalResult {
  const SavingGoalResult({
    required this.monthlySaving,
    required this.weeklySaving,
    required this.dailySaving,
    required this.totalSaved,
    required this.interestEarned,
  });

  final double monthlySaving;
  final double weeklySaving;
  final double dailySaving;
  final double totalSaved;
  final double interestEarned;

  Map<String, dynamic> toResultMap() => {
        'monthlySaving': monthlySaving,
        'weeklySaving': weeklySaving,
        'dailySaving': dailySaving,
        'totalSaved': totalSaved,
        'interestEarned': interestEarned,
      };
}
