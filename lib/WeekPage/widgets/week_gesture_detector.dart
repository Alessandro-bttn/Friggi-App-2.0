import 'package:flutter/material.dart';

class WeekGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback onSwipeNext; // Vai al futuro
  final VoidCallback onSwipePrev; // Vai al passato
  final VoidCallback onZoomOut;   // Torna al mese

  const WeekGestureDetector({
    super.key,
    required this.child,
    required this.onSwipeNext,
    required this.onSwipePrev,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // --- GESTIONE SWIPE (Cambio Settimana) ---
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity == null) return;

        // Velocity < 0: Il dito si muove da Destra a Sinistra (<--)
        // Standard UX: Significa "Voglio vedere cosa c'è DOPO" (Futuro)
        if (details.primaryVelocity! < 0) {
          onSwipeNext(); 
        } 
        // Velocity > 0: Il dito si muove da Sinistra a Destra (-->)
        // Standard UX: Significa "Voglio vedere cosa c'era PRIMA" (Passato)
        else if (details.primaryVelocity! > 0) {
          onSwipePrev();
        }
      },

      // --- GESTIONE ZOOM (Pinch to Close) ---
      onScaleUpdate: (ScaleUpdateDetails details) {
        // Se scale < 1 (stai pizzicando/rimpicciolendo), torni al mese
        if (details.scale < 0.8) { // 0.8 è una buona soglia di sensibilità
          onZoomOut();
        }
      },

      // Container trasparente per catturare i tocchi su tutto lo schermo
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: child,
      ),
    );
  }
}