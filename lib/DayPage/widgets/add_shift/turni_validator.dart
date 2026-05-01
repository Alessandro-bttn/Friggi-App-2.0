import 'package:flutter/material.dart';
import '../../../service/preferences_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../service/turno_service.dart';
import '../../../notifications/notification_service.dart';

/// Questa classe contiene la logica per validare i turni, inclusi i controlli di sovrapposizione

class TurniValidator {
  static int _toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  /// Restituisce true se il turno è valido, altrimenti mostra l'errore e restituisce false
  static Future<bool> isTurnoValido({
    required BuildContext context,
    required int idDipendente,
    required DateTime data,
    required TimeOfDay inizio,
    required TimeOfDay fine,
    int? idTurnoCorrente, // <--- AGGIUNTO: ID del turno che stiamo modificando
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = PreferencesService();
    final notifications = NotificationService();

    final int inizioMin = _toMinutes(inizio);
    final int fineMin = _toMinutes(fine);
    final int aperturaMin = _toMinutes(prefs.orarioInizio);
    final int chiusuraMin = _toMinutes(prefs.orarioFine);

    // 1. Controllo sequenza oraria
    if (inizioMin >= fineMin) {
      notifications.showError(l10n.errore_orario_sequenza);
      return false;
    }

    // 2. Controllo Apertura Locale
    if (inizioMin < aperturaMin) {
      notifications.showError("${l10n.errore_orario_apertura}: ${prefs.orarioInizio.format(context)}");
      return false;
    }

    // 3. Controllo Chiusura Locale
    if (fineMin > chiusuraMin) {
      notifications.showError("${l10n.errore_orario_chiusura}: ${prefs.orarioFine.format(context)}");
      return false;
    }

    // --- CONTROLLO SOVRAPPOSIZIONE TURNI ---
    try {
      final turniEsistenti = await TurnoService().getTurniByDipendenteEData(idDipendente, data);

      for (var turno in turniEsistenti) {
        // ESCLUSIONE AUTO-CONFLITTO:
        // Se il turno nel DB ha lo stesso ID di quello che sto modificando, lo ignoro
        if (idTurnoCorrente != null && turno.id == idTurnoCorrente) {
          continue; 
        }

        final int tInizio = _toMinutes(turno.inizio);
        final int tFine = _toMinutes(turno.fine);

        // Logica di sovrapposizione
        if (inizioMin < tFine && fineMin > tInizio) {
          notifications.showError(l10n.errore_turno_sovrapposto);
          return false;
        }
      }
    } catch (e) {
      debugPrint("Errore validazione sovrapposizione: $e");
    }

    return true; 
  }
}