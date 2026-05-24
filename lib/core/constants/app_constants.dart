abstract class AppConstants {
  // Hive boxes
  static const savedPlansBox = 'saved_plans';
  static const historyBox = 'calc_history';
  static const settingsBox = 'settings';

  // Settings keys
  static const themeKey = 'theme_mode';
  static const localeKey = 'locale';
  static const currencyKey = 'currency';

  // Limits
  static const maxHistoryItems = 50;
  static const maxSavedPlans = 200;
  static const maxChartPoints = 60;

  // Animation durations (ms)
  static const animFast = 200;
  static const animNormal = 350;
  static const animSlow = 600;

  // Defaults
  static const defaultCurrency = 'THB';
  static const defaultLocale = 'th';

  // Calculator types
  static const calcDca = 'dca';
  static const calcCarLoan = 'car_loan';
  static const calcHomeLoan = 'home_loan';
  static const calcSavingGoal = 'saving_goal';
  static const calcCompound = 'compound_interest';
}

abstract class CurrencySymbols {
  static const symbols = {
    'THB': '฿',
    'USD': '\$',
    'EUR': '€',
    'JPY': '¥',
    'GBP': '£',
    'SGD': 'S\$',
  };

  static String symbolFor(String code) => symbols[code] ?? code;
}
