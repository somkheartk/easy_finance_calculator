import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/features/car_loan/domain/car_loan_model.dart';
import 'package:easy_finance_calculator/features/car_loan/presentation/providers/car_loan_provider.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/shared/widgets/app_text_field.dart';
import 'package:easy_finance_calculator/shared/widgets/result_tile.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class CarLoanScreen extends ConsumerStatefulWidget {
  const CarLoanScreen({super.key});

  @override
  ConsumerState<CarLoanScreen> createState() => _CarLoanScreenState();
}

class _CarLoanScreenState extends ConsumerState<CarLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceCtrl = TextEditingController();
  final _downCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();

  @override
  void dispose() {
    _priceCtrl.dispose();
    _downCtrl.dispose();
    _rateCtrl.dispose();
    _monthsCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final price = double.parse(_priceCtrl.text);
    final down = double.tryParse(_downCtrl.text) ?? 0;
    if (down >= price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Down payment must be less than car price')),
      );
      return;
    }

    final input = CarLoanInput(
      carPrice: price,
      downPayment: down,
      interestRate: double.parse(_rateCtrl.text),
      months: int.parse(_monthsCtrl.text),
    );
    ref.read(carLoanResultProvider.notifier).calculate(input);
    ref.read(historyProvider.notifier).add(
          type: AppConstants.calcCarLoan,
          inputs: input.toMap(),
          results: ref.read(carLoanResultProvider)?.toResultMap() ?? {},
        );
  }

  Future<void> _save() async {
    final result = ref.read(carLoanResultProvider);
    if (result == null) return;
    final name =
        await SavePlanDialog.show(context, initialName: 'Car ${_priceCtrl.text}');
    if (name == null || !mounted) return;
    final input = CarLoanInput(
      carPrice: double.parse(_priceCtrl.text),
      downPayment: double.tryParse(_downCtrl.text) ?? 0,
      interestRate: double.parse(_rateCtrl.text),
      months: int.parse(_monthsCtrl.text),
    );
    await ref.read(savedPlansProvider.notifier).save(
          type: AppConstants.calcCarLoan,
          name: name,
          inputs: input.toMap(),
          results: result.toResultMap(),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.savedSuccessfully)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = ref.watch(carLoanResultProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.carLoanCalculator),
        actions: [
          if (result != null)
            IconButton(
                icon: const Icon(Icons.bookmark_add_outlined),
                onPressed: _save),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              elevation: 1,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.inputs,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    NumericTextField(
                      label: l10n.carPrice,
                      suffix: CurrencySymbols.symbolFor(currency),
                      controller: _priceCtrl,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.downPayment,
                      suffix: CurrencySymbols.symbolFor(currency),
                      controller: _downCtrl,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.interestRate,
                      suffix: '%',
                      controller: _rateCtrl,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.installmentMonths,
                      suffix: l10n.months,
                      controller: _monthsCtrl,
                      allowDecimal: false,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate_outlined),
                      label: Text(l10n.calculate),
                    ),
                  ],
                ),
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: 16),
              _ResultCard(result: result, currency: currency),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String? _requiredPositive(String? v) {
    if (v == null || v.isEmpty) return context.l10n.fieldRequired;
    final n = double.tryParse(v);
    if (n == null) return context.l10n.invalidNumber;
    if (n <= 0) return context.l10n.valueMustBePositive;
    return null;
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.currency});

  final CarLoanResult result;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      elevation: 1,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.carLoanColor, Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.monthlyPayment,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(result.monthlyPayment,
                      currencyCode: currency),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ResultTile(
                  label: l10n.loanAmount,
                  value: CurrencyFormatter.format(result.loanAmount,
                      currencyCode: currency),
                  icon: Icons.account_balance_outlined,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.totalPayment,
                  value: CurrencyFormatter.format(result.totalPayment,
                      currencyCode: currency),
                  icon: Icons.payments_outlined,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.totalInterest,
                  value: CurrencyFormatter.format(result.totalInterest,
                      currencyCode: currency),
                  icon: Icons.percent_rounded,
                  valueColor: AppColors.warning,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
