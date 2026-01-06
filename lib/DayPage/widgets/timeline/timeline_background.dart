import 'package:flutter/material.dart';

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
    final dividerColor = theme.dividerColor.withValues(alpha: 0.2);
    final textColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Stack(
      children: [
        // 1. Linea Verticale (Disegnata una volta sola per tutta l'altezza)
        Positioned(
          top: 0,
          bottom: 0,
          left: 60, // 60px larghezza colonna orario
          child: Container(
            width: 1,
            color: dividerColor,
          ),
        ),

        // 2. Orari e Linee Orizzontali
        ...List.generate(rowCount, (index) {
          final int currentHour = startHour + index;

          // Se l'orario supera la fine e non ci sono minuti extra, saltiamo (es. evitare 19:00 se finisce 18:00)
          if (currentHour > endHour && endMinute == 0) {
            return const SizedBox();
          }

          final String hourLabel = "${currentHour.toString().padLeft(2, '0')}:00";

          // Usiamo Positioned per piazzare l'ora esattamente al suo posto
          return Positioned(
            top: index * hourHeight,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A. Etichetta Orario
                SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.topCenter, // Allinea col testo
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

                // B. Spazio per la linea verticale (già disegnata sotto)
                const SizedBox(width: 1), 

                // C. Linea Orizzontale
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8), // Allinea visivamente al centro del testo
                    height: 1,
                    color: dividerColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}