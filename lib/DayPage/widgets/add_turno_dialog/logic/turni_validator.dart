import 'package:flutter/material.dart';
import '../../../../service/preferences_service.dart';
import '../../../../l10n/app_localizations.dart';

class TurniValidator {
  /// Converte TimeOfDay in minuti totali per facilitare il confronto
  static int _toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  /// Restituisce una stringa di errore se il turno non è valido, altrimenti null
  static String? validaTurno({
    required BuildContext context,
    required TimeOfDay inizio,
    required TimeOfDay fine,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = PreferencesService();
    
    final int inizioMin = _toMinutes(inizio);
    final int fineMin = _toMinutes(fine);
    final int aperturaMin = _toMinutes(prefs.orarioInizio);
    final int chiusuraMin = _toMinutes(prefs.orarioFine);

    // 1. Controllo sequenza (Inizio deve essere prima di Fine)
    if (inizioMin >= fineMin) {
      return l10n.errore_orario_sequenza; 
    }

    // 2. Controllo Apertura (Inizio non può essere prima dell'apertura locale)
    if (inizioMin < aperturaMin) {
      return "${l10n.errore_orario_apertura}: ${prefs.orarioInizio.format(context)}";
    }

    // 3. Controllo Chiusura (Fine non può essere dopo la chiusura locale)
    if (fineMin > chiusuraMin) {
      return "${l10n.errore_orario_chiusura}: ${prefs.orarioFine.format(context)}";
    }

    return null; // Nessun errore
  }
}