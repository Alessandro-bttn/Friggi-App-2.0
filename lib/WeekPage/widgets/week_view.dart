import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekView extends StatelessWidget {
  final DateTime currentStartOfWeek;
  
  // 1. DEFINIAMO IL PARAMETRO QUI
  final Function(DateTime) onDaySelected; 

  const WeekView({
    super.key, 
    required this.currentStartOfWeek,
    
    // 2. AGGIUNGIAMO QUESTO AL COSTRUTTORE
    required this.onDaySelected, 
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // Generiamo la lista degli 8 giorni
    List<DateTime> weekDays = List.generate(8, (index) {
      return currentStartOfWeek.add(Duration(days: index));
    });

    return Column(
      children: [
        // --- RIGA 1 ---
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDayCell(context, weekDays[0], today),
              _buildDayCell(context, weekDays[1], today),
              _buildDayCell(context, weekDays[2], today),
              _buildDayCell(context, weekDays[3], today, isLastColumn: true),
            ],
          ),
        ),

        // --- RIGA 2 ---
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDayCell(context, weekDays[4], today, isBottomRow: true),
              _buildDayCell(context, weekDays[5], today, isBottomRow: true),
              _buildDayCell(context, weekDays[6], today, isBottomRow: true),
              _buildDayCell(context, weekDays[7], today, isBottomRow: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date, DateTime today, {bool isLastColumn = false, bool isBottomRow = false}) {
    final theme = Theme.of(context);
    
    final bool isToday = date.year == today.year && 
                         date.month == today.month && 
                         date.day == today.day;

    String dayName = DateFormat.E('it_IT').format(date).toUpperCase();
    if(dayName.endsWith('.')) {
       dayName = dayName.substring(0, dayName.length - 1);
    }

    return Expanded(
      // 3. USIAMO MATERIAL E INKWELL PER IL CLICK
      child: Material(
        color: isToday ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        child: InkWell(
          // 4. AL CLICK CHIAMIAMO LA FUNZIONE PASSATA DAL GENITORE
          onTap: () => onDaySelected(date),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: isLastColumn ? BorderSide.none : BorderSide(color: theme.dividerColor),
                bottom: isBottomRow ? BorderSide.none : BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  dayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isToday ? theme.colorScheme.primary : theme.hintColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                   padding: const EdgeInsets.all(8),
                   decoration: isToday ? BoxDecoration(
                     color: theme.colorScheme.primary,
                     shape: BoxShape.circle,
                   ) : null,
                   child: Text(
                    "${date.day}",
                    style: theme.textTheme.titleMedium?.copyWith(
                       fontWeight: FontWeight.bold,
                       color: isToday ? theme.colorScheme.onPrimary : null,
                    ),
                   ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}