import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';

class ShiftActions {
  static void handleShiftTap(BuildContext context, TurnoModel turno, DipendenteModel? dipendente) {
    // Qui puoi decidere cosa fare. Esempio:
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Turno di: ${dipendente?.nome ?? 'Sconosciuto'}"),
            Text("Orario: ${turno.inizio.format(context)} - ${turno.fine.format(context)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logica per eliminare o modificare
                Navigator.pop(context);
              }, 
              child: const Text("Modifica Turno")
            ),
          ],
        ),
      ),
    );
  }
}