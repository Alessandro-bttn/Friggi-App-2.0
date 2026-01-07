import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart'; 

// Import dei widget della timeline

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