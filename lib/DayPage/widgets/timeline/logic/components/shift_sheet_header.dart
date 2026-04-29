import 'package:flutter/material.dart';
import '../../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../add_turno_dialog/employee_selector_field.dart'; 

// Questo widget è il header del ShiftDetailSheet, mostra il nome e il colore del dipendente associato al turno, e un titolo che cambia se stiamo modificando o solo visualizzando.

class ShiftSheetHeader extends StatelessWidget {
  final DipendenteModel? dipendente;
  final bool isEditing;

  final Function(DipendenteModel?) onDipendenteChanged;

  const ShiftSheetHeader({
    super.key, 
    this.dipendente, 
    required this.isEditing,
    required this.onDipendenteChanged, // Obbligatoria
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Avatar rimane lo stesso (si aggiornerà grazie al setState del padre)
        CircleAvatar(
          backgroundColor: dipendente != null ? Color(dipendente!.colore) : colorScheme.surfaceVariant,
          radius: 24,
          child: Text(
            dipendente?.nome.isNotEmpty == true ? dipendente!.nome[0].toUpperCase() : "?",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: isEditing 
            ? _buildEmployeeSelector(context) // Se editi, mostra il selettore
            : _buildStaticInfo(theme, l10n),  // Altrimenti solo testo
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