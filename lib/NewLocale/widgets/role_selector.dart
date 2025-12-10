import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart'; 


class RoleSelector extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const RoleSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    final Map<String, String> opzioni = {
      // CORREZIONE 1: Nuove chiavi per i valori del menu
      'Responsabile': testo.ruolo_responsabile, 
      'Dipendente': testo.ruolo_dipendente,
    };

    return DropdownButtonFormField<String>(
      key: ValueKey(selectedValue), 
      initialValue: selectedValue,

      decoration: InputDecoration(
        labelText: testo.ruolo_label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.person_outline),
      ),
      items: opzioni.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? testo.error_campiMancanti : null,
    );
  }
}