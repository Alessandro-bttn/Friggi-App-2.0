import 'package:flutter/material.dart';
import 'add_turno_dialog/add_turno_dialog.dart'; 
import '../../DataBase/Turni/TurnoModel.dart';

class DayPageFab extends StatelessWidget {
  final DateTime date;
  final Function(TurnoModel) onTurnoAdded; // Aspetta un TurnoModel

  const DayPageFab({
    super.key, 
    required this.date, 
    required this.onTurnoAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Il dialogo dovrebbe restituire il TurnoModel creato
        final TurnoModel? nuovoTurno = await showDialog<TurnoModel>(
          context: context,
          builder: (context) => AddTurnoDialog(date: date),
        );

        // Se il turno non è nullo (l'utente ha salvato), lo passiamo alla callback
        if (nuovoTurno != null) {
          onTurnoAdded(nuovoTurno);
        }
      },
      child: const Icon(Icons.add),
    );
  }
}