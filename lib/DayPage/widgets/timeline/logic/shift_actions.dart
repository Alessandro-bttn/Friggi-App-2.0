import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import 'shift_detail_sheet.dart';

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