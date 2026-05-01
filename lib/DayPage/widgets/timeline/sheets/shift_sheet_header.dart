import 'package:flutter/material.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../../l10n/app_localizations.dart';
import '../../add_shift/employee_selector_field.dart'; 

// Questo widget rappresenta l'intestazione del ShiftDetailSheet, mostrando le iniziali del dipendente e il suo nome,
// con la possibilità di modificare il dipendente se siamo in modalità editing.

class ShiftSheetHeader extends StatelessWidget {
  final DipendenteModel? dipendente;
  final bool isEditing;
  final Function(DipendenteModel?) onDipendenteChanged;

  const ShiftSheetHeader({
    super.key, 
    this.dipendente, 
    required this.isEditing,
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
        // Semplificato: torniamo a CircleAvatar per massima pulizia
        CircleAvatar(
          radius: 24,
          backgroundColor: dipendente != null 
              ? Color(dipendente!.colore) 
              : colorScheme.surfaceVariant,
          child: Text(
            _getIniziali(),
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 18
            ),
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

  Widget _buildEmployeeSelector(BuildContext context) {
    return EmployeeSelectorField(
      selectedDipendente: dipendente,
      onSelected: onDipendenteChanged,
    );
  }
}