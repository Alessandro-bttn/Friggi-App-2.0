import 'package:flutter/material.dart';

class MonthGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback onSwipeNext; 
  final VoidCallback onSwipePrev; 
  final VoidCallback onZoomIn;    

  const MonthGestureDetector({
    super.key,
    required this.child,
    required this.onSwipeNext,
    required this.onSwipePrev,
    required this.onZoomIn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 1. SWIPE ORIZZONTALE (Cambio Mese)
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity == null) return;

        // Velocity > 0: Swipe verso Destra (Mese Precedente)
        if (details.primaryVelocity! > 0) {
          onSwipePrev();
        } 
        // Velocity < 0: Swipe verso Sinistra (Mese Successivo)
        else if (details.primaryVelocity! < 0) {
          onSwipeNext();
        }
      },

      // 2. GESTIONE ZOOM (Scale)
      onScaleUpdate: (ScaleUpdateDetails details) {
        // Se lo scale è > 1.5 (utente sta allargando le dita)
        if (details.scale > 1.5) {
          onZoomIn();
        }
      },

      // Il contenuto che reagisce al tocco
      child: Container(
        color: Colors.transparent, // Necessario per catturare i tocchi sugli spazi vuoti
        width: double.infinity,
        height: double.infinity,
        child: child,
      ),
    );
  }
}