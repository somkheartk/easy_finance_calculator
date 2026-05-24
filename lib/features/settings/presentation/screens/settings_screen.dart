import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_finance_calculator/core/constants/app_colors.dart';
import 'package:easy_finance_calculator/core/constants/app_constants.dart';
import 'package:easy_finance_calculator/core/extensions/context_extension.dart';
import 'package:easy_finance_calculator/shared/providers/currency_provider.dart';
import 'package:easy_finance_calculator/shared/providers/history_provider.dart';
import 'package:easy_finance_calculator/shared/providers/locale_provider.dart';
import 'package:easy_finance_calculator/shared/providers/theme_provider.dart';
import 'package:easy_finance_calculator/shared/l10n/app_localizations.dart';
import 'package:easy_finance_calculator/shared/widgets/save_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Appearance
          _SectionHeader(title: l10n.appearance),
          _SettingsTile(
            icon: Icons.brightness_6_outlined,
            iconColor: AppColors.dcaColor,
            title: l10n.darkMode,
            subtitle: _themeName(themeMode, context),
            onTap: () => _showThemePicker(context, ref, themeMode),
          ),

          // Language & Region
          _SectionHeader(title: l10n.general),
          _SettingsTile(
            icon: Icons.language_outlined,
            iconColor: AppColors.carLoanColor,
            title: l10n.language,
            subtitle: locale.languageCode == 'th' ? 'ภาษาไทย' : 'English',
            onTap: () => _showLanguagePicker(context, ref, locale.languageCode),
          ),
          _SettingsTile(
            icon: Icons.attach_money_rounded,
            iconColor: AppColors.savingGoalColor,
            title: l10n.currency,
            subtitle: currency,
            onTap: () => _showCurrencyPicker(context, ref, currency),
          ),

          // Data
          _SectionHeader(title: 'Data'),
          _SettingsTile(
            icon: Icons.history_rounded,
            iconColor: AppColors.compoundColor,
            title: l10n.clearHistory,
            subtitle: 'Remove all calculation history',
            onTap: () async {
              final ok = await showConfirmDialog(
                context,
                title: l10n.confirmClearHistory,
                message: l10n.confirmClearHistoryMsg,
              );
              if (ok) {
                ref.read(historyProvider.notifier).clearAll();
              }
            },
          ),

          // Info
          _SectionHeader(title: 'Info'),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.blueGrey,
            title: l10n.privacyPolicy,
            onTap: () => _showPrivacyPolicy(context),
          ),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: Colors.blueGrey,
            title: l10n.about,
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _themeName(ThemeMode mode, BuildContext context) {
    final l10n = context.l10n;
    return switch (mode) {
      ThemeMode.dark => l10n.darkMode,
      ThemeMode.light => l10n.lightMode,
      _ => l10n.systemDefault,
    };
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, ThemeMode current) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(l10n.appearance,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final mode in ThemeMode.values)
              ListTile(
                title: Text(_themeModeLabel(mode, l10n)),
                leading: Radio<ThemeMode>(
                  value: mode,
                  groupValue: current,
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(themeModeProvider.notifier).setTheme(v);
                    }
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  ref.read(themeModeProvider.notifier).setTheme(mode);
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) => switch (mode) {
        ThemeMode.dark => l10n.darkMode,
        ThemeMode.light => l10n.lightMode,
        _ => l10n.systemDefault,
      };

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(context.l10n.language,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final (code, label) in [('en', 'English'), ('th', 'ภาษาไทย')])
              ListTile(
                title: Text(label),
                leading: Radio<String>(
                  value: code,
                  groupValue: current,
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(localeProvider.notifier).setLocale(Locale(v));
                    }
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(Locale(code));
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(
      BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(context.l10n.currency,
                  style: context.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...CurrencySymbols.symbols.entries.map(
                (e) => ListTile(
                  title: Text('${e.key}  ${e.value}'),
                  leading: Radio<String>(
                    value: e.key,
                    groupValue: current,
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(currencyProvider.notifier).setCurrency(v);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    ref.read(currencyProvider.notifier).setCurrency(e.key);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.privacyPolicy),
        content: const SingleChildScrollView(
          child: Text(
            'Easy Finance Calculator does not collect any personal data. '
            'All calculations and saved plans are stored locally on your '
            'device using Hive database. No data is transmitted to any server. '
            'We do not use analytics, ads, or any third-party tracking services.\n\n'
            'Your financial data stays private and secure on your device.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: context.l10n.appName,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Easy Finance Calculator',
      children: [
        const SizedBox(height: 12),
        const Text(
          'A production-ready personal finance calculator supporting '
          'DCA, Car Loan, Home Loan, Saving Goal, and Compound Interest calculations.\n\n'
          'Built with Flutter, Riverpod, and Hive.',
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
