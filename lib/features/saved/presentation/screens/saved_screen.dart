import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/routes/app_router.dart';
import 'package:easy_finance_calculator/shared/models/saved_plan.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  String? _filterType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = ref.watch(savedPlansProvider);
    final currency = ref.watch(currencyProvider);

    final filtered = _filterType == null
        ? all
        : all.where((p) => p.type == _filterType).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.saved)),
      body: Column(
        children: [
          _FilterChips(
            selected: _filterType,
            onChanged: (v) => setState(() => _filterType = v),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState(message: l10n.noSavedPlans)
                : ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _PlanTile(
                      plan: filtered[i],
                      currency: currency,
                      onDelete: () => _delete(filtered[i].id),
                      onFavorite: () =>
                          ref.read(savedPlansProvider.notifier)
                              .toggleFavorite(filtered[i].id),
                      onOpen: () => _openCalc(context, filtered[i].type),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(String id) async {
    final confirmed = await showConfirmDialog(
      context,
      title: context.l10n.confirmDelete,
      message: context.l10n.confirmDeleteMsg,
    );
    if (!confirmed || !mounted) return;
    await ref.read(savedPlansProvider.notifier).delete(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.deletedSuccessfully)));
    }
  }

  void _openCalc(BuildContext context, String type) {
    switch (type) {
      case AppConstants.calcDca:
        context.go(AppRoutes.dca);
      case AppConstants.calcCarLoan:
        context.go(AppRoutes.carLoan);
      case AppConstants.calcHomeLoan:
        context.go(AppRoutes.homeLoan);
      case AppConstants.calcSavingGoal:
        context.go(AppRoutes.savingGoal);
      case AppConstants.calcCompound:
        context.go(AppRoutes.compound);
    }
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final types = [
      (null, 'All'),
      (AppConstants.calcDca, l10n.dcaCalculator),
      (AppConstants.calcCarLoan, l10n.carLoanCalculator),
      (AppConstants.calcHomeLoan, l10n.homeLoanCalculator),
      (AppConstants.calcSavingGoal, l10n.savingGoalCalculator),
      (AppConstants.calcCompound, l10n.compoundInterestCalculator),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: types.map((t) {
            final isSelected = t.$1 == selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(t.$2),
                selected: isSelected,
                onSelected: (_) => onChanged(t.$1),
                selectedColor:
                    Theme.of(context).colorScheme.primaryContainer,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.currency,
    required this.onDelete,
    required this.onFavorite,
    required this.onOpen,
  });

  final SavedPlan plan;
  final String currency;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(plan.type);
    return AppCard(
      elevation: 1,
      onTap: onOpen,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_iconForType(plan.type), color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _summaryFor(plan, currency),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              plan.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: plan.isFavorite ? AppColors.warning : Colors.grey,
            ),
            onPressed: onFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: Theme.of(context).colorScheme.error,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Color _colorForType(String type) => switch (type) {
        AppConstants.calcDca => AppColors.dcaColor,
        AppConstants.calcCarLoan => AppColors.carLoanColor,
        AppConstants.calcHomeLoan => AppColors.homeLoanColor,
        AppConstants.calcSavingGoal => AppColors.savingGoalColor,
        _ => AppColors.compoundColor,
      };

  IconData _iconForType(String type) => switch (type) {
        AppConstants.calcDca => Icons.trending_up_rounded,
        AppConstants.calcCarLoan => Icons.directions_car_rounded,
        AppConstants.calcHomeLoan => Icons.home_rounded,
        AppConstants.calcSavingGoal => Icons.savings_rounded,
        _ => Icons.auto_graph_rounded,
      };

  String _summaryFor(SavedPlan plan, String currency) {
    final r = plan.results;
    final key = r.containsKey('futureValue')
        ? 'futureValue'
        : r.containsKey('monthlyPayment')
            ? 'monthlyPayment'
            : r.containsKey('monthlySaving')
                ? 'monthlySaving'
                : null;
    if (key == null) return '';
    return CurrencyFormatter.format((r[key] as num).toDouble(),
        currencyCode: currency, compact: true);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border_rounded,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }
}
