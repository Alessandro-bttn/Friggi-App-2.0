import 'package:flutter/material.dart';
import '../DataBase/Turni/TurniDB.dart';
import '../DataBase/Turni/TurnoModel.dart';
import '../DataBase/Dipendente/DipendenteDB.dart';
import '../DataBase/Dipendente/DipendenteModel.dart';

class TurniController extends ChangeNotifier {
  // --- STATO ---
  List<TurnoModel> _allTurni = [];
  List<DipendenteModel> _allDipendenti = [];
  bool _isLoading = false;

  // --- GETTERS ---
  List<TurnoModel> get turni => _allTurni;
  List<DipendenteModel> get dipendenti => _allDipendenti;
  bool get isLoading => _isLoading;

  // --- LOGICA DI CARICAMENTO ---

  /// Carica tutto in memoria. Da chiamare all'avvio dell'app.
  Future<void> inizializzaDati() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Carichiamo tutto in parallelo per massimizzare la velocità
      final risultati = await Future.wait([
        TurniDB().getTurni(),
        DipendenteDB().getAllDipendenti(),
      ]);

      _allTurni = risultati[0] as List<TurnoModel>;
      _allDipendenti = risultati[1] as List<DipendenteModel>;
    } catch (e) {
      debugPrint("Errore inizializzazione Controller: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- FILTRI VELOCI (In Memoria, no DB query) ---

  List<TurnoModel> turniDelGiorno(DateTime data) {
    return _allTurni
        .where((t) =>
            t.data.year == data.year &&
            t.data.month == data.month &&
            t.data.day == data.day)
        .toList();
  }

  List<TurnoModel> turniDelMese(DateTime data) {
    return _allTurni
        .where((t) => t.data.year == data.year && t.data.month == data.month)
        .toList();
  }

  // --- OPERAZIONI CRUD (DB + MEMORIA) ---

  Future<void> aggiungiTurno(TurnoModel nuovo) async {
    // 1. Salviamo sul DB e otteniamo l'ID generato
    final id = await TurniDB().insertTurno(nuovo);
    final turnoConId = nuovo.copyWith(id: id);

    // 2. Aggiorniamo la memoria
    _allTurni.add(turnoConId);

    // 3. Notifichiamo tutte le pagine (Giorno, Settimana, Mese si aggiornano insieme)
    notifyListeners();
  }

  Future<void> aggiornaTurno(TurnoModel turnoModificato) async {
    // 1. DB
    await TurniDB().updateTurno(turnoModificato);

    // 2. Memoria
    int index = _allTurni.indexWhere((t) => t.id == turnoModificato.id);
    if (index != -1) {
      _allTurni[index] = turnoModificato;
      notifyListeners();
    }
  }

  Future<void> eliminaTurno(int id) async {
    // 1. DB
    await TurniDB().deleteTurno(id);

    // 2. Memoria
    _allTurni.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Utile se cambi locale o vuoi forzare un ricaricamento totale
  Future<void> refreshTotale() async {
    await inizializzaDati();
  }

  List<TurnoModel> turniDellaSettimana(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return _allTurni.where((t) {
      return t.data.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          t.data.isBefore(endOfWeek);
    }).toList();
  }
}
