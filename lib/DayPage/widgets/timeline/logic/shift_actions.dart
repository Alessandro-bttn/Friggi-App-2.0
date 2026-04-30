import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import 'shift_detail_sheet.dart';

// Questa classe contiene le azioni legate ai turni, come ad esempio l'apertura del dettaglio del turno al tap. 
//In questo modo, se in futuro volessimo aggiungere altre azioni (es. swipe per eliminare), possiamo centralizzarle qui.

class ShiftActions {
  static void handleShiftTap(
      BuildContext context, TurnoModel turno, DipendenteModel? dipendente) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => ShiftDetailSheet(turno: turno, dipendente: dipendente),
    );
  }
}