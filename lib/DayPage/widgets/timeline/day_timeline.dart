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

  const DayTimeline({
    super.key,
    required this.currentDate,
    required this.startTime,
    required this.endTime,
    required this.turni,
    required this.dipendenti,
  });

  @override
  Widget build(BuildContext context) {
    // 1. CALCOLI TEMPORALI
    final int startHour = startTime.hour;
    final int endHour = endTime.hour;

    // IMPORTANTE: Aggiungiamo 15 min di buffer.
    final int extraBuffer = 15;
    final int totalDayMinutes =
        ((endHour - startHour) * 60) + endTime.minute + extraBuffer;

    // 2. CONFIGURAZIONE LAYOUT
    const double hourHeight = 80.0;
    final double pixelsPerMinute = hourHeight / 60;
    final double contentHeight = totalDayMinutes * pixelsPerMinute;

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
                  // LIVELLO 1: Griglia
                  TimelineBackground(
                    startHour: startHour,
                    // Passiamo endHour + 1 se ci sono minuti, per garantire che il ciclo generi l'ultima mezz'ora
                    endHour: endTime.minute > 0 ? endHour + 1 : endHour,
                    endMinute: endTime.minute,
                    rowCount: rowCount,
                    hourHeight: hourHeight,
                  ),

                  // LIVELLO 2: Turni
                  TimelineShiftsStack(
                    turni: turni,
                    dipendenti: dipendenti,
                    startHour: startHour,
                    pixelsPerMinute: pixelsPerMinute,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
