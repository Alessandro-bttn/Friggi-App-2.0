import 'package:flutter/material.dart';

class CalendarGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeNext;
  final VoidCallback? onSwipePrev;
  final VoidCallback? onZoomIn;  // Da Mese a Settimana o da Settimana a Giorno
  final VoidCallback? onZoomOut; // Da Giorno a Settimana o da Settimana a Mese

  const CalendarGestureDetector({
    super.key,
    required this.child,
    this.onSwipeNext,
    this.onSwipePrev,
    this.onZoomIn,
    this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    Offset totalDelta = Offset.zero;
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Importante per catturare i tocchi
      onScaleStart: (_) {
        totalDelta = Offset.zero;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        // Gestione Zoom In (Pinch out)
        if (onZoomIn != null && details.scale > 1.5) {
          onZoomIn!();
        } 
        // Gestione Zoom Out (Pinch in)
        else if (onZoomOut != null && details.scale < 0.5) {
          onZoomOut!();
        }

        // Accumulo movimento per lo swipe (solo se un solo dito è appoggiato)
        if (details.scale == 1.0) {
          totalDelta += details.focalPointDelta;
        }
      },
      onScaleEnd: (ScaleEndDetails details) {
        // Calcolo dello swipe alla fine del gesto
        if (totalDelta.dx.abs() > totalDelta.dy.abs()) {
          // Soglia di 50 pixel per evitare attivazioni involontarie
          if (totalDelta.dx.abs() > 50) {
            if (totalDelta.dx > 0 && onSwipePrev != null) {
              onSwipePrev!();
            } else if (totalDelta.dx < 0 && onSwipeNext != null) {
              onSwipeNext!();
            }
          }
        }
      },
      child: child,
    );
  }
}