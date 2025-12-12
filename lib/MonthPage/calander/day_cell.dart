import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final int giorno;
  // 1. Aggiungiamo la funzione che viene chiamata al click
  final VoidCallback onTap; 

  const DayCell({
    super.key, 
    required this.giorno,
    required this.onTap, // Obbligatorio
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Per avere l'effetto click e i bordi arrotondati insieme,
    // usiamo questa struttura: Container (Ombra) -> Material (Colore) -> InkWell (Click)
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      // ClipRRect serve a tagliare l'effetto onda del click che altrimenti uscirebbe dai bordi
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: theme.cardColor, // Il colore va qui nel Material
          child: InkWell(
            onTap: onTap, // 2. Qui colleghiamo il click
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "$giorno",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                // Spazio per i futuri pallini
              ],
            ),
          ),
        ),
      ),
    );
  }
}