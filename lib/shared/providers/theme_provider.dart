import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/shared/database/hive_service.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  void _load() {
    final stored = HiveService.instance.getSetting(AppConstants.themeKey,
        defaultValue: 'system') as String;
    state = _fromString(stored);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await HiveService.instance.setSetting(AppConstants.themeKey, _toString(mode));
  }

  ThemeMode _fromString(String s) => switch (s) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };

  String _toString(ThemeMode m) => switch (m) {
        ThemeMode.dark => 'dark',
        ThemeMode.light => 'light',
        _ => 'system',
      };
}
