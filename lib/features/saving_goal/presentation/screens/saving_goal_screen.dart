import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/features/saving_goal/domain/saving_goal_model.dart';
import 'package:easy_finance_calculator/features/saving_goal/presentation/providers/saving_goal_provider.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/shared/widgets/app_text_field.dart';
import 'package:easy_finance_calculator/shared/widgets/result_tile.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class SavingGoalScreen extends ConsumerStatefulWidget {
  const SavingGoalScreen({super.key});

  @override
  ConsumerState<SavingGoalScreen> createState() => _SavingGoalScreenState();
}

class _SavingGoalScreenState extends ConsumerState<SavingGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  @override
  void dispose() {
    _targetCtrl.dispose();
    _monthsCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final input = SavingGoalInput(
      targetAmount: double.parse(_targetCtrl.text),
      months: int.parse(_monthsCtrl.text),
      annualRate: double.tryParse(_rateCtrl.text) ?? 0,
    );
    ref.read(savingGoalResultProvider.notifier).calculate(input);
    ref.read(historyProvider.notifier).add(
          type: AppConstants.calcSavingGoal,
          inputs: input.toMap(),
          results: ref.read(savingGoalResultProvider)?.toResultMap() ?? {},
        );
  }

  Future<void> _save() async {
    final result = ref.read(savingGoalResultProvider);
    if (result == null) return;
    final name = await SavePlanDialog.show(context,
        initialName: 'Goal ${_targetCtrl.text}');
    if (name == null || !mounted) return;
    final input = SavingGoalInput(
      targetAmount: double.parse(_targetCtrl.text),
      months: int.parse(_monthsCtrl.text),
      annualRate: double.tryParse(_rateCtrl.text) ?? 0,
    );
    await ref.read(savedPlansProvider.notifier).save(
          type: AppConstants.calcSavingGoal,
          name: name,
          inputs: input.toMap(),
          results: result.toResultMap(),
        );
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.savedSuccessfully)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = ref.watch(savingGoalResultProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savingGoalCalculator),
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
                      label: l10n.targetAmount,
                      suffix: CurrencySymbols.symbolFor(currency),
                      controller: _targetCtrl,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.timeDuration,
                      suffix: l10n.months,
                      controller: _monthsCtrl,
                      allowDecimal: false,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label:
                          '${l10n.interestRate} (${l10n.optional})',
                      suffix: '%',
                      controller: _rateCtrl,
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
              _SavingResultCard(result: result, currency: currency),
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

class _SavingResultCard extends StatelessWidget {
  const _SavingResultCard({required this.result, required this.currency});

  final SavingGoalResult result;
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
                colors: [AppColors.savingGoalColor, Color(0xFFE65100)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.monthlySaving,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(result.monthlySaving,
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
                  label: l10n.weeklySaving,
                  value: CurrencyFormatter.format(result.weeklySaving,
                      currencyCode: currency),
                  icon: Icons.date_range_outlined,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.dailySaving,
                  value: CurrencyFormatter.format(result.dailySaving,
                      currencyCode: currency),
                  icon: Icons.today_outlined,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.totalPrincipal,
                  value: CurrencyFormatter.format(result.totalSaved,
                      currencyCode: currency),
                  icon: Icons.account_balance_wallet_outlined,
                ),
                if (result.interestEarned > 0) ...[
                  const ResultsDivider(),
                  ResultTile(
                    label: l10n.totalInterest,
                    value: CurrencyFormatter.format(result.interestEarned,
                        currencyCode: currency),
                    icon: Icons.trending_up_rounded,
                    valueColor: AppColors.success,
                    isHighlighted: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
