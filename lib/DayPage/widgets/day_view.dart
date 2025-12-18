import 'package:flutter/material.dart';

// 1. WIDGET PER LA LISTA DEGLI ORARI (TIMELINE FISSA)
class DayTimeline extends StatelessWidget {
  final DateTime currentDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const DayTimeline({
    super.key,
    required this.currentDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    // CALCOLI PRELIMINARI
    final int startHour = startTime.hour;
    final int endHour = endTime.hour;
    // Numero totale di righe (ore) da disegnare
    final int totalHours = (endHour - startHour) + (endTime.minute > 0 ? 1 : 0);
    // Aggiungiamo +1 perché se l'intervallo è 9-18 (9 ore), vogliamo vedere anche la riga delle 18:00
    final int rowCount = totalHours + 1;

    return SafeArea(
      // LayoutBuilder ci dà le dimensioni massime disponibili dello schermo (senza scroll)
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalAvailableHeight = constraints.maxHeight;
          // Calcoliamo l'altezza dinamica di ogni singola ora
          final double hourHeight = totalAvailableHeight / rowCount;

          return Column(
            children: List.generate(rowCount, (index) {
              // Calcolo l'ora corrente della riga
              final int currentHour = startHour + index;
              final String hourLabel = "${currentHour.toString().padLeft(2, '0')}:00";

              // Usiamo Container o SizedBox con altezza calcolata
              return SizedBox(
                height: hourHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Allinea in alto
                  children: [
                    
                    // A. Colonna Orario
                    SizedBox(
                      width: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0), 
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            hourLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12, // Font leggermente più piccolo per sicurezza
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // B. Linea verticale separatore
                    Container(
                      width: 1,
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),

                    // C. Spazio Vuoto (Slot per i turni) + Linea Orizzontale
                    Expanded(
                      child: Stack(
                        children: [
                          // Linea orizzontale dell'ora
                          Positioned(
                            top: 8, // Allineata circa al centro del testo dell'ora
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          // Qui andranno i widget dei turni con Positioned
                          // top e height saranno calcolati in percentuale di hourHeight
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// 2. WIDGET PER IL BOTTONE (FAB)
class DayPageFab extends StatelessWidget {
  final DateTime date;

  const DayPageFab({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        print("Click su Aggiungi per il giorno: $date");
      },
      child: const Icon(Icons.add),
    );
  }
}