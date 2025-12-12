// File: lib/MonthPage/logic/month_logic.dart

class MonthLogic {
  
  /// Restituisce la data spostata al mese successivo
  static DateTime getNextMonth(DateTime current) {
    // Aggiungendo 1 al mese, Dart gestisce automaticamente il cambio anno
    // Es: Dicembre 2025 (12) + 1 diventa Gennaio 2026 (1)
    return DateTime(current.year, current.month + 1, 1);
  }

  /// Restituisce la data spostata al mese precedente
  static DateTime getPreviousMonth(DateTime current) {
    // Sottraendo 1 al mese, Dart gestisce il cambio anno all'indietro
    // Es: Gennaio 2025 (1) - 1 diventa Dicembre 2024 (12)
    return DateTime(current.year, current.month - 1, 1);
  }
}