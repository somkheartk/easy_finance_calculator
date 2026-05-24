import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/shared/database/hive_service.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier()
      : super(const Locale(AppConstants.defaultLocale)) {
    _load();
  }

  void _load() {
    final stored = HiveService.instance.getSetting(
      AppConstants.localeKey,
      defaultValue: AppConstants.defaultLocale,
    ) as String;
    state = Locale(stored);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await HiveService.instance
        .setSetting(AppConstants.localeKey, locale.languageCode);
  }
}
