import 'package:flutter/material.dart';

// 1. WIDGET PER LA LISTA DEGLI ORARI
class DayTimeline extends StatelessWidget {
  const DayTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Avvolgiamo tutto in SafeArea
    return SafeArea(
      // SafeArea restringe lo spazio disponibile togliendo notch e barre di sistema
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 2. Ora constraints.maxHeight è l'altezza "SICURA" e pulita
          final double totalHeight = constraints.maxHeight;
          
          // Dividiamo lo spazio sicuro per 48 slot
          final double slotHeight = totalHeight / 48;

          return Column(
            children: List.generate(48, (index) {
              // Calcoli per Ora e Mezz'ora
              final int hour = index ~/ 2; 
              final bool isHalfHour = (index % 2) != 0; 

              return SizedBox(
                height: slotHeight, // Altezza dinamica sicura
                child: Row(
                  children: [
                    // A. Colonna Orario
                    SizedBox(
                      width: 70,
                      child: Center(
                        child: isHalfHour
                            ? null // Niente testo per le mezz'ore
                            : Text(
                                "$hour:00",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10, 
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ),
                      ),
                    ),

                    // B. Linea verticale
                    Container(
                      width: 1,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),

                    // C. Spazio Vuoto (Slot per i turni)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: isHalfHour
                                  ? Colors.grey.withValues(alpha: 0.1) 
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const SizedBox(), 
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