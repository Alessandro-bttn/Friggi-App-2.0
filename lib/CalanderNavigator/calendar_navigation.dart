import 'package:flutter/material.dart';
import '../WeekPage/WeekPage.dart';
import '../DayPage/DayPage.dart';
import '../l10n/app_localizations.dart'; // Importa le traduzioni

class CalendarNavigationService {
  static void switchToView({
    required BuildContext context,
    required String targetView,
    required String currentView,
    required DateTime referenceDate,
    required VoidCallback onReturn,
  }) {
    final l10n = AppLocalizations.of(context)!;

    // --- LOGICA DI CONFRONTO SICURA ---
    // Verifichiamo se la stringa premuta corrisponde alla traduzione di Giorno, Settimana o Mese
    bool isGiorno = targetView == l10n.calendar_day;
    bool isSettimana = targetView == l10n.calendar_week;
    bool isMese = targetView == l10n.calendar_month;

    // Se premo la vista in cui sono già, esci
    if (targetView == currentView) return;

    // 1. Torna al MESE
    if (isMese) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // 2. Da GIORNO a SETTIMANA (Sostituzione)
    if (isSettimana && currentView == l10n.calendar_day) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WeekPage(dataIniziale: referenceDate)),
      ).then((_) => onReturn());
      return;
    }

    // 3. Navigazione standard (PUSH)
    Widget? nextPage;
    if (isSettimana) {
      nextPage = WeekPage(dataIniziale: referenceDate);
    } else if (isGiorno) {
      nextPage = DayPage(selectedDate: referenceDate);
    }

    // 1. Controllo che nextPage non sia nullo
    if (nextPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // 2. Usiamo l'operatore '!' (bang operator) per dire a Dart:
          // "Tranquillo, ho appena controllato che non è nullo"
          builder: (context) => nextPage!,
        ),
      ).then((_) => onReturn());
    } else {
      // Opzionale: un log per capire se qualcosa è andato storto nello switch
      debugPrint(
          "Navigazione annullata: nextPage è nullo per target: $targetView");
    }
  }
}
