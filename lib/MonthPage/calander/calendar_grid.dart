import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart'; 
import 'day_cell.dart'; 

class CalendarGrid extends StatelessWidget {
  final DateTime meseCorrente;

  const CalendarGrid({
    super.key, 
    required this.meseCorrente
  });

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    // 1. CREA LA LISTA DEI GIORNI TRADOTTA
    final List<String> giorniSettimana = [
      testo.calendar_mon,
      testo.calendar_tue,
      testo.calendar_wed,
      testo.calendar_thu,
      testo.calendar_fri,
      testo.calendar_sat,
      testo.calendar_sun,
    ];

    // Calcoli logici del calendario
    final int year = meseCorrente.year;
    final int month = meseCorrente.month;
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final int firstDayWeekday = DateTime(year, month, 1).weekday;
    final int startingOffset = firstDayWeekday - 1;
    final int totalCells = startingOffset + daysInMonth;

    return SafeArea(
      top: false, 
      bottom: true, 
      child: Column(
        children: [
          // HEADER: Giorni della settimana
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: giorniSettimana
                  .map((giorno) => Text(
                        giorno,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), 
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // GRIGLIA
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight;
                
                final int numeroRighe = (totalCells / 7).ceil();
                const int numeroColonne = 7;
                const double spacing = 2.0;

                final heightNetta = availableHeight - ((numeroRighe - 1) * spacing);
                final cellHeight = heightNetta / numeroRighe;

                final widthNetta = constraints.maxWidth - ((numeroColonne - 1) * spacing);
                final cellWidth = widthNetta / numeroColonne;

                final double dynamicAspectRatio = cellWidth / cellHeight;

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 2), 
                  physics: const NeverScrollableScrollPhysics(), 
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numeroColonne,
                    childAspectRatio: dynamicAspectRatio,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: totalCells, 
                  itemBuilder: (context, index) {
                    if (index < startingOffset) {
                      return const SizedBox(); 
                    }
                    final int giorno = index - startingOffset + 1;

                    return DayCell(
                      giorno: giorno,
                      onTap: () {
                        // Per ora stampiamo solo il messaggio
                        print("Hai cliccato il giorno $giorno / $month / $year");
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}