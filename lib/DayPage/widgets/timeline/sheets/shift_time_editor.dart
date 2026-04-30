import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/time_range_selector.dart';

// Questo widget è specifico per l'editing degli orari dei turni, ma utilizza il TimeRangeSelector universale per la UI.

class ShiftTimeEditor extends StatelessWidget {
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final bool isEditing;
  final bool use24hFormat; // Aggiunta per gestire lo switch 24h/AM-PM
  final Function(TimeOfDay, TimeOfDay) onChanged;

  const ShiftTimeEditor({
    super.key,
    required this.inizio,
    required this.fine,
    required this.isEditing,
    required this.use24hFormat, // Passala dal padre (ShiftDetailSheet)
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TimeRangeSelector(
      inizio: inizio,
      fine: fine,
      isReadOnly: !isEditing,
      use24hFormat: use24hFormat, // Passa la preferenza al widget grafico
      titolo: l10n.turni_orario_titolo,
      labelInizio: l10n.turni_label_inizio,
      labelFine: l10n.turni_label_fine,
      onPickTime: (isStart) async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          // Corretto: usa inizio/fine (i parametri della classe) non _inizio/_fine
          initialTime: isStart ? inizio : fine,
          initialEntryMode: TimePickerEntryMode.input,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Forza il formato nel selettore a comparsa
                alwaysUse24HourFormat: use24hFormat,
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          if (isStart) {
            onChanged(picked, fine);
          } else {
            onChanged(inizio, picked);
          }
        }
      },
    );
  }
}