import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'components/shift_widget.dart';

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

    // 1. DICHIARAZIONE E ORDINAMENTO (Inizializzato subito!)
    final List<TurnoModel> sortedTurni = List.from(turni)
      ..sort((a, b) {
        int startA = a.inizio.hour * 60 + a.inizio.minute;
        int startB = b.inizio.hour * 60 + b.inizio.minute;
        return startA.compareTo(startB);
      });

    // 2. PRE-CALCOLO COLLISIONI LOCALI
    // Mappa: Colore -> Lista di ID dipendenti che lavorano oggi (ordinata cronologicamente)
    final Map<int, List<int>> localColorConflicts = {};
    
    for (var turno in sortedTurni) {
      final dip = dipendenti.firstWhere(
        (d) => d.id == turno.idDipendente,
        orElse: () => DipendenteModel(idLocale: 0, nome: "?", colore: 0),
      );
      
      if (dip.id != null) {
        if (!localColorConflicts.containsKey(dip.colore)) {
          localColorConflicts[dip.colore] = [];
        }
        // Aggiungi solo se non è già in lista (preserva ordine cronologico)
        if (!localColorConflicts[dip.colore]!.contains(dip.id)) {
          localColorConflicts[dip.colore]!.add(dip.id!);
        }
      }
    }

    // 3. Algoritmo colonne (First Fit)
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

    // 4. Mappatura Widget
    return positionedShifts.map((data) {
      final TurnoModel turno = data['turno'];
      final int colIndex = data['colIndex'];

      final int turnoInizioMinuti = (turno.inizio.hour * 60) + turno.inizio.minute;
      final int grigliaInizioMinuti = startHour * 60;
      final double topPosition = ((turnoInizioMinuti - grigliaInizioMinuti) * pixelsPerMinute) + 8.0;
      
      final int turnoFineMinuti = (turno.fine.hour * 60) + turno.fine.minute;
      int durationMinutes = turnoFineMinuti - turnoInizioMinuti;
      if (durationMinutes < 0) durationMinutes += 24 * 60;
      final double height = durationMinutes * pixelsPerMinute;

      final DipendenteModel dipendenteTrovato = dipendenti.firstWhere(
        (d) => d.id == turno.idDipendente,
        orElse: () => DipendenteModel(idLocale: 0, nome: "N/A", colore: 0xFF9E9E9E),
      );

      // --- CALCOLO PATTERN LOCALE ---
      int pattern = 0;
      final List<int> conflicts = localColorConflicts[dipendenteTrovato.colore] ?? [];
      
      if (conflicts.length > 1) {
        final int index = conflicts.indexOf(dipendenteTrovato.id!);
        // index 0 è il primo (solido), gli altri hanno pattern 1-3
        pattern = (index == 0) ? 0 : ((index - 1) % 3) + 1;
      }

      return Positioned(
        top: topPosition,
        left: (colIndex * columnWidth) + 2,
        width: columnWidth - 4,
        height: height,
        child: ShiftWidget(
          turno: turno,
          dipendente: dipendenteTrovato,
          patternType: pattern, 
          onTap: () => onTurnoTap(turno, dipendenteTrovato),
        ),
      );
    }).toList();
  }
}
