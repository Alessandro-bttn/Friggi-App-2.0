import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'settings_components.dart';

class AppearanceSection extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AppearanceSection({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settings_sez_aspetto),
        SettingsCard(children: [
          SwitchListTile(
            title: Text(l10n.settings_temaScuro),
            subtitle: Text(l10n.settings_temaScuro_sub),
            secondary: const Icon(Icons.dark_mode_outlined),
            // activeColor RIMOSSO: Usa il colore del tema (ColorScheme.primary o secondary)
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ]),
      ],
    );
  }
}