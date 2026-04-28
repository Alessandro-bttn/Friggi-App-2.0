import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
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

  @override
  void initState() {
    super.initState();
    _inizio = widget.turno.inizio;
    _fine = widget.turno.fine;
  } 

  void _onTimeChanged(TimeOfDay newInizio, TimeOfDay newFine) {
    setState(() {
      _inizio = newInizio;
      _fine = newFine;
      _hasChanges = _inizio != widget.turno.inizio || _fine != widget.turno.fine;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32, height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ShiftSheetHeader(dipendente: widget.dipendente, isEditing: _isEditing),
          const Divider(height: 32),
          ShiftTimeEditor(
            inizio: _inizio,
            fine: _fine,
            isEditing: _isEditing,
            // questo parametro può essere dinamico se vuoi supportare sia 12h che 24h, lo devo gestire diversamente in base alla localizzazione e in modo centralizzato, ma per ora lo lascio sempre true  
            use24hFormat: true,    onChanged: _onTimeChanged,
          ),
          const SizedBox(height: 32),
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
    );
  }
}