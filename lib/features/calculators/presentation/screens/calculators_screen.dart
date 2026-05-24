import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/routes/app_router.dart';
import 'package:easy_finance_calculator/shared/widgets/app_card.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = _allCalcs(context)
        .where((c) => c.title.toLowerCase().contains(_query.toLowerCase()) ||
            c.description.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calculators)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: l10n.searchCalculators,
              leading: const Icon(Icons.search),
              onChanged: (v) => setState(() => _query = v),
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _CalcListTile(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }

  List<_CalcMeta> _allCalcs(BuildContext context) {
    final l10n = context.l10n;
    return [
      _CalcMeta(
        title: l10n.dcaCalculator,
        description: l10n.dcaDescription,
        icon: Icons.trending_up_rounded,
        color: AppColors.dcaColor,
        route: AppRoutes.dca,
      ),
      _CalcMeta(
        title: l10n.carLoanCalculator,
        description: l10n.carLoanDescription,
        icon: Icons.directions_car_rounded,
        color: AppColors.carLoanColor,
        route: AppRoutes.carLoan,
      ),
      _CalcMeta(
        title: l10n.homeLoanCalculator,
        description: l10n.homeLoanDescription,
        icon: Icons.home_rounded,
        color: AppColors.homeLoanColor,
        route: AppRoutes.homeLoan,
      ),
      _CalcMeta(
        title: l10n.savingGoalCalculator,
        description: l10n.savingGoalDescription,
        icon: Icons.savings_rounded,
        color: AppColors.savingGoalColor,
        route: AppRoutes.savingGoal,
      ),
      _CalcMeta(
        title: l10n.compoundInterestCalculator,
        description: l10n.compoundDescription,
        icon: Icons.auto_graph_rounded,
        color: AppColors.compoundColor,
        route: AppRoutes.compound,
      ),
    ];
  }
}

class _CalcMeta {
  const _CalcMeta({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
}

class _CalcListTile extends StatelessWidget {
  const _CalcListTile({required this.item});

  final _CalcMeta item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.go(item.route),
      elevation: 1,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
