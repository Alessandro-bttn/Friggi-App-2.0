import 'package:flutter/material.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';

class EmployeeBadge extends StatelessWidget {
  final DipendenteModel dipendente;
  final double size; 

  const EmployeeBadge({
    super.key,
    required this.dipendente,
    this.size = 24.0, 
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(dipendente.colore);
    final Color textColor = bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    final String iniziale = dipendente.nome.isNotEmpty 
        ? dipendente.nome[0].toUpperCase() 
        : "?";

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 1, // Blur ridotto per essere più pulito in piccolo
            offset: const Offset(0, 1),
          )
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        iniziale,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w900, // Grassetto per leggibilità
          fontSize: size * 0.55, 
        ),
      ),
    );
  }
}