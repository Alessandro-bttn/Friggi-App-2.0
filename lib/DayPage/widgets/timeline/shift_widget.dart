import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';

class ShiftWidget extends StatelessWidget {
  final TurnoModel turno;
  final DipendenteModel? dipendente;

  const ShiftWidget({
    super.key,
    required this.turno,
    this.dipendente,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Setup dati dipendente
    final String nomeDaMostrare = dipendente != null 
        ? dipendente!.nome 
        : "ID ${turno.idDipendente}";

    final Color baseColor = dipendente != null 
        ? Color(dipendente!.colore) 
        : Colors.grey;

    // 2. Definizione colori UI
    final Color bgColor = baseColor.withValues(alpha: 0.25);
    final Color borderColor = baseColor.withValues(alpha: 0.8);

    // 3. Calcolo contrasto dinamico: Nero su sfondi chiari, Bianco su scuri
    final Color textColor = bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 4. Logica responsiva: lunghezza testo basata sulla larghezza disponibile
          final double width = constraints.maxWidth;
          int lunghezza = 1;
          
          if (width > 24) {
            lunghezza = 3;
          } else if (width > 16) {
            lunghezza = 2;
          }

          return Align(
            alignment: Alignment.center, // Centra il widget Text nel Container
            child: Text(
              _getDynamicShortName(nomeDaMostrare, lunghezza),
              textAlign: TextAlign.center, // Centra il testo stesso
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 11,
                color: textColor, // Colore calcolato al punto 3
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          );
        },
      ),
    );
  }

  // Helper per troncare il nome
  String _getDynamicShortName(String? fullName, int length) {
    if (fullName == null || fullName.isEmpty) return "?";
    int actualLength = (fullName.length < length) ? fullName.length : length;
    return fullName.substring(0, actualLength).toUpperCase();
  }
}