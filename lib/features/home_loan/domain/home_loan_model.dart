class HomeLoanInput {
  const HomeLoanInput({
    required this.housePrice,
    required this.downPayment,
    required this.interestRate,
    required this.years,
  });

  final double housePrice;
  final double downPayment;
  final double interestRate;
  final int years;

  double get loanAmount => housePrice - downPayment;
  int get months => years * 12;

  Map<String, dynamic> toMap() => {
        'housePrice': housePrice,
        'downPayment': downPayment,
        'interestRate': interestRate,
        'years': years,
      };

  factory HomeLoanInput.fromMap(Map<String, dynamic> m) => HomeLoanInput(
        housePrice: (m['housePrice'] as num).toDouble(),
        downPayment: (m['downPayment'] as num).toDouble(),
        interestRate: (m['interestRate'] as num).toDouble(),
        years: (m['years'] as num).toInt(),
      );
}

class HomeLoanResult {
  const HomeLoanResult({
    required this.monthlyPayment,
    required this.totalPayment,
    required this.totalInterest,
    required this.loanAmount,
    required this.schedule,
  });

  final double monthlyPayment;
  final double totalPayment;
  final double totalInterest;
  final double loanAmount;
  final List<Map<String, double>> schedule;

  Map<String, dynamic> toResultMap() => {
        'monthlyPayment': monthlyPayment,
        'totalPayment': totalPayment,
        'totalInterest': totalInterest,
        'loanAmount': loanAmount,
      };
}
