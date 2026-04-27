import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart'; 

class ShiftWidget extends StatelessWidget {
  final TurnoModel turno;
  final DipendenteModel? dipendente;
  final VoidCallback? onTap; // Aggiunta callback per il click

  const ShiftWidget({
    super.key,
    required this.turno,
    this.dipendente,
    this.onTap, // Passalo nel costruttore
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

    // 3. Contrasto dinamico
    final Color textColor = bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    // USARE INKWELL PER IL FEEDBACK VISIVO
    return Material(
      color: Colors.transparent, // Necessario per non coprire il decoro sotto
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6), // Deve matchare il BorderRadius del Container
        splashColor: borderColor.withValues(alpha: 0.3), // Colore del "ripple"
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              int lunghezza = 1;
              
              if (width > 24) {
                lunghezza = 3;
              } else if (width > 16) {
                lunghezza = 2;
              }

              return Align(
                alignment: Alignment.center,
                child: Text(
                  _getDynamicShortName(nomeDaMostrare, lunghezza),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: textColor,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getDynamicShortName(String? fullName, int length) {
    if (fullName == null || fullName.isEmpty) return "?";
    int actualLength = (fullName.length < length) ? fullName.length : length;
    return fullName.substring(0, actualLength).toUpperCase();
  }
}