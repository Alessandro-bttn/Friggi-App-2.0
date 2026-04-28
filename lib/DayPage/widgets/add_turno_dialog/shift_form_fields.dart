import 'package:flutter/material.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/time_range_selector.dart'; 

/// Widget per il dropdown di selezione dipendente
class EmployeeDropdown extends StatelessWidget {
  final List<DipendenteModel> dipendenti;
  final DipendenteModel? selectedDipendente;
  final ValueChanged<DipendenteModel?> onChanged;

  const EmployeeDropdown({
    super.key,
    required this.dipendenti,
    required this.selectedDipendente,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DropdownButtonFormField<DipendenteModel>(
      decoration: InputDecoration(
        labelText: l10n.turni_label_dipendente,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      isExpanded: true,
      value: selectedDipendente,
      items: dipendenti.map((dip) {
        return DropdownMenuItem(
          value: dip,
          child: Row(
            children: [
              CircleAvatar(radius: 8, backgroundColor: Color(dip.colore)),
              const SizedBox(width: 12),
              Text("${dip.nome} ${dip.cognome ?? ''}"),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text(dipendenti.isEmpty ? l10n.dipendenti_nessuno : l10n.dipendenti_seleziona),
    );
  }
}

/// Questo file non riscrive più il selettore, ma lo esporta o lo usa.
/// Se nel tuo AddTurnoDialog stavi chiamando un widget locale, ora chiama questo:
class ShiftFormFields extends StatelessWidget {
  final List<DipendenteModel> dipendenti;
  final DipendenteModel? selectedDipendente;
  final ValueChanged<DipendenteModel?> onEmployeeChanged;
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final Function(bool isStart) onPickTime;

  const ShiftFormFields({
    super.key,
    required this.dipendenti,
    required this.selectedDipendente,
    required this.onEmployeeChanged,
    required this.inizio,
    required this.fine,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        EmployeeDropdown(
          dipendenti: dipendenti,
          selectedDipendente: selectedDipendente,
          onChanged: onEmployeeChanged,
        ),
        const SizedBox(height: 20),
        // USIAMO IL COMPONENTE RIUTILIZZABILE
        TimeRangeSelector(
          inizio: inizio,
          fine: fine,
          onPickTime: onPickTime,
          // Passiamo i titoli tradotti così il widget rimane "puro"
          titolo: l10n.turni_orario_titolo,
          labelInizio: l10n.turni_label_inizio,
          labelFine: l10n.turni_label_fine,
          isReadOnly: false, 
        ),
      ],
    );
  }
}