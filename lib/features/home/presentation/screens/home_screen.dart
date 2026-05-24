import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/core/utils/currency_formatter.dart';
import 'package:easy_finance_calculator/shared/models/calculation_history.dart';
import 'package:easy_finance_calculator/shared/models/saved_plan.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/saved_provider.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';
import 'package:easy_finance_calculator/routes/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final history = ref.watch(historyProvider);
    final favorites = ref.watch(favoritePlansProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(l10n.appName),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _SearchBar(
                  hint: l10n.searchCalculators,
                  onTap: () => context.go(AppRoutes.calculators),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuickAccessGrid(),
                  const SizedBox(height: 28),
                  if (favorites.isNotEmpty) ...[
                    _SectionHeader(
                      title: l10n.favorites,
                      icon: Icons.star_rounded,
                    ),
                    const SizedBox(height: 12),
                    _FavoritesList(plans: favorites),
                    const SizedBox(height: 28),
                  ],
                  _SectionHeader(
                    title: l10n.recentCalculations,
                    icon: Icons.history_rounded,
                  ),
                  const SizedBox(height: 12),
                  if (history.isEmpty)
                    _EmptyState(message: l10n.noRecentCalculations)
                  else
                    _RecentList(history: history.take(5).toList()),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.search, size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              hint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = _calcItems(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _CalcCard(item: items[i]),
    );
  }

  List<_CalcItem> _calcItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _CalcItem(
        title: l10n.dcaCalculator,
        icon: Icons.trending_up_rounded,
        color: AppColors.dcaColor,
        route: AppRoutes.dca,
      ),
      _CalcItem(
        title: l10n.carLoanCalculator,
        icon: Icons.directions_car_rounded,
        color: AppColors.carLoanColor,
        route: AppRoutes.carLoan,
      ),
      _CalcItem(
        title: l10n.homeLoanCalculator,
        icon: Icons.home_rounded,
        color: AppColors.homeLoanColor,
        route: AppRoutes.homeLoan,
      ),
      _CalcItem(
        title: l10n.savingGoalCalculator,
        icon: Icons.savings_rounded,
        color: AppColors.savingGoalColor,
        route: AppRoutes.savingGoal,
      ),
      _CalcItem(
        title: l10n.compoundInterestCalculator,
        icon: Icons.auto_graph_rounded,
        color: AppColors.compoundColor,
        route: AppRoutes.compound,
      ),
    ];
  }
}

class _CalcItem {
  const _CalcItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String route;
}

class _CalcCard extends StatelessWidget {
  const _CalcCard({required this.item});

  final _CalcItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return AppCard(
      onTap: () => context.go(item.route),
      elevation: 1,
      color: item.color.withOpacity(isDark ? 0.15 : 0.1),
      border: Border.all(
        color: item.color.withOpacity(isDark ? 0.3 : 0.2),
        width: 1,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  const _FavoritesList({required this.plans});

  final List<SavedPlan> plans;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: plans.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _FavoriteChip(plan: plans[i]),
      ),
    );
  }
}

class _FavoriteChip extends StatelessWidget {
  const _FavoriteChip({required this.plan});

  final SavedPlan plan;

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(plan.type);
    return AppCard(
      onTap: () => _navigate(context, plan),
      elevation: 1,
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconForType(plan.type), size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                plan.name,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _summaryFor(plan),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, SavedPlan plan) {
    switch (plan.type) {
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

  String _summaryFor(SavedPlan plan) {
    final r = plan.results;
    if (r.containsKey('futureValue')) {
      return CurrencyFormatter.format(
          (r['futureValue'] as num).toDouble(), compact: true);
    }
    if (r.containsKey('monthlyPayment')) {
      return CurrencyFormatter.format(
          (r['monthlyPayment'] as num).toDouble(), compact: true);
    }
    if (r.containsKey('monthlySaving')) {
      return CurrencyFormatter.format(
          (r['monthlySaving'] as num).toDouble(), compact: true);
    }
    return '';
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList({required this.history});

  final List<CalculationHistory> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: history
          .map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HistoryTile(entry: h),
              ))
          .toList(),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final CalculationHistory entry;

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(entry.type);
    return AppCard(
      onTap: () => _navigate(context, entry.type),
      elevation: 0,
      border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_iconForType(entry.type), size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _labelForType(context, entry.type),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(entry.calculatedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            _summaryFor(entry),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String type) {
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

  String _labelForType(BuildContext context, String type) {
    final l10n = context.l10n;
    return switch (type) {
      AppConstants.calcDca => l10n.dcaCalculator,
      AppConstants.calcCarLoan => l10n.carLoanCalculator,
      AppConstants.calcHomeLoan => l10n.homeLoanCalculator,
      AppConstants.calcSavingGoal => l10n.savingGoalCalculator,
      _ => l10n.compoundInterestCalculator,
    };
  }

  String _summaryFor(CalculationHistory entry) {
    final r = entry.results;
    if (r.containsKey('futureValue')) {
      return CurrencyFormatter.format(
          (r['futureValue'] as num).toDouble(), compact: true);
    }
    if (r.containsKey('monthlyPayment')) {
      return CurrencyFormatter.format(
          (r['monthlyPayment'] as num).toDouble(), compact: true);
    }
    if (r.containsKey('monthlySaving')) {
      return CurrencyFormatter.format(
          (r['monthlySaving'] as num).toDouble(), compact: true);
    }
    return '';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
