import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/features/home_loan/domain/home_loan_model.dart';
import 'package:easy_finance_calculator/features/home_loan/presentation/providers/home_loan_provider.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/shared/widgets/app_text_field.dart';
import 'package:easy_finance_calculator/shared/widgets/result_tile.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class HomeLoanScreen extends ConsumerStatefulWidget {
  const HomeLoanScreen({super.key});

  @override
  ConsumerState<HomeLoanScreen> createState() => _HomeLoanScreenState();
}

class _HomeLoanScreenState extends ConsumerState<HomeLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceCtrl = TextEditingController();
  final _downCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  @override
  void dispose() {
    _priceCtrl.dispose();
    _downCtrl.dispose();
    _rateCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final price = double.parse(_priceCtrl.text);
    final down = double.tryParse(_downCtrl.text) ?? 0;
    if (down >= price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Down payment must be less than house price')),
      );
      return;
    }
    final input = HomeLoanInput(
      housePrice: price,
      downPayment: down,
      interestRate: double.parse(_rateCtrl.text),
      years: int.parse(_yearsCtrl.text),
    );
    ref.read(homeLoanResultProvider.notifier).calculate(input);
    ref.read(historyProvider.notifier).add(
          type: AppConstants.calcHomeLoan,
          inputs: input.toMap(),
          results: ref.read(homeLoanResultProvider)?.toResultMap() ?? {},
        );
  }

  Future<void> _save() async {
    final result = ref.read(homeLoanResultProvider);
    if (result == null) return;
    final name = await SavePlanDialog.show(context,
        initialName: 'Home ${_yearsCtrl.text}yr');
    if (name == null || !mounted) return;
    final input = HomeLoanInput(
      housePrice: double.parse(_priceCtrl.text),
      downPayment: double.tryParse(_downCtrl.text) ?? 0,
      interestRate: double.parse(_rateCtrl.text),
      years: int.parse(_yearsCtrl.text),
    );
    await ref.read(savedPlansProvider.notifier).save(
          type: AppConstants.calcHomeLoan,
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
    final result = ref.watch(homeLoanResultProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeLoanCalculator),
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
                      label: l10n.housePrice,
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
                      label: l10n.loanYears,
                      suffix: l10n.years,
                      controller: _yearsCtrl,
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
              _HomeLoanResultCard(result: result, currency: currency),
              const SizedBox(height: 16),
              _ScheduleSection(result: result, currency: currency),
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

class _HomeLoanResultCard extends StatelessWidget {
  const _HomeLoanResultCard({required this.result, required this.currency});

  final HomeLoanResult result;
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
                colors: [AppColors.homeLoanColor, Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.monthlyPayment,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
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

class _ScheduleSection extends StatefulWidget {
  const _ScheduleSection({required this.result, required this.currency});

  final HomeLoanResult result;
  final String currency;

  @override
  State<_ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<_ScheduleSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final schedule = widget.result.schedule;
    final shown = _expanded ? schedule : schedule.take(12).toList();

    return AppCard(
      elevation: 1,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(l10n.paymentSchedule,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            trailing: Icon(_expanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          const Divider(height: 1),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _HeaderCell(l10n.month, flex: 1),
                _HeaderCell(l10n.principal, flex: 2),
                _HeaderCell(l10n.interest, flex: 2),
                _HeaderCell(l10n.balance, flex: 2),
              ],
            ),
          ),
          const Divider(height: 1),
          ...shown.map(
            (row) => _ScheduleRow(row: row, currency: widget.currency),
          ),
          if (!_expanded && schedule.length > 12)
            TextButton(
              onPressed: () => setState(() => _expanded = true),
              child: Text('Show all ${schedule.length} months'),
            ),
          if (_expanded)
            TextButton(
              onPressed: () => setState(() => _expanded = false),
              child: const Text('Show less'),
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {required this.flex});

  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        textAlign: flex == 1 ? TextAlign.start : TextAlign.end,
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.row, required this.currency});

  final Map<String, double> row;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final month = row['month']!.toInt();
    return Container(
      color: month % 2 == 0
          ? (isDark
              ? Colors.white.withOpacity(0.03)
              : Colors.grey.withOpacity(0.04))
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('$month',
                style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            flex: 2,
            child: Text(
              CurrencyFormatter.format(row['principal']!,
                  currencyCode: currency, compact: true),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              CurrencyFormatter.format(row['interest']!,
                  currencyCode: currency, compact: true),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warning,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              CurrencyFormatter.format(row['balance']!,
                  currencyCode: currency, compact: true),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
