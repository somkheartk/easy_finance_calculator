import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/shared/database/hive_service.dart';

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super(AppConstants.defaultCurrency) {
    _load();
  }

  void _load() {
    state = HiveService.instance.getSetting(
      AppConstants.currencyKey,
      defaultValue: AppConstants.defaultCurrency,
    ) as String;
  }

  Future<void> setCurrency(String code) async {
    state = code;
    await HiveService.instance.setSetting(AppConstants.currencyKey, code);
  }
}
