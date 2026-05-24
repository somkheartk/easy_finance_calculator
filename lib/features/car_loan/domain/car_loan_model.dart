class CarLoanInput {
  const CarLoanInput({
    required this.carPrice,
    required this.downPayment,
    required this.interestRate,
    required this.months,
  });

  final double carPrice;
  final double downPayment;
  final double interestRate;
  final int months;

  double get loanAmount => carPrice - downPayment;

  Map<String, dynamic> toMap() => {
        'carPrice': carPrice,
        'downPayment': downPayment,
        'interestRate': interestRate,
        'months': months,
      };

  factory CarLoanInput.fromMap(Map<String, dynamic> m) => CarLoanInput(
        carPrice: (m['carPrice'] as num).toDouble(),
        downPayment: (m['downPayment'] as num).toDouble(),
        interestRate: (m['interestRate'] as num).toDouble(),
        months: (m['months'] as num).toInt(),
      );
}

class CarLoanResult {
  const CarLoanResult({
    required this.monthlyPayment,
    required this.totalPayment,
    required this.totalInterest,
    required this.loanAmount,
  });

  final double monthlyPayment;
  final double totalPayment;
  final double totalInterest;
  final double loanAmount;

  Map<String, dynamic> toResultMap() => {
        'monthlyPayment': monthlyPayment,
        'totalPayment': totalPayment,
        'totalInterest': totalInterest,
        'loanAmount': loanAmount,
      };
}
