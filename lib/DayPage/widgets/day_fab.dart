import 'package:flutter/material.dart';

class DayPageFab extends StatelessWidget {
  final DateTime date;

  const DayPageFab({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Colore personalizzato se vuoi, altrimenti usa il tema
      // backgroundColor: Theme.of(context).primaryColor, 
      onPressed: () {
        // TODO: Qui aprirai il dialog per aggiungere un nuovo turno
        print("Click su Aggiungi per il giorno: $date");
        
        // Esempio futuro:
        // showDialog(context: context, builder: (_) => AddShiftDialog(date: date));
      },
      child: const Icon(Icons.add),
    );
  }
}