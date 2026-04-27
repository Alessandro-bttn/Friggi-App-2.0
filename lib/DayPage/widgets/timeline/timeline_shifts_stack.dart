import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'shift_widget.dart';
import 'logic/shift_actions.dart';

// Widget che organizza e mostra i turni nella timeline

class TimelineShiftsStack extends StatelessWidget {
  final List<TurnoModel> turni;
  final List<DipendenteModel> dipendenti;
  final int startHour;
  final double pixelsPerMinute;

  const TimelineShiftsStack({
    super.key,
    required this.turni,
    required this.dipendenti,
    required this.startHour,
    required this.pixelsPerMinute,
  });

  @override
  Widget build(BuildContext context) {
    // Usiamo LayoutBuilder per sapere quanto spazio orizzontale abbiamo
    // (escludendo i 60px della colonna orari)
    return Positioned(
      top: 0,
      bottom: 0,
      left: 61,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;

          // Generiamo i widget calcolati con la logica delle colonne
          // Nel metodo build
          return Stack(
            children: _buildOrganizedShifts(
                context, availableWidth), // Aggiunto context
          );
        },
      ),
    );
  }

  List<Widget> _buildOrganizedShifts(
      BuildContext context, double availableWidth) {
    // Aggiunto context qui
    if (turni.isEmpty) return [];

    // 1. Ordiniamo i turni per orario di inizio
    List<TurnoModel> sortedTurni = List.from(turni)
      ..sort((a, b) {
        int startA = a.inizio.hour * 60 + a.inizio.minute;
        int startB = b.inizio.hour * 60 + b.inizio.minute;
        return startA.compareTo(startB);
      });

    // 2. Algoritmo "First Fit" per assegnare le colonne
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

    // 3. Calcoliamo la larghezza di ogni colonna
    int totalColumns = columnsEndTime.length;
    double columnWidth = availableWidth / totalColumns;

    // 4. Creiamo i Widget posizionati
    return positionedShifts.map((data) {
      final TurnoModel turno = data['turno']; // <--- Nome corretto: turno
      final int colIndex = data['colIndex'];

      // Calcoli Verticali
      final int startMinutesFromBase =
          ((turno.inizio.hour - startHour) * 60) + turno.inizio.minute;
      final double topPosition = startMinutesFromBase * pixelsPerMinute;

      final int startInMinutes = (turno.inizio.hour * 60) + turno.inizio.minute;
      final int endInMinutes = (turno.fine.hour * 60) + turno.fine.minute;
      final int durationMinutes = endInMinutes - startInMinutes;
      final double height = durationMinutes * pixelsPerMinute;

      final double visualOffset = 9.0;

      // Trova dipendente
      DipendenteModel?
          dipendenteTrovato; // <--- Nome corretto: dipendenteTrovato
      try {
        dipendenteTrovato =
            dipendenti.firstWhere((d) => d.id == turno.idDipendente);
      } catch (e) {/* null */}

      // Calcoli Orizzontali
      final double leftPosition = colIndex * columnWidth;

      return Positioned(
        top: topPosition + visualOffset,
        left: leftPosition + 2,
        width: columnWidth - 4,
        height: height,
        child: ShiftWidget(
          turno: turno, // Passato correttamente
          dipendente: dipendenteTrovato, // Passato correttamente
          onTap: () =>
              ShiftActions.handleShiftTap(context, turno, dipendenteTrovato),
        ),
      );
    }).toList();
  }
}
