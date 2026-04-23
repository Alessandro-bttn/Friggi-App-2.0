import 'package:flutter/material.dart';
import '../WeekPage/WeekPage.dart';
import '../DayPage/DayPage.dart';
import '../MonthPage/MonthPage.dart';
// File: lib/CalanderNavigator/calendar_navigation.dart

class CalendarNavigationService {
  // Nel file calendar_navigation.dart

  static void switchToView({
    required BuildContext context,
    required String targetView,
    required String currentView,
    required DateTime referenceDate,
    required VoidCallback onReturn,
  }) {
    if (targetView == currentView) return;

    // --- SOLUZIONE AL TUO ERRORE ---
    if (targetView == 'Mese') {
      // Invece di un semplice pop, torniamo alla prima rotta (il Mese)
      // Questo rimuove Settimana, Giorno e qualsiasi altra cosa sopra il Mese
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // Se vuoi passare da Giorno a Settimana in modo pulito:
    if (targetView == 'Settimana' && currentView == 'Giorno') {
      // Sostituiamo il Giorno con la Settimana invece di sovrapporli
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WeekPage(dataIniziale: referenceDate)),
      ).then((_) => onReturn());
      return;
    }

    // Navigazione standard per gli altri casi
    Widget? nextPage;
    switch (targetView) {
      case 'Settimana':
        nextPage = WeekPage(dataIniziale: referenceDate);
        break;
      case 'Giorno':
        nextPage = DayPage(selectedDate: referenceDate);
        break;
    }

    if (nextPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
      ).then((_) => onReturn());
    }
  }
}
