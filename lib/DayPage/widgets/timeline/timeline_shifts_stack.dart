import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'shift_widget.dart';

class TimelineShiftsStack extends StatelessWidget {
  final List<TurnoModel> turni;
  final List<DipendenteModel> dipendenti;
  final int startHour;
  final double pixelsPerMinute;
  
  // MODIFICA: Ora la funzione accetta sia il turno che il dipendente (opzionale)
  final Function(TurnoModel, DipendenteModel?) onTurnoTap; 

  const TimelineShiftsStack({
    super.key,
    required this.turni,
    required this.dipendenti,
    required this.startHour,
    required this.pixelsPerMinute,
    required this.onTurnoTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 61,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          return Stack(
            children: _buildOrganizedShifts(context, availableWidth),
          );
        },
      ),
    );
  }

  List<Widget> _buildOrganizedShifts(BuildContext context, double availableWidth) {
    if (turni.isEmpty) return [];

    List<TurnoModel> sortedTurni = List.from(turni)
      ..sort((a, b) {
        int startA = a.inizio.hour * 60 + a.inizio.minute;
        int startB = b.inizio.hour * 60 + b.inizio.minute;
        return startA.compareTo(startB);
      });

    List<int> columnsEndTime = [];
    List<Map<String, dynamic>> positionedShifts = [];

    for (var turno in sortedTurni) {
      int startMin = turno.inizio.hour * 60 + turno.inizio.minute;
      int endMin = turno.fine.hour * 60 + turno.fine.minute;
      int placedColumn = -1;

      for (int i = 0; i < columnsEndTime.length; i++) {
        if (columnsEndTime[i] <= startMin) {
          placedColumn = i;
          columnsEndTime[i] = endMin;
          break;
        }
      }

      if (placedColumn == -1) {
        placedColumn = columnsEndTime.length;
        columnsEndTime.add(endMin);
      }

      positionedShifts.add({
        'turno': turno,
        'colIndex': placedColumn,
      });
    }

    int totalColumns = columnsEndTime.isEmpty ? 1 : columnsEndTime.length;
    double columnWidth = availableWidth / totalColumns;

    return positionedShifts.map((data) {
      final TurnoModel turno = data['turno'];
      final int colIndex = data['colIndex'];

      final int startMinutesFromBase =
          ((turno.inizio.hour - startHour) * 60) + turno.inizio.minute;
      final double topPosition = startMinutesFromBase * pixelsPerMinute;

      final int startInMinutes = (turno.inizio.hour * 60) + turno.inizio.minute;
      final int endInMinutes = (turno.fine.hour * 60) + turno.fine.minute;
      final int durationMinutes = endInMinutes - startInMinutes;
      final double height = durationMinutes * pixelsPerMinute;

      DipendenteModel? dipendenteTrovato;
      try {
        dipendenteTrovato =
            dipendenti.firstWhere((d) => d.id == turno.idDipendente);
      } catch (e) {
        dipendenteTrovato = null;
      }

      final double leftPosition = colIndex * columnWidth;

      return Positioned(
        top: topPosition,
        left: leftPosition + 2,
        width: columnWidth - 4,
        height: height,
        child: ShiftWidget(
          turno: turno,
          dipendente: dipendenteTrovato,
          // MODIFICA: Passiamo entrambi gli oggetti alla callback
          onTap: () => onTurnoTap(turno, dipendenteTrovato), 
        ),
      );
    }).toList();
  }
}