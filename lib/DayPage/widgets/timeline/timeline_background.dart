import 'package:flutter/material.dart';
// Questo widget disegna lo sfondo della timeline, con linee orarie e mezz'ora, e gli orari a sinistra.
class TimelineBackground extends StatelessWidget {
  final int startHour;
  final int endHour;
  final int endMinute;
  final int rowCount;
  final double hourHeight;

  const TimelineBackground({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.endMinute,
    required this.rowCount,
    required this.hourHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Colore ora piena
    final dividerColor = theme.dividerColor.withValues(alpha: 0.5);
    // Colore mezz'ora (più tenue)
    final halfHourColor = theme.dividerColor.withValues(alpha: 0.3);
    final textColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Stack(
      children: [
        // 1. Linea Verticale
        Positioned(
          top: 0,
          bottom: 0,
          left: 60,
          child: Container(
            width: 1,
            color: dividerColor,
          ),
        ),

        // 2. Orari e Linee
        ...List.generate(rowCount, (index) {
          final int currentHour = startHour + index;

          if (currentHour > endHour && endMinute == 0) {
            return const SizedBox();
          }

          final String hourLabel =
              "${currentHour.toString().padLeft(2, '0')}:00";

          return Stack(
            children: [
              // --- LINEA ORA PIENA ---
              Positioned(
                top: index * hourHeight,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          hourLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 1,
                        color: dividerColor,
                      ),
                    ),
                  ],
                ),
              ),

              // --- LINEA MEZZ'ORA (Nuova aggiunta) ---
              // Non disegniamo la mezz'ora dopo l'ultima ora se non necessario
              if (currentHour < endHour ||
                  (currentHour == endHour && endMinute > 30))
                Positioned(
                  // Aggiungiamo 8 pixel di offset per allinearci visivamente alla linea oraria
                  top: (index * hourHeight) + (hourHeight / 2) + 8,
                  left: 61, // Parte dopo la linea verticale
                  right: 0,
                  child: Container(
                    height: 1,
                    color: halfHourColor, // Grigio molto più chiaro
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
