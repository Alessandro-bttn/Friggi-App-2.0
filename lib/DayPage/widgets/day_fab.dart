import 'package:flutter/material.dart';
import 'add_turno_dialog.dart';

class DayPageFab extends StatelessWidget {
  final DateTime date;
  // Aggiungiamo questa callback opzionale
  final VoidCallback? onTurnoAdded; 

  const DayPageFab({
    super.key, 
    required this.date,
    this.onTurnoAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) => AddTurnoDialog(
            date: date,
            onSaved: () {
              // Quando il dialog salva, chiamiamo la callback per aggiornare la DayPage
              if (onTurnoAdded != null) {
                onTurnoAdded!();
              }
            },
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}