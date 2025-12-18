import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
// IMPORTA IL SERVIZIO PREFERENZE
import '../../service/preferences_service.dart';
import 'day_cell.dart';
import '../../DayPage/DayPage.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime meseCorrente;

  const CalendarGrid({super.key, required this.meseCorrente});

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;
    
    // 1. RECUPERIAMO I SETTAGGI DALLE PREFERENZE
    final prefs = PreferencesService();
    final int divisioni = prefs.divisioneTurni;
    final TimeOfDay start = prefs.orarioInizio;
    final TimeOfDay end = prefs.orarioFine;

    // 2. CREA LA LISTA DEI GIORNI TRADOTTA
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
    // firstDayWeekday: 1=Lun, 7=Dom. Se vogliamo lunedì come primo giorno: offset = weekday - 1
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
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
                // Evitiamo divisione per zero se non ci sono righe (caso limite)
                final cellHeight = numeroRighe > 0 ? heightNetta / numeroRighe : 0.0;

                final widthNetta = constraints.maxWidth - ((numeroColonne - 1) * spacing);
                final cellWidth = widthNetta / numeroColonne;

                // Calcolo aspect ratio dinamico per riempire lo spazio
                final double dynamicAspectRatio = (cellHeight > 0) ? cellWidth / cellHeight : 1.0;

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
                    // CELLE VUOTE INIZIALI
                    if (index < startingOffset) {
                      return const SizedBox();
                    }

                    // CALCOLO GIORNO REALE
                    final int giorno = index - startingOffset + 1;

                    // CREIAMO LA DATA DEL GIORNO SELEZIONATO
                    final DateTime dataSelezionata = DateTime(year, month, giorno);

                    // 3. RITORNIAMO LA DAYCELL CONFIGURATA
                    return DayCell(
                      giorno: giorno, // Passiamo il giorno corretto, non l'index
                      startTime: start, // Orario dalle preferenze
                      endTime: end,     // Orario dalle preferenze
                      divisions: divisioni, // Settaggio dalle preferenze
                      onTap: () {
                        // 4. NAVIGAZIONE ALLA PAGINA DI DETTAGLIO
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DayPage(
                              selectedDate: dataSelezionata, // Assicurati che DayPage accetti questo parametro
                            ),
                          ),
                        );
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