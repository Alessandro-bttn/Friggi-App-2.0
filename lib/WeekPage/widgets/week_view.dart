import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'week_day_card.dart'; 

class WeekView extends StatelessWidget {
  final DateTime currentStartOfWeek;
  final Function(DateTime) onDaySelected;
  final int divisions;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  
  final List<TurnoModel> allShifts;
  final List<DipendenteModel> dipendenti;

  const WeekView({
    super.key,
    required this.currentStartOfWeek,
    required this.onDaySelected,
    required this.divisions,
    required this.startTime,
    required this.endTime,
    required this.allShifts,
    required this.dipendenti,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: List.generate(4, (index) => _buildDayWrapper(context, index)),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ...List.generate(3, (index) => _buildDayWrapper(context, index + 4)),
              _buildDayWrapper(context, 7),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayWrapper(BuildContext context, int index) {
    final DateTime dayDate = currentStartOfWeek.add(Duration(days: index));
    
    // FILTRAGGIO TURNI
    final shiftsForDay = allShifts.where((t) {
      // CORREZIONE: Uso 'data' invece di 'dataTurno'. 
      // Controlla nel tuo TurnoModel come si chiama il campo DateTime!
      return t.data.year == dayDate.year &&
             t.data.month == dayDate.month &&
             t.data.day == dayDate.day;
    }).toList();

    return WeekDayCard(
      dayDate: dayDate,
      isNextWeek: index == 7,
      divisions: divisions,
      startTime: startTime,
      endTime: endTime,
      shiftsForThisDay: shiftsForDay,
      dipendenti: dipendenti,
      onTap: () => onDaySelected(dayDate),
    );
  }
}