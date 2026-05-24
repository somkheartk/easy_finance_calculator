import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/features/dca/domain/dca_model.dart';
import 'package:easy_finance_calculator/features/dca/presentation/providers/dca_provider.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/shared/widgets/app_text_field.dart';
import 'package:easy_finance_calculator/shared/widgets/growth_chart.dart';
import 'package:easy_finance_calculator/shared/widgets/result_tile.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class DcaScreen extends ConsumerStatefulWidget {
  const DcaScreen({super.key});

  @override
  ConsumerState<DcaScreen> createState() => _DcaScreenState();
}

class _DcaScreenState extends ConsumerState<DcaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyCtrl = TextEditingController();
  final _initialCtrl = TextEditingController();
  final _returnCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _increaseCtrl = TextEditingController();
  @override
  void dispose() {
    _monthlyCtrl.dispose();
    _initialCtrl.dispose();
    _returnCtrl.dispose();
    _yearsCtrl.dispose();
    _increaseCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final input = DcaInput(
      monthlyInvestment: double.parse(_monthlyCtrl.text),
      initialInvestment: double.tryParse(_initialCtrl.text) ?? 0,
      annualReturnRate: double.parse(_returnCtrl.text),
      years: int.parse(_yearsCtrl.text),
      annualContributionIncrease:
          double.tryParse(_increaseCtrl.text) ?? 0,
    );
    ref.read(dcaResultProvider.notifier).calculate(input);
    ref.read(historyProvider.notifier).add(
          type: AppConstants.calcDca,
          inputs: input.toMap(),
          results:
              ref.read(dcaResultProvider)?.toResultMap() ?? {},
        );
  }

  Future<void> _save() async {
    final result = ref.read(dcaResultProvider);
    if (result == null) return;

    final name = await SavePlanDialog.show(context,
        initialName: 'DCA ${_yearsCtrl.text}yr');
    if (name == null || !mounted) return;

    final input = DcaInput(
      monthlyInvestment: double.parse(_monthlyCtrl.text),
      initialInvestment: double.tryParse(_initialCtrl.text) ?? 0,
      annualReturnRate: double.parse(_returnCtrl.text),
      years: int.parse(_yearsCtrl.text),
      annualContributionIncrease:
          double.tryParse(_increaseCtrl.text) ?? 0,
    );

    await ref.read(savedPlansProvider.notifier).save(
          type: AppConstants.calcDca,
          name: name,
          inputs: input.toMap(),
          results: result.toResultMap(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.savedSuccessfully)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = ref.watch(dcaResultProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dcaCalculator),
        actions: [
          if (result != null)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              onPressed: _save,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input card
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
                      label: l10n.monthlyInvestment,
                      suffix: CurrencySymbols.symbolFor(currency),
                      controller: _monthlyCtrl,
                      validator: _requiredPositive,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.initialInvestment,
                      suffix: CurrencySymbols.symbolFor(currency),
                      controller: _initialCtrl,
                    ),
                    const SizedBox(height: 12),
                    NumericTextField(
                      label: l10n.expectedAnnualReturn,
                      suffix: '%',
                      controller: _returnCtrl,
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
                    const SizedBox(height: 12),
                    NumericTextField(
                      label:
                          '${l10n.annualContributionIncrease} (${l10n.optional})',
                      suffix: '%',
                      controller: _increaseCtrl,
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

            // Results
            if (result != null) ...[
              const SizedBox(height: 16),
              _DcaResultCard(result: result, currency: currency),
              const SizedBox(height: 16),
              AppCard(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GrowthLineChart(
                            dataPoints: result.growthData
                                .map((d) =>
                                    {'month': d['month']!, 'value': d['value']!})
                                .toList(),
                            principalPoints: result.growthData
                                .map((d) => {
                                      'month': d['month']!,
                                      'principal': d['principal']!
                                    })
                                .toList(),
                            currencyCode: currency,
                            title: l10n.growthChart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                elevation: 1,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DonutChart(
                      principal: result.totalPrincipal,
                      profit: result.totalProfit,
                      principalLabel: l10n.totalPrincipal,
                      profitLabel: l10n.totalProfit,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegendRow(
                            color: AppColors.primary.withOpacity(0.7),
                            label: l10n.totalPrincipal,
                            value: CurrencyFormatter.format(
                                result.totalPrincipal,
                                currencyCode: currency),
                          ),
                          const SizedBox(height: 8),
                          _LegendRow(
                            color: AppColors.success,
                            label: l10n.totalProfit,
                            value: CurrencyFormatter.format(result.totalProfit,
                                currencyCode: currency),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

class _DcaResultCard extends StatelessWidget {
  const _DcaResultCard({required this.result, required this.currency});

  final DcaResult result;
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.dcaColor.withOpacity(0.8),
                  AppColors.dcaColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.futureValue,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
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
                  label: l10n.totalPrincipal,
                  value: CurrencyFormatter.format(result.totalPrincipal,
                      currencyCode: currency),
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const ResultsDivider(),
                ResultTile(
                  label: l10n.totalProfit,
                  value: CurrencyFormatter.format(result.totalProfit,
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
                  valueColor:
                      result.roi >= 0 ? AppColors.success : AppColors.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow(
      {required this.color, required this.label, required this.value});

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}
