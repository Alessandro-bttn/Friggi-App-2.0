class WeekLogic {
  // Trova il Lunedì della settimana a cui appartiene 'date'
  static DateTime getStartOfWeek(DateTime date) {
    // date.weekday: 1 = Lunedì, 7 = Domenica
    // Se oggi è Mercoledì (3), sottraiamo 2 giorni per tornare a Lunedì
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Vai avanti di 1 settimana
  static DateTime getNextWeek(DateTime currentStartOfWeek) {
    return currentStartOfWeek.add(const Duration(days: 7));
  }

  // Vai indietro di 1 settimana
  static DateTime getPreviousWeek(DateTime currentStartOfWeek) {
    return currentStartOfWeek.subtract(const Duration(days: 7));
  }
}