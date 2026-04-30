import 'package:flutter/material.dart';

class TexturePainter extends CustomPainter {
  final int type;

  TexturePainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    if (type == 0) return;

    // --- AGGIUNTA FONDAMENTALE: IL CLIPPING ---
    // Creiamo un rettangolo che corrisponde esattamente alle dimensioni del widget
    final Rect rect = Offset.zero & size;
    // Diciamo al canvas di tagliare tutto ciò che esce da questo rettangolo
    canvas.clipRect(rect);
    // ------------------------------------------

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1.5;

    // Pattern 1: Righe diagonali
    if (type == 1) {
      // Dobbiamo far partire 'i' molto prima di 0 per riempire la diagonale
      double step = 8;
      for (double i = -size.height; i < size.width; i += step) {
        // Ora, anche se disegniamo fuori da size.width, 
        // clipRect taglierà la linea esattamente sul bordo.
        canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
      }
    } 
    // Pattern 2: Puntini
    else if (type == 2) {
      double step = 8;
      for (double i = 0; i < size.width; i += step) {
        for (double j = 0; j < size.height; j += step) {
          canvas.drawCircle(Offset(i, j), 1.5, paint);
        }
      }
    } 
    // Pattern 3: Griglia (Crosshatch)
    else if (type == 3) {
      double step = 8;
      for (double i = 0; i < size.width; i += step) {
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
        canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}