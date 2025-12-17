import 'package:flutter/material.dart';

class DayGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeNext; // Swipe verso sinistra (giorno dopo)
  final VoidCallback onSwipePrev; // Swipe verso destra (giorno prima)
  final VoidCallback onZoomOut;   // Pizzico (chiude pagina)

  const DayGestureDetector({
    super.key,
    required this.child,
    required this.onSwipeNext,
    required this.onSwipePrev,
    required this.onZoomOut,
  });

  @override
  State<DayGestureDetector> createState() => _DayGestureDetectorState();
}

class _DayGestureDetectorState extends State<DayGestureDetector> {
  // Variabili per evitare trigger multipli
  bool _actionTriggered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // --- GESTIONE SWIPE (Orizzontale) ---
      onHorizontalDragEnd: (details) {
        // Velocity > 0: Swipe verso Destra (Giorno Precedente)
        // Velocity < 0: Swipe verso Sinistra (Giorno Successivo)
        if (details.primaryVelocity! > 0) {
          widget.onSwipePrev();
        } else if (details.primaryVelocity! < 0) {
          widget.onSwipeNext();
        }
      },

      // --- GESTIONE ZOOM (Dezoom / Pinch In) ---
      onScaleStart: (_) {
        _actionTriggered = false;
      },
      onScaleUpdate: (details) {
        // details.scale < 1.0 significa che sta rimpicciolendo (de-zoom)
        // Usiamo una soglia (es. 0.75) per non attivarlo per sbaglio
        if (details.scale < 0.75 && !_actionTriggered) {
          _actionTriggered = true; // Evita di chiamarlo 100 volte mentre muovi le dita
          widget.onZoomOut();
        }
      },

      behavior: HitTestBehavior.translucent, // Cattura i tocchi anche sugli spazi vuoti
      child: widget.child,
    );
  }
}