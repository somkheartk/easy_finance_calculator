import 'package:go_router/go_router.dart';
import 'package:easy_finance_calculator/features/calculators/presentation/screens/calculators_screen.dart';
import 'package:easy_finance_calculator/features/car_loan/presentation/screens/car_loan_screen.dart';
import 'package:easy_finance_calculator/features/compound_interest/presentation/screens/compound_interest_screen.dart';
import 'package:easy_finance_calculator/features/dca/presentation/screens/dca_screen.dart';
import 'package:easy_finance_calculator/features/home/presentation/screens/home_screen.dart';
import 'package:easy_finance_calculator/features/home_loan/presentation/screens/home_loan_screen.dart';
import 'package:easy_finance_calculator/features/saved/presentation/screens/saved_screen.dart';
import 'package:easy_finance_calculator/features/saving_goal/presentation/screens/saving_goal_screen.dart';
import 'package:easy_finance_calculator/features/settings/presentation/screens/settings_screen.dart';
import 'package:easy_finance_calculator/routes/main_scaffold.dart';

abstract class AppRoutes {
  static const home = '/';
  static const calculators = '/calculators';
  static const saved = '/saved';
  static const settings = '/settings';
  static const dca = '/calculators/dca';
  static const carLoan = '/calculators/car-loan';
  static const homeLoan = '/calculators/home-loan';
  static const savingGoal = '/calculators/saving-goal';
  static const compound = '/calculators/compound';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: AppRoutes.calculators,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CalculatorsScreen()),
          routes: [
            GoRoute(
              path: 'dca',
              builder: (context, state) => const DcaScreen(),
            ),
            GoRoute(
              path: 'car-loan',
              builder: (context, state) => const CarLoanScreen(),
            ),
            GoRoute(
              path: 'home-loan',
              builder: (context, state) => const HomeLoanScreen(),
            ),
            GoRoute(
              path: 'saving-goal',
              builder: (context, state) => const SavingGoalScreen(),
            ),
            GoRoute(
              path: 'compound',
              builder: (context, state) => const CompoundInterestScreen(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.saved,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SavedScreen()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
  ],
);
