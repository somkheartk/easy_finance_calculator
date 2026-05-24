import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/routes/app_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.calculators,
    AppRoutes.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int selectedIndex = _tabs.indexWhere((t) => location.startsWith(t));
    if (selectedIndex == -1) selectedIndex = 0;

    // Disambiguate: '/' must not match '/calculators', '/saved', '/settings'
    if (location != '/' && location.startsWith('/') && selectedIndex == 0) {
      for (int i = 1; i < _tabs.length; i++) {
        if (location.startsWith(_tabs[i])) {
          selectedIndex = i;
          break;
        }
      }
    }

    final l10n = context.l10n;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == selectedIndex) return;
          context.go(_tabs[index]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: l10n.calculators,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
