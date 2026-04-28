import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../../widgets/time_range_selector.dart'; // Importa il tuo widget universale

class WorkHoursSelector extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ValueChanged<TimeOfDay> onStartChanged;
  final ValueChanged<TimeOfDay> onEndChanged;
  final bool use24hFormat; // Passiamo la preferenza per coerenza

  const WorkHoursSelector({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.use24hFormat,
  });

  Future<void> _handlePickTime(BuildContext context, bool isStart) async {
    final current = isStart ? startTime : endTime;
    
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24hFormat),
        child: child!,
      ),
    );

    if (picked != null) {
      if (isStart) {
        onStartChanged(picked);
      } else {
        onEndChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titolo della sezione (opzionale, dato che TimeRangeSelector ha già un titolo interno)
          Text(
            l10n.settings_orari_label, 
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // RIUTILIZZO DEL COMPONENTE UNIVERSALE
          TimeRangeSelector(
            inizio: startTime,
            fine: endTime,
            use24hFormat: use24hFormat,
            onPickTime: (isStart) => _handlePickTime(context, isStart),
            // Personalizziamo le label per il contesto "Impostazioni Locale"
            labelInizio: l10n.settings_orario_inizio,
            labelFine: l10n.settings_orario_fine,
            titolo: "",
            isReadOnly: false,
          ),
        ],
      ),
    );
  }
}