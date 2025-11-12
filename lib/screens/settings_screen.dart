// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';

import 'package:swipe_clean_gallery/services/localization_service.dart';
import 'package:swipe_clean_gallery/services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final localizationService = context.watch<LocalizationService>();
    final themeService = context.watch<ThemeService>();

    final isDarkMode =
        themeService.themeMode == ThemeMode.dark ||
        (themeService.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _SectionHeader(label: l10n.language),
          _LanguageCard(
            localizationService: localizationService,
            l10n: l10n,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 24),
          _SectionHeader(label: l10n.theme),
          _ThemeCard(
            isDarkMode: isDarkMode,
            onChanged: (value) => themeService.toggleDarkMode(value),
            colorScheme: colorScheme,
            l10n: l10n,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.localizationService,
    required this.l10n,
    required this.colorScheme,
  });

  final LocalizationService localizationService;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final currentCode = localizationService.currentLocale.languageCode;
    final currentName = LocalizationService.getNativeName(currentCode);
    final flag = LocalizationService.getFlag(currentCode);

    return _SettingsCard(
      onTap: () =>
          _showLanguageDialog(context, localizationService, l10n, colorScheme),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(flag, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.currentLanguage,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LocalizationService localizationService,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final currentLanguageCode = localizationService.currentLocale.languageCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.selectLanguage,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LocalizationService.supportedLanguages.length,
            itemBuilder: (context, index) {
              final entry = LocalizationService.supportedLanguages.entries
                  .toList()[index];
              final languageCode = entry.key;
              final languageData = entry.value;
              final isSelected = currentLanguageCode == languageCode;

              return ListTile(
                onTap: () async {
                  await localizationService.changeLanguage(languageCode);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.languageChanged),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                leading: Text(
                  languageData['flag'] ?? '🌐',
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(languageData['nativeName'] ?? ''),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: colorScheme.primary)
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.isDarkMode,
    required this.onChanged,
    required this.colorScheme,
    required this.l10n,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.themeModeLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  isDarkMode ? l10n.themeDark : l10n.themeLight,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(value: isDarkMode, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
