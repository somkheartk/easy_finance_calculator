import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/features/compound_interest/domain/compound_interest_model.dart';
import 'package:easy_finance_calculator/features/compound_interest/presentation/providers/compound_interest_provider.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/shared/widgets/app_text_field.dart';
import 'package:easy_finance_calculator/shared/widgets/growth_chart.dart';
import 'package:easy_finance_calculator/shared/widgets/result_tile.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class CompoundInterestScreen extends ConsumerStatefulWidget {
  const CompoundInterestScreen({super.key});

  @override
  ConsumerState<CompoundInterestScreen> createState() =>
      _CompoundInterestScreenState();
}

class _CompoundInterestScreenState
    extends ConsumerState<CompoundInterestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _principalCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  int _compoundingPerYear = 12;

  @override
  void dispose() {
    _principalCtrl.dispose();
    _rateCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final input = CompoundInput(
      principal: double.parse(_principalCtrl.text),
      annualRate: double.parse(_rateCtrl.text),
      years: int.parse(_yearsCtrl.text),
      compoundingPerYear: _compoundingPerYear,
    );
    ref.read(compoundResultProvider.notifier).calculate(input);
    ref.read(historyProvider.notifier).add(
          type: AppConstants.calcCompound,
          inputs: input.toMap(),
          results: ref.read(compoundResultProvider)?.toResultMap() ?? {},
        );
  }

  Future<void> _save() async {
    final result = ref.read(compoundResultProvider);
    if (result == null) return;
    final name = await SavePlanDialog.show(context,
        initialName: 'Compound ${_yearsCtrl.text}yr');
    if (name == null || !mounted) return;
    final input = CompoundInput(
      principal: double.parse(_principalCtrl.text),
      annualRate: double.parse(_rateCtrl.text),
      years: int.parse(_yearsCtrl.text),
      compoundingPerYear: _compoundingPerYear,
    );
    await ref.read(savedPlansProvider.notifier).save(
          type: AppConstants.calcCompound,
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
    final result = ref.watch(compoundResultProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.compoundInterestCalculator),
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
                      label: l10n.initialAmount,
                      suffix: CurrencySymbols.symbolFor(currency),
                      controller: _principalCtrl,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.expectedAnnualReturn,
                      suffix: '%',
                      controller: _rateCtrl,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.investmentPeriod,
                      suffix: l10n.years,
                      controller: _yearsCtrl,
                      allowDecimal: false,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.compoundingFrequency,
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    _CompoundingSelector(
                      selected: _compoundingPerYear,
                      onChanged: (v) =>
                          setState(() => _compoundingPerYear = v),
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
              _CompoundResultCard(
                  result: result,
                  currency: currency,
                  principal: double.tryParse(_principalCtrl.text) ?? 0),
              const SizedBox(height: 16),
              AppCard(
                elevation: 1,
                child: _CompoundChart(result: result, currency: currency),
              ),
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

class _CompoundingSelector extends StatelessWidget {
  const _CompoundingSelector({
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  static const _options = [
    (1, 'Annually'),
    (2, 'Semi-annually'),
    (4, 'Quarterly'),
    (12, 'Monthly'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _options.map((opt) {
        final isSelected = opt.$1 == selected;
        return ChoiceChip(
          label: Text(opt.$2),
          selected: isSelected,
          onSelected: (_) => onChanged(opt.$1),
          selectedColor:
              Theme.of(context).colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }
}

class _CompoundResultCard extends StatelessWidget {
  const _CompoundResultCard(
      {required this.result,
      required this.currency,
      required this.principal});

  final CompoundResult result;
  final String currency;
  final double principal;

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
                colors: [AppColors.compoundColor, Color(0xFF512DA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.futureValue,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(result.futureValue,
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
                  label: l10n.initialAmount,
                  value: CurrencyFormatter.format(principal,
                      currencyCode: currency),
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.totalInterest,
                  value: CurrencyFormatter.format(result.totalInterest,
                      currencyCode: currency),
                  icon: Icons.trending_up_rounded,
                  valueColor: AppColors.success,
                  isHighlighted: true,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.returnOnInvestment,
                  value: CurrencyFormatter.formatPercent(result.roi),
                  icon: Icons.percent_rounded,
                  valueColor: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompoundChart extends StatelessWidget {
  const _CompoundChart({required this.result, required this.currency});

  final CompoundResult result;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final pts = result.growthData
        .map((d) => {'month': d['year']! * 12, 'value': d['value']!})
        .toList();
    if (pts.isEmpty) return const SizedBox.shrink();

    return GrowthLineChart(
      dataPoints: pts,
      principalPoints: List.generate(
          pts.length, (i) => {'month': pts[i]['month']!, 'principal': 0.0}),
      currencyCode: currency,
      title: context.l10n.growthChart,
      valueLabel: context.l10n.futureValue,
      principalLabel: '',
    );
  }
}
