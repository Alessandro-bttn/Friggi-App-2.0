import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';

import 'timeline_background.dart';
import 'timeline_shifts_stack.dart';

class DayTimeline extends StatelessWidget {
  final DateTime currentDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<TurnoModel> turni;
  final List<DipendenteModel> dipendenti;
  final Function(TurnoModel, DipendenteModel?) onTurnoTap; // Callback per il dettaglio

  const DayTimeline({
    super.key,
    required this.currentDate,
    required this.startTime,
    required this.endTime,
    required this.turni,
    required this.dipendenti,
    required this.onTurnoTap, 
  });

  @override
  Widget build(BuildContext context) {
    // 1. CALCOLI TEMPORALI
    final int startHour = startTime.hour;
    final int endHour = endTime.hour;

    // Buffer per non far finire l'ultimo turno attaccato al bordo inferiore
    const int extraBuffer = 15;
    
    // Calcolo totale minuti visualizzati
    final int totalDayMinutes =
        ((endHour - startHour) * 60) + endTime.minute + extraBuffer;

    // 2. CONFIGURAZIONE LAYOUT
    const double hourHeight = 80.0;
    final double pixelsPerMinute = hourHeight / 60;
    final double contentHeight = totalDayMinutes * pixelsPerMinute;

    // Calcolo righe: una riga ogni ora (o mezz'ora, dipende dal tuo Background)
    final int rowCount = ((totalDayMinutes - extraBuffer) / 60).ceil() + 1;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: contentHeight,
              child: Stack(
                children: [
                  // LIVELLO 1: Griglia oraria
                  TimelineBackground(
                    startHour: startHour,
                    endHour: endTime.minute > 0 ? endHour + 1 : endHour,
                    endMinute: endTime.minute,
                    rowCount: rowCount,
                    hourHeight: hourHeight,
                  ),

                  // LIVELLO 2: Turni (Interattivi)
                  TimelineShiftsStack(
                    turni: turni,
                    dipendenti: dipendenti,
                    startHour: startHour,
                    pixelsPerMinute: pixelsPerMinute,
                    // INDISPENSABILE: Passiamo la callback al figlio!
                    onTurnoTap: onTurnoTap, 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}