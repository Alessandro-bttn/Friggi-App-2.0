import 'package:flutter/material.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../widgets/timeline/logic/components/pattern_painter.dart'; // Assicurati di avere il file del painter qui

class ShiftWidget extends StatelessWidget {
  final TurnoModel turno;
  final DipendenteModel? dipendente;
  final VoidCallback? onTap;
  final int patternType; // Aggiunto per il supporto texture

  const ShiftWidget({
    super.key,
    required this.turno,
    this.dipendente,
    this.onTap,
    this.patternType = 0, // Default: nessuna texture
  });

  @override
  Widget build(BuildContext context) {
    final String nomeDaMostrare = dipendente != null 
        ? "${dipendente!.nome} ${dipendente!.cognome ?? ''}"
        : "ID ${turno.idDipendente}";

    final Color baseColor = dipendente != null 
        ? Color(dipendente!.colore) 
        : Colors.grey;

    final Color bgColor = baseColor.withValues(alpha: 0.3);
    final Color borderColor = baseColor.withValues(alpha: 0.8);
    final Color textColor = bgColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        splashColor: borderColor.withValues(alpha: 0.3),
        child: CustomPaint(
          // foregroundPainter disegna il pattern SOPRA il colore di sfondo
          foregroundPainter: TexturePainter(patternType), 
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    _formatNameInitials(nomeDaMostrare, constraints.maxWidth),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: constraints.maxWidth > 24 ? 12 : 10,
                      color: textColor,
                    ),
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Nuova logica: Iniziali Nome + Cognome se c'è spazio
  String _formatNameInitials(String fullName, double width) {
    // 1. Pulisci la stringa da spazi iniziali/finali
    final trimmedName = fullName.trim();
    if (trimmedName.isEmpty) return "?";
    
    // 2. Se c'è pochissimo spazio, solo prima lettera del primo nome
    if (width < 20) return trimmedName[0].toUpperCase();

    // 3. Split intelligente usando RegExp per gestire più spazi tra i nomi
    final parts = trimmedName.split(RegExp(r'\s+'));

    // 4. Logica sicura per estrarre le iniziali
    if (parts.length >= 2) {
      // Prendi la prima lettera del primo elemento e del secondo
      final firstInitial = parts[0].isNotEmpty ? parts[0][0] : "";
      final secondInitial = parts[1].isNotEmpty ? parts[1][0] : "";
      return (firstInitial + secondInitial).toUpperCase();
    }
    
    // 5. Fallback per nomi singoli: prende i primi 2 caratteri
    return trimmedName.substring(0, trimmedName.length > 2 ? 2 : trimmedName.length).toUpperCase();
  }
}