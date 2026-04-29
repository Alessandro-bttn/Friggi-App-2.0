import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'shift_widget.dart';

class TimelineShiftsStack extends StatelessWidget {
  final List<TurnoModel> turni;
  final List<DipendenteModel> dipendenti;
  final int startHour;
  final double pixelsPerMinute;
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

    // 1. Ordinamento
    List<TurnoModel> sortedTurni = List.from(turni)
      ..sort((a, b) {
        int startA = a.inizio.hour * 60 + a.inizio.minute;
        int startB = b.inizio.hour * 60 + b.inizio.minute;
        return startA.compareTo(startB);
      });

    // 2. Algoritmo colonne (First Fit)
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

      positionedShifts.add({'turno': turno, 'colIndex': placedColumn});
    }

    int totalColumns = columnsEndTime.isEmpty ? 1 : columnsEndTime.length;
    double columnWidth = availableWidth / totalColumns;

    // --- COSTANTE DI ALLINEAMENTO ---
    // Deve essere identica al margin top della linea in TimelineBackground
    const double visualOffset = 8.0; 

    // 3. Mappatura dei Widget
    return positionedShifts.map((data) {
      final TurnoModel turno = data['turno'];
      final int colIndex = data['colIndex'];

      // --- CALCOLO POSIZIONE VERTICALE (TOP) ---
      final int turnoInizioMinuti = (turno.inizio.hour * 60) + turno.inizio.minute;
      final int grigliaInizioMinuti = startHour * 60;
      
      // Aggiungiamo visualOffset per "spingere" il turno giù quanto la linea della griglia
      final double topPosition = 
          ((turnoInizioMinuti - grigliaInizioMinuti) * pixelsPerMinute) + visualOffset;

      // --- CALCOLO ALTEZZA (HEIGHT) ---
      final int turnoFineMinuti = (turno.fine.hour * 60) + turno.fine.minute;
      int durationMinutes = turnoFineMinuti - turnoInizioMinuti;
      if (durationMinutes < 0) durationMinutes += 24 * 60;

      final double height = durationMinutes * pixelsPerMinute;

      // Trova dipendente
      DipendenteModel? dipendenteTrovato;
      try {
        dipendenteTrovato = dipendenti.firstWhere((d) => d.id == turno.idDipendente);
      } catch (e) {
        dipendenteTrovato = null;
      }

      return Positioned(
        top: topPosition,
        left: (colIndex * columnWidth) + 2,
        width: columnWidth - 4,
        height: height,
        child: ShiftWidget(
          turno: turno,
          dipendente: dipendenteTrovato,
          onTap: () => onTurnoTap(turno, dipendenteTrovato),
        ),
      );
    }).toList();
  }
}