import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';

class MiniShiftWidget extends StatelessWidget {
  final TurnoModel turno;
  final DipendenteModel? dipendente;

  const MiniShiftWidget({
    super.key,
    required this.turno,
    this.dipendente,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = dipendente != null 
        ? Color(dipendente!.colore) 
        : Colors.grey;

    // Logica contrasto
    final Color textColor = baseColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    final String lettera = (dipendente?.nome.isNotEmpty == true) 
        ? dipendente!.nome[0].toUpperCase() 
        : "?";

    return Container(
      // Non diamo width/height fissi, prende quelli del Positioned
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4), 
        boxShadow: [
           BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 2, offset: Offset(0,1))
        ]
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // LETTERA (In alto)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              lettera,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}