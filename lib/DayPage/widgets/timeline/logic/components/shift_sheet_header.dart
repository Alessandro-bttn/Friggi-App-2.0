import 'package:flutter/material.dart';
import '../../../../../DataBase/Dipendente/DipendenteModel.dart';

// Questo widget è il header del ShiftDetailSheet, mostra il nome e il colore del dipendente associato al turno, e un titolo che cambia se stiamo modificando o solo visualizzando.

class ShiftSheetHeader extends StatelessWidget {
  final DipendenteModel? dipendente;
  final bool isEditing;

  const ShiftSheetHeader({super.key, this.dipendente, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: dipendente != null ? Color(dipendente!.colore) : colorScheme.surfaceVariant,
          radius: 24,
          child: Text(
            dipendente?.nome[0].toUpperCase() ?? "?",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dipendente?.nome ?? 'Sconosciuto', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(isEditing ? "Modifica orari" : "Dettaglio turno", 
                   style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}