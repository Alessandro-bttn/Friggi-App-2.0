import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../../notifications/notification_service.dart';
import '../../../../widgets/add_turno_dialog/logic/turni_validator.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../main.dart'; // IMPORTANTE: per accedere al turniController globale

class ShiftSheetActions extends StatelessWidget {
  final TurnoModel turno;
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final bool isEditing;
  final bool hasChanges;
  final Function(bool) onEditToggle;
  final VoidCallback onReset;

  const ShiftSheetActions({
    super.key,
    required this.turno,
    required this.inizio,
    required this.fine,
    required this.isEditing,
    required this.hasChanges,
    required this.onEditToggle,
    required this.onReset,
  });

  /// Gestisce il salvataggio tramite il Provider
  Future<void> _handleSave(BuildContext context, AppLocalizations l10n) async {
    // 1. Validazione
    final bool valido = await TurniValidator.isTurnoValido(
      context: context,
      idDipendente: turno.idDipendente,
      data: turno.data,
      inizio: inizio,
      fine: fine,
      idTurnoCorrente: turno.id, 
    );

    if (!valido) return;

    try {
      // 2. Creazione dell'oggetto aggiornato tramite copyWith
      final turnoAggiornato = turno.copyWith(
        inizio: inizio,
        fine: fine,
      );

      // 3. ESECUZIONE TRAMITE PROVIDER (Gestisce DB e RAM)
      await turniController.aggiornaTurno(turnoAggiornato);

      // 4. Feedback e chiusura
      if (context.mounted) {
        NotificationService().showSuccess(l10n.turno_salvato_con_successo);
        // Non serve più passare 'true' perché il ListenableBuilder aggiorna tutto da solo
        Navigator.pop(context); 
      }
    } catch (e) {
      debugPrint("Errore salvataggio provider: $e");
      NotificationService().showError(l10n.turno_salvato_errore);
    }
  }

  /// Gestisce l'eliminazione tramite il Provider
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
        // ESECUZIONE TRAMITE PROVIDER (Gestisce DB e RAM)
        await turniController.eliminaTurno(turno.id!);

        if (context.mounted) {
          NotificationService().showSuccess("Turno eliminato");
          Navigator.pop(context); // Chiude il BottomSheet
        }
      } catch (e) {
        debugPrint("Errore eliminazione provider: $e");
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