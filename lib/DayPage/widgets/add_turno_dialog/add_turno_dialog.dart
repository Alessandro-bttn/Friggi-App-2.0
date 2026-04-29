import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/time_range_selector.dart';

import 'employee_selector_field.dart';
import 'logic/turni_validator.dart';

import '../../../../notifications/notification_service.dart';

import '../../../main.dart'; // Per accedere alla variabile globale turniController

class AddTurnoDialog extends StatefulWidget {
  final DateTime date;
  const AddTurnoDialog({super.key, required this.date}); // rimosso onSaved

  @override
  State<AddTurnoDialog> createState() => _AddTurnoDialogState();
}

class _AddTurnoDialogState extends State<AddTurnoDialog> {
  DipendenteModel? _selectedDipendente;
  TimeOfDay _inizio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _fine = const TimeOfDay(hour: 17, minute: 0);
  late AppLocalizations l10n;

  final bool _use24h =
      true; // Per ora forziamo il formato 24h, ma dovrebbe essere dinamico in base alla localizzazione o preferenza utente

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  Future<void> _handlePickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _inizio : _fine,
      initialEntryMode: TimePickerEntryMode.input,
      helpText:
          isStart ? l10n.settings_orario_inizio : l10n.settings_orario_fine,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          // Forza il formato basandosi sulla preferenza dell'utente
          alwaysUse24HourFormat: _use24h,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isStart ? _inizio = picked : _fine = picked);
    }
  }

  void _submitForm() async {
    if (_selectedDipendente?.id == null) return;

    final bool valido = await TurniValidator.isTurnoValido(
      context: context,
      idDipendente: _selectedDipendente!.id!,
      data: widget.date,
      inizio: _inizio,
      fine: _fine,
    );

    if (!valido) return;

    final nuovoTurno = TurnoModel(
      idDipendente: _selectedDipendente!.id!,
      data: widget.date,
      inizio: _inizio,
      fine: _fine,
    );

    await turniController.aggiungiTurno(nuovoTurno);

    if (mounted) {
      NotificationService().showSuccess(l10n.turno_salvato_con_successo);
      Navigator.pop(context); // Chiude il dialogo
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _DialogHeader(date: widget.date),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmployeeSelectorField(
                selectedDipendente: _selectedDipendente,
                onSelected: (val) => setState(() => _selectedDipendente = val),
              ),
              const SizedBox(height: 20),
              // Passaggio corretto dei parametri al widget universale
              TimeRangeSelector(
                inizio: _inizio,
                fine: _fine,
                onPickTime: (isStart) => _handlePickTime(isStart),
                titolo: l10n.turni_orario_titolo,
                labelInizio: l10n.turni_label_inizio,
                labelFine: l10n.turni_label_fine,
                use24hFormat: _use24h, // Coerenza con il picker
                isReadOnly: false,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.btn_annulla.toUpperCase()),
        ),
        ElevatedButton(
          onPressed: (_selectedDipendente != null) ? _submitForm : null,
          style: ElevatedButton.styleFrom(elevation: 0),
          child: Text(l10n.btn_salva_turno.toUpperCase()),
        ),
      ],
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final DateTime date;
  const _DialogHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Icon(Icons.add_alarm, color: Colors.blue),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.turni_nuovo_titolo,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${date.day}/${date.month}/${date.year}",
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}
