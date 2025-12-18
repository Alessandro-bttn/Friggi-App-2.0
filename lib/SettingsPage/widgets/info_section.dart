import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'settings_components.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settings_sez_info),
        SettingsCard(children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settings_versione),
            trailing: const Text(
              "1.0.0",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          const SettingsDivider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settings_privacy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              // TODO: Inserire link alla privacy policy
              print("Apri privacy policy");
            },
          ),
        ]),
      ],
    );
  }
}