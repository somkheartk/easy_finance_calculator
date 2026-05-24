import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(
    double value, {
    String currencyCode = AppConstants.defaultCurrency,
    bool compact = false,
  }) {
    if (compact) {
      return _formatCompact(value, currencyCode);
    }
    final symbol = CurrencySymbols.symbolFor(currencyCode);
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '$symbol${formatter.format(value)}';
  }

  static String formatNoDecimal(
    double value, {
    String currencyCode = AppConstants.defaultCurrency,
  }) {
    final symbol = CurrencySymbols.symbolFor(currencyCode);
    final formatter = NumberFormat('#,##0', 'en_US');
    return '$symbol${formatter.format(value)}';
  }

  static String _formatCompact(double value, String currencyCode) {
    final symbol = CurrencySymbols.symbolFor(currencyCode);
    if (value >= 1000000000) {
      return '$symbol${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '$symbol${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '$symbol${(value / 1000).toStringAsFixed(1)}K';
    }
    return '$symbol${value.toStringAsFixed(2)}';
  }

  static String formatPercent(double value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  static String formatNumber(double value, {int decimals = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimals}', 'en_US');
    return formatter.format(value);
  }

  static double? tryParse(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }
}
