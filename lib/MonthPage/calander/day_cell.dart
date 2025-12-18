import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final int giorno;
  final VoidCallback onTap;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int divisions;

  const DayCell({
    super.key,
    required this.giorno,
    required this.onTap,
    required this.startTime,
    required this.endTime,
    required this.divisions,
  });

  String _formatTime(BuildContext context, TimeOfDay time) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;
    final int totalSections = divisions + 1;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: theme.cardColor,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // 1. INTESTAZIONE COMPATTA (Numero + Orari)
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 4.0, 4.0, 2.0), // Padding inferiore ridotto
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Numero Giorno
                      Text(
                        "$giorno",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Orari (In alto a destra)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTime(context, startTime),
                                style: TextStyle(
                                  fontSize: 9, 
                                  color: theme.colorScheme.secondary,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                _formatTime(context, endTime),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: theme.colorScheme.secondary,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. CORPO CENTRALE (Barre Turni)
                // Usiamo Expanded senza flex specifico o con un flex alto per occupare TUTTO lo spazio rimanente
                Expanded(
                  child: Padding(
                    // MODIFICA QUI: 
                    // horizontal: 3.0 (più larghe)
                    // bottom: 3.0 (toccano quasi il fondo, lasciando un piccolo margine estetico)
                    padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
                    child: Column(
                      children: List.generate(totalSections, (index) {
                        return Expanded(
                          child: Container(
                            // Margine verticale minimo tra le barre
                            margin: const EdgeInsets.symmetric(vertical: 0.5),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(3), // Radius leggermente aumentato
                              border: Border.all(
                                color: borderColor.withValues(alpha: 0.5),
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