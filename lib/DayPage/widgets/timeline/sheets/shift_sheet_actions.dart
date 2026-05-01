import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../../notifications/notification_service.dart';
import '../../add_shift/turni_validator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../main.dart'; 

// Questo widget contiene i pulsanti di azione (modifica, elimina, salva, annulla) per il ShiftDetailSheet, con tutta la logica associata.

class ShiftSheetActions extends StatelessWidget {
  final TurnoModel turno;
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final DipendenteModel? currentDipendente; // <--- AGGIUNTO
  final bool isEditing;
  final bool hasChanges;
  final Function(bool) onEditToggle;
  final VoidCallback onReset;

  const ShiftSheetActions({
    super.key,
    required this.turno,
    required this.inizio,
    required this.fine,
    this.currentDipendente, // <--- AGGIUNTO
    required this.isEditing,
    required this.hasChanges,
    required this.onEditToggle,
    required this.onReset,
  });

  Future<void> _handleSave(BuildContext context, AppLocalizations l10n) async {
    // Usiamo l'ID del dipendente correntemente selezionato, non quello vecchio del turno
    final int idDipendenteEffettivo = currentDipendente?.id ?? turno.idDipendente;

    final bool valido = await TurniValidator.isTurnoValido(
      context: context,
      idDipendente: idDipendenteEffettivo,
      data: turno.data,
      inizio: inizio,
      fine: fine,
      idTurnoCorrente: turno.id, 
    );

    if (!valido) return;

    try {
      // Creiamo il turno aggiornato includendo il (potenziale) nuovo ID dipendente
      final turnoAggiornato = turno.copyWith(
        idDipendente: idDipendenteEffettivo, // <--- ORA SALVA IL NUOVO DIPENDENTE
        inizio: inizio,
        fine: fine,
      );

      await turniController.aggiornaTurno(turnoAggiornato);

      if (context.mounted) {
        NotificationService().showSuccess(l10n.turno_salvato_con_successo);
        Navigator.pop(context); 
      }
    } catch (e) {
      debugPrint("Errore salvataggio: $e");
      NotificationService().showError(l10n.turno_salvato_errore);
    }
  }

  Future<void> _handleDelete(BuildContext context, AppLocalizations l10n) async {
    HapticFeedback.heavyImpact();

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.msg_elimina_conferma),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btn_annulla),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.btn_conferma,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await turniController.eliminaTurno(turno.id!);
        if (context.mounted) {
          NotificationService().showSuccess("Turno eliminato");
          Navigator.pop(context); 
        }
      } catch (e) {
        debugPrint("Errore eliminazione: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (!isEditing) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _handleDelete(context, l10n),
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.btnElimina.toUpperCase()), 
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => onEditToggle(true),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.dipendenti_modifica.toUpperCase()),
            ),
          ),
        ] else ...[
          Expanded(
            child: TextButton(
              onPressed: () {
                onReset();
                onEditToggle(false);
              },
              child: Text(l10n.btn_annulla),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: hasChanges ? () => _handleSave(context, l10n) : null,
              icon: const Icon(Icons.check),
              label: Text(l10n.btn_conferma),
            ),
          ),
        ],
      ],
    );
  }
}