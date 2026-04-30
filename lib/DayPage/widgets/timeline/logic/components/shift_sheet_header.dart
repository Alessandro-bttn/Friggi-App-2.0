import 'package:flutter/material.dart';
import '../../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../add_turno_dialog/employee_selector_field.dart'; 
import 'pattern_painter.dart';

// Questo widget è il header del ShiftDetailSheet, mostra il nome e il colore del dipendente associato al turno, 
// e un titolo che cambia se stiamo modificando o solo visualizzando.

class ShiftSheetHeader extends StatelessWidget {
  final DipendenteModel? dipendente;
  final bool isEditing;
  final int patternType; // 0 (normale), 1, 2, 3 (texture)
  final Function(DipendenteModel?) onDipendenteChanged;

  const ShiftSheetHeader({
    super.key, 
    this.dipendente, 
    required this.isEditing,
    this.patternType = 0, // Default 0
    required this.onDipendenteChanged,
  });

  String _getIniziali() {
    if (dipendente == null) return "?";
    String n = dipendente!.nome.isNotEmpty ? dipendente!.nome[0] : "";
    String c = (dipendente!.cognome != null && dipendente!.cognome!.isNotEmpty) 
               ? dipendente!.cognome![0] : "";
    return (n + c).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Sostituiamo il semplice CircleAvatar con uno Stack che supporta le texture
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: dipendente != null ? Color(dipendente!.colore) : colorScheme.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: TexturePainter(patternType),
                child: Container(),
              ),
              Center(
                child: Text(
                  _getIniziali(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: isEditing 
            ? _buildEmployeeSelector(context) 
            : _buildStaticInfo(theme, l10n),
        ),
      ],
    );
  }

  // Widget quando NON è in modalità editing
  Widget _buildStaticInfo(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dipendente?.nome ?? l10n.dipendente_sconosciuto, 
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
      ],
    );
  }

  // Widget quando SIAMO in modalità editing
  Widget _buildEmployeeSelector(BuildContext context) {
    // Qui usiamo il tuo widget di selezione esistente
    return EmployeeSelectorField(
      selectedDipendente: dipendente,
      onSelected: onDipendenteChanged,
    );
  }
}