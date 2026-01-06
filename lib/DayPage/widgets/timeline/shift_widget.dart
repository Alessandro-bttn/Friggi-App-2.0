import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart'; // <--- IMPORT FONDAMENTALE

class ShiftWidget extends StatelessWidget {
  final TurnoModel turno;
  final DipendenteModel? dipendente; // <--- 1. CAMPO AGGIUNTO

  const ShiftWidget({
    super.key,
    required this.turno,
    this.dipendente, // <--- 2. PARAMETRO AGGIUNTO AL COSTRUTTORE
  });

  // Funzione per ottenere le prime 3 lettere
  String _getShortName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "???";
    if (fullName.length <= 3) return fullName.toUpperCase();
    return fullName.substring(0, 3).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Se abbiamo trovato il dipendente usiamo il suo nome, altrimenti fallback sull'ID
    final String nomeDaMostrare = dipendente != null 
        ? dipendente!.nome 
        : "ID ${turno.idDipendente}";

    // Logica 3 lettere (es. "MAR")
    final String etichetta = _getShortName(nomeDaMostrare);

    // Se abbiamo il dipendente usiamo il suo colore, altrimenti grigio
    final Color baseColor = dipendente != null 
        ? Color(dipendente!.colore) 
        : Colors.grey;

    // Stile sottile: sfondo molto chiaro, bordo e testo scuri
    final Color bgColor = baseColor.withValues(alpha: 0.25);
    final Color borderColor = baseColor.withValues(alpha: 0.8);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Allinea a sinistra
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. LE 3 LETTERE (es. MAR)
          Text(
            etichetta, 
            style: TextStyle(
              fontWeight: FontWeight.w900, // Molto grassetto
              fontSize: 11,
              color: borderColor, // Testo dello stesso colore del bordo
              letterSpacing: 1.0,
            ),
          ),
          
          // 2. ORARIO (con fit per non uscire fuori)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: Text(
                "${turno.inizio.format(context)} - ${turno.fine.format(context)}",
                style: TextStyle(
                  fontSize: 10, 
                  color: Colors.black.withValues(alpha: 0.6)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}