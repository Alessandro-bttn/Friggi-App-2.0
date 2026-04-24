import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Turni/TurniDB.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../l10n/app_localizations.dart';

import 'shift_form_fields.dart';
import 'employee_selector_field.dart'; // Importa il nuovo file

class AddTurnoDialog extends StatefulWidget {
  final DateTime date;
  final VoidCallback onSaved;

  const AddTurnoDialog({
    super.key,
    required this.date,
    required this.onSaved,
  });

  @override
  State<AddTurnoDialog> createState() => _AddTurnoDialogState();
}

class _AddTurnoDialogState extends State<AddTurnoDialog> {
  DipendenteModel? _selectedDipendente;
  TimeOfDay _inizio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _fine = const TimeOfDay(hour: 17, minute: 0);

  Future<void> _handlePickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _inizio : _fine,
      initialEntryMode: TimePickerEntryMode.input,
      helpText: isStart ? "ORARIO INIZIO" : "ORARIO FINE",
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isStart ? _inizio = picked : _fine = picked);
    }
  }

  void _submitForm() async {
    if (_selectedDipendente?.id == null) return;

    final nuovoTurno = TurnoModel(
      idDipendente: _selectedDipendente!.id!,
      data: widget.date,
      inizio: _inizio,
      fine: _fine,
    );

    await TurniDB().insertTurno(nuovoTurno);
    widget.onSaved();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: _DialogHeader(date: widget.date),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Utilizziamo il nuovo widget dedicato
              EmployeeSelectorField(
                selectedDipendente: _selectedDipendente,
                onSelected: (val) => setState(() => _selectedDipendente = val),
              ),
              const SizedBox(height: 20),
              TimeRangeSelector(
                inizio: _inizio,
                fine: _fine,
                onPickTime: (isStart) => _handlePickTime(isStart),
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
            Text(l10n.turni_nuovo_titolo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${date.day}/${date.month}/${date.year}", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}