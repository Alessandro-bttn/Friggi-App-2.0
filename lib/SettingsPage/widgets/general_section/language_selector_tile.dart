import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class LanguageSelectorTile extends StatelessWidget {
  final String selectedCode;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelectorTile({
    super.key,
    required this.selectedCode,
    required this.onLanguageChanged,
  });

  String _getLanguageLabel(String code, AppLocalizations l10n) {
    switch (code) {
      case 'it': return l10n.settings_lingua_it;
      case 'es': return l10n.settings_lingua_es;
      default: return l10n.settings_lingua_en;
    }
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settings_lingua_dialog),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.settings_lingua_it), onTap: () => _select('it', context)),
            ListTile(title: Text(l10n.settings_lingua_en), onTap: () => _select('en', context)),
            ListTile(title: Text(l10n.settings_lingua_es), onTap: () => _select('es', context)),
          ],
        ),
      ),
    );
  }

  void _select(String code, BuildContext context) {
    onLanguageChanged(code);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.settings_lingua),
      subtitle: Text(_getLanguageLabel(selectedCode, l10n)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () => _showLanguageDialog(context, l10n),
    );
  }
}