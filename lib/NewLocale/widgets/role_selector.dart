// File: lib/widgets/role_selector.dart
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
      'Responsabile': testo.responsabile, 
      'Dipendente': testo.dipendente,
    };

    return DropdownButtonFormField<String>(
      key: ValueKey(selectedValue), 
      initialValue: selectedValue,

      decoration: InputDecoration(
        labelText: testo.responsabileDipendente,
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
      validator: (value) => value == null ? testo.erroreCampi : null,
    );
  }
}