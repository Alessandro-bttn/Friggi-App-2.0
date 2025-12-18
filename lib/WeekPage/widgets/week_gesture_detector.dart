import 'package:flutter/material.dart';

class WeekGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeNext; // Swipe <-- (Futuro)
  final VoidCallback onSwipePrev; // Swipe --> (Passato)
  final VoidCallback onZoomOut;   // Pizzico (Torna al mese)
  final VoidCallback onZoomIn;    // Espansione (Vai al giorno) <--- QUESTO MANCAVA

  const WeekGestureDetector({
    super.key,
    required this.child,
    required this.onSwipeNext,
    required this.onSwipePrev,
    required this.onZoomOut,
    required this.onZoomIn, // <--- Assicurati che ci sia qui
  });

  @override
  State<WeekGestureDetector> createState() => _WeekGestureDetectorState();
}

class _WeekGestureDetectorState extends State<WeekGestureDetector> {
  // Variabile per evitare che Zoom e Swipe avvengano contemporaneamente
  bool _zoomActionTriggered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 1. INIZIO TOCCO
      onScaleStart: (_) {
        _zoomActionTriggered = false; // Resettiamo il blocco
      },

      // 2. AGGIORNAMENTO (Gestiamo lo ZOOM qui)
      onScaleUpdate: (ScaleUpdateDetails details) {
        // Se abbiamo già attivato uno zoom, non facciamo altro
        if (_zoomActionTriggered) return;

        // ZOOM OUT (Pinch In - Pizzico): Torna al Mese
        if (details.scale < 0.8) { 
          _zoomActionTriggered = true;
          widget.onZoomOut();
        }
        
        // ZOOM IN (Spread - Espansione): Vai al Giorno
        else if (details.scale > 1.3) { 
          _zoomActionTriggered = true;
          widget.onZoomIn(); 
        }
      },

      // 3. FINE TOCCO (Gestiamo lo SWIPE qui)
      onScaleEnd: (ScaleEndDetails details) {
        if (_zoomActionTriggered) return;

        final double velocity = details.velocity.pixelsPerSecond.dx;

        // Swipe verso Sinistra (<--) -> Futuro
        if (velocity < -400) {
          widget.onSwipeNext();
        } 
        // Swipe verso Destra (-->) -> Passato
        else if (velocity > 400) {
          widget.onSwipePrev();
        }
      },

      behavior: HitTestBehavior.translucent, 
      
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: widget.child,
      ),
    );
  }
}