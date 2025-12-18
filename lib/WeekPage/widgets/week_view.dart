import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekView extends StatelessWidget {
  final DateTime currentStartOfWeek;
  final Function(DateTime) onDaySelected;

  // Parametri visivi (Turni e Orari)
  final int divisions;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const WeekView({
    super.key,
    required this.currentStartOfWeek,
    required this.onDaySelected,
    required this.divisions,
    required this.startTime,
    required this.endTime,
  });

  // Helper per formattare l'orario
  String _formatTime(BuildContext context, TimeOfDay time) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
  }

  @override
  Widget build(BuildContext context) {
    // Usiamo una Colonna con 2 righe (Expanded) per dividere lo schermo a metà
    return Column(
      children: [
        // --- RIGA 1 (Giorni 0, 1, 2, 3 - Lun, Mar, Mer, Gio) ---
        Expanded(
          child: Row(
            children: List.generate(4, (index) {
              return _buildDayCard(context, index);
            }),
          ),
        ),

        // --- RIGA 2 (Giorni 4, 5, 6 + LUNEDI SUCCESSIVO) ---
        Expanded(
          child: Row(
            children: [
              // Generiamo Ven, Sab, Dom (indice 4, 5, 6)
              ...List.generate(3, (index) {
                return _buildDayCard(context, index + 4); // Offset di 4
              }),
              
              // --- 8° SPAZIO: LUNEDÌ SUCCESSIVO (Indice 7) ---
              // Passando 7, calcoliamo currentStartOfWeek + 7 giorni = Prossimo Lunedì
              _buildDayCard(context, 7),
            ],
          ),
        ),
      ],
    );
  }

  // Costruttore della Card del Giorno
  Widget _buildDayCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;
    final int totalSections = divisions + 1;

    // Se l'indice è 7, significa che è il Lunedì della prossima settimana
    final bool isNextWeek = index == 7;

    // Calcoliamo la data di questo specifico giorno
    final DateTime dayDate = currentStartOfWeek.add(Duration(days: index));
    final String dayName = DateFormat('EEE d', 'it').format(dayDate).toUpperCase();

    return Expanded(
      child: Opacity(
        // Riduciamo l'opacità se è il giorno della settimana prossima per distinguerlo
        opacity: isNextWeek ? 0.5 : 1.0, 
        child: Container(
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            // Se è la settimana prossima, usiamo un colore di sfondo leggermente diverso/trasparente
            color: isNextWeek ? theme.cardColor.withValues(alpha: 0.6) : theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              // Bordo tratteggiato o colore diverso per next week? Qui usiamo solo alpha ridotto
              color: borderColor.withValues(alpha: isNextWeek ? 0.3 : 0.6)
            ),
            boxShadow: [
              if (!isNextWeek) // Niente ombra per il giorno "ghost" della settimana prossima
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                )
            ],
          ),
          child: InkWell(
            onTap: () => onDaySelected(dayDate),
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // Intestazione
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome Giorno
                      Text(
                        dayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Orari
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${_formatTime(context, startTime)} - ${_formatTime(context, endTime)}",
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Barre Turni
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
                    child: Column(
                      children: List.generate(totalSections, (i) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 1.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: borderColor.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}