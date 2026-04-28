import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../../service/preferences_service.dart'; // Importa le preferenze
import 'components/shift_sheet_header.dart';
import 'components/shift_time_editor.dart';
import 'components/shift_sheet_actions.dart';

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
  bool _hasChanges = false;
  late bool _use24hFormat;

  @override
  void initState() {
    super.initState();
    _inizio = widget.turno.inizio;
    _fine = widget.turno.fine;
    // Recupera il formato orario centralizzato
    _use24hFormat = PreferencesService().use24hFormat;
  }

  void _onTimeChanged(TimeOfDay newInizio, TimeOfDay newFine) {
    setState(() {
      _inizio = newInizio;
      _fine = newFine;
      // Logica migliorata per il confronto
      _hasChanges = _toMinutes(_inizio) != _toMinutes(widget.turno.inizio) || 
                    _toMinutes(_fine) != _toMinutes(widget.turno.fine);
    });
  }

  int _toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // USIAMO UN CONTAINER PER DARE SOLIDITÀ AL PANNELLO
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface, // Sfondo solido (copre la timeline)
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false, // La parte alta è gestita dalla maniglia
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Maniglia di trascinamento
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Header con foto e nome dipendente
              ShiftSheetHeader(
                dipendente: widget.dipendente, 
                isEditing: _isEditing
              ),
              
              const Divider(height: 32),

              // Editor orari (TimeRangeSelector)
              ShiftTimeEditor(
                inizio: _inizio,
                fine: _fine,
                isEditing: _isEditing,
                use24hFormat: _use24hFormat,
                onChanged: _onTimeChanged,
              ),

              const SizedBox(height: 32),

              // Azioni (Salva, Modifica, Elimina)
              ShiftSheetActions(
                turno: widget.turno,
                inizio: _inizio,
                fine: _fine,
                isEditing: _isEditing,
                hasChanges: _hasChanges,
                onEditToggle: (val) => setState(() => _isEditing = val),
                onReset: () => setState(() {
                  _inizio = widget.turno.inizio;
                  _fine = widget.turno.fine;
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