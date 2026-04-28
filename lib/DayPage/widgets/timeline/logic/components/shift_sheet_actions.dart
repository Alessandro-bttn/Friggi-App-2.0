import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friggi_app_2/DataBase/Turni/TurniDB.dart';
import '../../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../../notifications/notification_service.dart';
import '../../../../widgets/add_turno_dialog/logic/turni_validator.dart';
import '../../../../../l10n/app_localizations.dart';

// Questo widget gestisce i pulsanti di azione (Salva, Elimina, Modifica) all'interno del ShiftDetailSheet

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

  /// Gestisce il salvataggio delle modifiche
  Future<void> _handleSave(BuildContext context, AppLocalizations l10n) async {
    // 1. Validazione (escludendo il turno stesso dal controllo sovrapposizione)
    final bool valido = await TurniValidator.isTurnoValido(
      context: context,
      idDipendente: turno.idDipendente,
      data: turno.data,
      inizio: inizio,
      fine: fine,
      idTurnoCorrente: turno.id, // Evita il conflitto con se stesso
    );

    if (!valido) return;

    try {
      // 2. Creazione dell'oggetto aggiornato
      final turnoAggiornato = TurnoModel(
        id: turno.id, // Fondamentale: deve essere lo stesso ID
        idDipendente: turno.idDipendente,
        data: turno.data,
        inizio: inizio,
        fine: fine,
      );

      // 3. Esecuzione query nel DB
      await TurniDB().updateTurno(turnoAggiornato);

      // 4. Feedback e chiusura
      NotificationService().showSuccess(l10n.turno_salvato_con_successo);

      // Ritorna true o chiama una callback se devi rinfrescare la UI della timeline
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Errore durante l'aggiornamento del turno: $e");
      NotificationService().showError(l10n.turno_salvato_errore);
    }
  }

  /// Mostra un dialogo di conferma prima di eliminare
  Future<void> _handleDelete(
      BuildContext context, AppLocalizations l10n) async {
    HapticFeedback.heavyImpact();

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.msg_elimina_conferma), // Dal tuo JSON
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
        // Esecuzione reale dell'eliminazione
        await TurniDB().deleteTurno(turno.id!);

        // Feedback (usa una stringa appropriata del tuo l10n)
        NotificationService().showSuccess(l10n.btn_annulla);

        Navigator.pop(context,
            true); // Chiude il BottomSheet passando 'true' per il refresh
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
          // --- MODALITÀ VISUALIZZAZIONE ---
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _handleDelete(context, l10n),
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.btn_annulla
                  .toUpperCase()), // Usa la tua chiave per "Elimina" se l'hai aggiunta
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
          // --- MODALITÀ EDITING ---
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
