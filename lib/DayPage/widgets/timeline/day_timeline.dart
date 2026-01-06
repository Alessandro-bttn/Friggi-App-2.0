import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart'; // <--- IMPORT MODELLO

import 'timeline_background.dart';
import 'timeline_shifts_stack.dart';

class DayTimeline extends StatelessWidget {
  final DateTime currentDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<TurnoModel> turni;
  final List<DipendenteModel> dipendenti; // <--- 1. NUOVO CAMPO

  const DayTimeline({
    super.key,
    required this.currentDate,
    required this.startTime,
    required this.endTime,
    required this.turni,
    required this.dipendenti, // <--- 2. AGGIUNTO AL COSTRUTTORE
  });

  @override
  Widget build(BuildContext context) {
    // 1. CALCOLI TEMPORALI
    final int startHour = startTime.hour;
    final int endHour = endTime.hour;
    
    final int totalDayMinutes = ((endHour - startHour) * 60) + endTime.minute;
    final int rowCount = (totalDayMinutes / 60).ceil() + 1;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalHeight = constraints.maxHeight;
          final double pixelsPerMinute = totalHeight / totalDayMinutes;
          final double hourHeight = pixelsPerMinute * 60;

          return Stack(
            children: [
              // LIVELLO 1: Griglia
              TimelineBackground(
                startHour: startHour,
                endHour: endHour,
                endMinute: endTime.minute,
                rowCount: rowCount,
                hourHeight: hourHeight,
              ),

              // LIVELLO 2: Turni
              TimelineShiftsStack(
                turni: turni,
                dipendenti: dipendenti, // <--- 3. PASSIAMO LA LISTA GIÙ
                startHour: startHour,
                pixelsPerMinute: pixelsPerMinute,
              ),
            ],
          );
        },
      ),
    );
  }
}