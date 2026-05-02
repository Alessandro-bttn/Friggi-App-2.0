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
  // Nel file TurniController.dart

Future<void> inizializzaDati(int idLocale) async {
  // Se vuoi mantenere il flag _isInitialized, dovresti resettarlo 
  // se idLocale cambia, altrimenti il caricamento non parte più.
  // Per semplicità, se passi l'ID, carichiamo sempre.
  _isLoading = true;
  notifyListeners();

  try {
    // Non serve più chiedere a PreferencesService, usiamo l'idLocale passato come argomento
    debugPrint("Inizializzo dati per locale: $idLocale");

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
    // Dovrai passare l'ID del locale attivo
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      await inizializzaDati(idLocale);
    }
  }
  

  List<TurnoModel> turniDellaSettimana(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return _allTurni.where((t) {
      return t.data.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          t.data.isBefore(endOfWeek);
    }).toList();
  }

  void ascoltaModificheTurni() {
    // 1. Estrai il valore in una variabile locale
    final int? idLocale = PreferencesService().idLocaleCorrente;

    // 2. Controllo di sicurezza (Guard Clause)
    if (idLocale == null) {
      debugPrint("Errore: Nessun locale selezionato. Stream non avviato.");
      return; // Esce dalla funzione senza crashare
    }

    // 3. Ora idLocale è sicuramente non-null, Dart lo sa e non serve il '!'
    _turnoSubscription = Supabase.instance.client
        .from('turni')
        .stream(primaryKey: ['id'])
        .eq('id_locale', idLocale) // <--- Niente '!' qui, è sicuro!
        .listen((data) {
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

  Future<int?> getLocaleAttivoDalDb() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    // Cerchiamo nella tabella di giunzione che abbiamo creato
    final res = await Supabase.instance.client
        .from('workspace_members')
        .select('locale_id')
        .eq('user_id', user.id)
        .maybeSingle();

    return res?['locale_id'];
  }
}
