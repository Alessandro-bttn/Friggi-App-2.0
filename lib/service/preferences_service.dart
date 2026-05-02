import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Questo servizio gestisce tutte le preferenze locali dell'app, come lingua, tema, e dati utente temporanei (es. idLocaleCorrente).

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  late SharedPreferences _prefs;
  bool _isInitialized = false; // Flag per controllare lo stato

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    } catch (e) {
      debugPrint("Errore critico durante inizializzazione Preferences: $e");
      throw Exception("Impossibile inizializzare lo storage locale.");
    }
  }

  // Metodo helper per validare l'accesso
  void _checkReady() {
    if (!_isInitialized) {
      throw StateError("PreferencesService non inizializzato! "
          "Assicurati di chiamare await PreferencesService().init() nel main().");
    }
  }

  Future<void> setIdLocaleCorrente(int id) async {
    await _prefs.setInt('id_locale_corrente', id);
  }

  // --- DATI DI CONFIGURAZIONE ---
  String? get lingua {
    _checkReady();
    return _prefs.getString('chiave_lingua');
  }

  set lingua(String? value) {
    _checkReady();
    value != null
        ? _prefs.setString('chiave_lingua', value)
        : _prefs.remove('chiave_lingua');
  }

  bool get temaScuro {
    _checkReady();
    return _prefs.getBool('chiave_tema_scuro') ?? false;
  }

  set temaScuro(bool value) {
    _checkReady();
    _prefs.setBool('chiave_tema_scuro', value);
  }

  // --- DATI UTENTE ---

  int? get idLocaleCorrente {
    _checkReady(); // Controllo che sia inizializzato
    return _prefs.getInt('chiave_id_locale');
  }

  set idLocaleCorrente(int? value) {
    _checkReady();
    if (value != null) {
      _prefs.setInt('chiave_id_locale', value);
    } else {
      _prefs.remove('chiave_id_locale');
    }
  }

  // Parsing sicuro per TimeOfDay
  TimeOfDay get orarioInizio {
    _checkReady();
    final s = _prefs.getString('chiave_ora_inizio');
    if (s == null) return const TimeOfDay(hour: 9, minute: 0);

    try {
      final parts = s.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      debugPrint(
          "Errore parsing orarioInizio (formato corrotto): $s. Reset a 09:00");
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  set orarioInizio(TimeOfDay time) {
    _checkReady();
    _prefs.setString('chiave_ora_inizio', '${time.hour}:${time.minute}');
  }

  TimeOfDay get orarioFine {
    _checkReady();
    final s = _prefs.getString('chiave_ora_fine');
    if (s == null) return const TimeOfDay(hour: 18, minute: 0);

    try {
      final parts = s.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      debugPrint(
          "Errore parsing orarioFine (formato corrotto): $s. Reset a 18:00");
      return const TimeOfDay(hour: 18, minute: 0);
    }
  }

  set orarioFine(TimeOfDay time) {
    _checkReady();
    _prefs.setString('chiave_ora_fine', '${time.hour}:${time.minute}');
  }

  // --- DIVISIONE TURNI ---
  int get divisioneTurni {
    _checkReady();
    return _prefs.getInt('chiave_div_turni') ?? 0;
  }

  set divisioneTurni(int value) {
    _checkReady();
    _prefs.setInt('chiave_div_turni', value);
  }

  // --- FORMATO ORA ---
  bool get use24hFormat {
    _checkReady();
    return _prefs.getBool('use24hFormat') ?? true;
  }

  set use24hFormat(bool value) {
    _checkReady();
    _prefs.setBool('use24hFormat', value);
  }

  Future<void> clearAll() async {
    await _prefs.clear(); // Pulisce tutte le preferenze salvate
  }

  Future<void> clearUserSession() async {
    _checkReady(); // Verifica che il servizio sia inizializzato

    // Rimuoviamo solo le chiavi specifiche dei dati utente
    await _prefs.remove('chiave_id_locale');
    await _prefs.remove('chiave_div_turni');
    await _prefs.remove('chiave_ora_inizio');
    await _prefs.remove('chiave_ora_fine');
    await _prefs.remove(
        'use24hFormat'); // Aggiunto dato che abbiamo creato il getter prima
  }
}
