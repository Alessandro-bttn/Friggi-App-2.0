import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'shift_widget.dart';

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
          return Stack(
            children: _buildOrganizedShifts(availableWidth),
          );
        },
      ),
    );
  }

  List<Widget> _buildOrganizedShifts(double availableWidth) {
    if (turni.isEmpty) return [];

    // 1. Ordiniamo i turni per orario di inizio
    List<TurnoModel> sortedTurni = List.from(turni)
      ..sort((a, b) {
        int startA = a.inizio.hour * 60 + a.inizio.minute;
        int startB = b.inizio.hour * 60 + b.inizio.minute;
        return startA.compareTo(startB);
      });

    // 2. Algoritmo "First Fit" per assegnare le colonne
    // columnsEndTime tiene traccia di quando finisce l'ultimo turno in ogni colonna
    List<int> columnsEndTime = [];
    List<Map<String, dynamic>> positionedShifts = [];

    for (var turno in sortedTurni) {
      int startMin = turno.inizio.hour * 60 + turno.inizio.minute;
      int endMin = turno.fine.hour * 60 + turno.fine.minute;

      int placedColumn = -1;

      // Cerchiamo la prima colonna libera (dove il turno precedente finisce prima che questo inizi)
      for (int i = 0; i < columnsEndTime.length; i++) {
        if (columnsEndTime[i] <= startMin) {
          placedColumn = i;
          columnsEndTime[i] = endMin; // Aggiorniamo la fine della colonna
          break;
        }
      }

      // Se non abbiamo trovato posto, creiamo una nuova colonna
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
    // Se vuoi che siano sempre "molto piccole", puoi forzare un numero minimo di colonne
    // Esempio: math.max(columnsEndTime.length, 3);
    // Per ora usiamo il numero reale di colonne necessarie (così si adattano).
    int totalColumns = columnsEndTime.length;
    double columnWidth = availableWidth / totalColumns;

    // 4. Creiamo i Widget posizionati
    return positionedShifts.map((data) {
      final TurnoModel turno = data['turno'];
      final int colIndex = data['colIndex'];

      // Calcoli Verticali (Top e Height)
      final int startMinutesFromBase = 
          ((turno.inizio.hour - startHour) * 60) + turno.inizio.minute;
      final double topPosition = startMinutesFromBase * pixelsPerMinute;

      final int startInMinutes = (turno.inizio.hour * 60) + turno.inizio.minute;
      final int endInMinutes = (turno.fine.hour * 60) + turno.fine.minute;
      final int durationMinutes = endInMinutes - startInMinutes;
      final double height = durationMinutes * pixelsPerMinute;
      
      final double visualOffset = 9.0;

      // Trova dipendente
      DipendenteModel? dipendenteTrovato;
      try {
        dipendenteTrovato = dipendenti.firstWhere((d) => d.id == turno.idDipendente);
      } catch (e) { /* null */ }

      // Calcoli Orizzontali (Left e Width)
      // Li mettiamo uno accanto all'altro
      final double leftPosition = colIndex * columnWidth;

      return Positioned(
        top: topPosition + visualOffset,
        left: leftPosition + 2, // +2 di margine per staccarli leggermente
        width: columnWidth - 4, // -4 per compensare i margini dx/sx
        height: height,
        child: ShiftWidget(turno: turno, dipendente: dipendenteTrovato),
      );
    }).toList();
  }
}