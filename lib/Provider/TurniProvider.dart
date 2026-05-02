import 'package:flutter/material.dart';
import '../service/turno_service.dart';
import '../DataBase/Turni/TurnoModel.dart';
import '../service/dipendente_service.dart';
import '../DataBase/Dipendente/DipendenteModel.dart';
import '../service/preferences_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class TurniController extends ChangeNotifier {
  StreamSubscription? _turnoSubscription;
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
      final int? idLocale = PreferencesService().idLocaleCorrente;
      if (idLocale == null) {
        debugPrint("Nessun locale selezionato.");
        return;
      }

      // Ora passiamo l'idLocale ai nuovi metodi dei Service
      final risultati = await Future.wait([
        TurnoService().getTurniByLocale(idLocale),
        DipendenteService().getDipendentiByLocale(idLocale),
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
    try {
      // 1. Aggiungi subito alla lista (UI veloce)
      _allTurni.add(nuovo);
      notifyListeners();

      // 2. Prova a salvare sul DB
      final turnoSalvato = await TurnoService().addTurno(nuovo);

      // 3. Se serve, sostituisci il segnaposto con l'oggetto reale (con ID generato dal DB)
      final index = _allTurni.indexOf(nuovo);
      _allTurni[index] = turnoSalvato;
      notifyListeners();
    } catch (e) {
      // 4. Se fallisce, rimuovi l'elemento e avvisa l'utente
      _allTurni.remove(nuovo);
      notifyListeners();
      throw e; // Rilancia l'errore per gestirlo nella UI
    }
  }

  Future<void> eliminaTurno(int id) async {
    await TurnoService().deleteTurno(id);
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

  void ascoltaModificheTurni() {
    _turnoSubscription = Supabase.instance.client
        .from('turni')
        .stream(primaryKey: ['id'])
        .eq(
            'id_locale',
            PreferencesService()
                .idLocaleCorrente!) // Filtra solo per questo locale
        .listen((data) {
          print(
              "DEBUG: Ho ricevuto ${data.length} turni dal database!"); // <-- AGGIUNGI QUESTO
          _allTurni = data.map((json) => TurnoModel.fromJson(json)).toList();
          notifyListeners();
        });
  }

// Ricordati di chiudere la subscription quando il controller viene distrutto
  @override
  void dispose() {
    _turnoSubscription?.cancel();
    super.dispose();
  }

  Future<void> aggiornaTurno(TurnoModel turnoModificato) async {
    await TurnoService().updateTurno(turnoModificato);

    int index = _allTurni.indexWhere((t) => t.id == turnoModificato.id);
    if (index != -1) {
      _allTurni[index] = turnoModificato;
      notifyListeners();
    }
  }
}
