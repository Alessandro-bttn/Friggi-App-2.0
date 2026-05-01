import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../../service/preferences_service.dart';
import 'shift_sheet_header.dart';
import 'shift_time_editor.dart';
import 'shift_sheet_actions.dart';

// Questo widget rappresenta il bottom sheet che mostra i dettagli di un turno, con possibilità di modifica e salvataggio.

class ShiftDetailSheet extends StatefulWidget {
  final TurnoModel turno;
  final DipendenteModel? dipendente;

  const ShiftDetailSheet({super.key, required this.turno, this.dipendente});

  @override
  State<ShiftDetailSheet> createState() => _ShiftDetailSheetState();
}

class _ShiftDetailSheetState extends State<ShiftDetailSheet> {
  bool _isEditing = false;
  late TimeOfDay _inizio;
  late TimeOfDay _fine;
  DipendenteModel? _currentDipendente;
  bool _hasChanges = false;
  late bool _use24hFormat;


  @override
  void initState() {
    super.initState();
    _inizio = widget.turno.inizio;
    _fine = widget.turno.fine;
    _currentDipendente = widget.dipendente;
    _use24hFormat = PreferencesService().use24hFormat;
  }

  void _checkChanges() {
    setState(() {
      final bool timeChanged = _toMinutes(_inizio) != _toMinutes(widget.turno.inizio) ||
                               _toMinutes(_fine) != _toMinutes(widget.turno.fine);
      final bool dipendenteChanged = _currentDipendente?.id != widget.dipendente?.id;
      _hasChanges = timeChanged || dipendenteChanged;
    });
  }

  void _onTimeChanged(TimeOfDay newInizio, TimeOfDay newFine) {
    _inizio = newInizio;
    _fine = newFine;
    _checkChanges();
  }

  int _toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 32, height: 4, decoration: BoxDecoration(color: colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),

              // Header aggiornato con pattern e setState
              ShiftSheetHeader(
                dipendente: _currentDipendente,
                isEditing: _isEditing,
                onDipendenteChanged: (nuovoDipendente) {
                  setState(() { // <--- FONDAMENTALE per aggiornare l'UI
                    _currentDipendente = nuovoDipendente;
                    _checkChanges();
                  });
                },
              ),

              const Divider(height: 32),
              ShiftTimeEditor(
                inizio: _inizio,
                fine: _fine,
                isEditing: _isEditing,
                use24hFormat: _use24hFormat,
                onChanged: _onTimeChanged,
              ),
              const SizedBox(height: 32),
              ShiftSheetActions(
                turno: widget.turno,
                inizio: _inizio,
                fine: _fine,
                currentDipendente: _currentDipendente, 
                isEditing: _isEditing,
                hasChanges: _hasChanges,
                onEditToggle: (val) => setState(() => _isEditing = val),
                onReset: () => setState(() {
                  _inizio = widget.turno.inizio;
                  _fine = widget.turno.fine;
                  _currentDipendente = widget.dipendente;
                  _hasChanges = false;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}