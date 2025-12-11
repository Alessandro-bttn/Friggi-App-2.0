import 'package:flutter/material.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER: Giorni della settimana
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["lun", "mar", "mer", "gio", "ven", "sab", "dom"]
                .map((giorno) => Text(
                      giorno,
                      style: TextStyle(
                        // Usa un colore che si legge bene sia su bianco che su nero
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), 
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                .toList(),
          ),
        ),
        
        // GRIGLIA: I giorni del mese
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 colonne
              childAspectRatio: 0.6, // Rettangoli un po' più alti per sfruttare lo schermo
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            // TODO: In futuro questo diventerà dinamico
            itemCount: 31, 
            itemBuilder: (context, index) {
              final int giorno = index + 1;
              return _DayCell(giorno: giorno);
            },
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int giorno;

  const _DayCell({required this.giorno});

  @override
  Widget build(BuildContext context) {
    // Recuperiamo i colori dal tema attuale
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        // COLORE SFONDO: Cambia automticamente (Bianco in Light, Scuro in Dark)
        color: theme.cardColor, 
        
        borderRadius: BorderRadius.circular(8), // Bordi un po' più morbidi
        
        // BORDO: Sottile e del colore dei divisori del tema
        border: Border.all(color: theme.dividerColor),
        
        // OMBRA LEGGERA (Opzionale, sta bene sul bianco)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "$giorno",
              // COLORE TESTO: Automatico (Nero su Light, Bianco su Dark)
              style: TextStyle(
                color: theme.colorScheme.onSurface, 
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          // Qui aggiungeremo i pallini delle spese
        ],
      ),
    );
  }
}