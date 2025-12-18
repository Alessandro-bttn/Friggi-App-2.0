// File: lib/Services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService {
  // 1. SINGLETON (Pattern standard)
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  late SharedPreferences _prefs;

  // 2. INIZIALIZZAZIONE (Da chiamare nel main)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- DATI DA SALVARE ---

  // LINGUA (Codice lingua: 'it', 'en', 'es')
  String? get lingua => _prefs.getString('chiave_lingua');

  set lingua(String? value) {
    if (value != null) {
      _prefs.setString('chiave_lingua', value);
    } else {
      // Se proviamo a salvare null, rimuoviamo la preferenza
      _prefs.remove('chiave_lingua');
    }
  }

  // TEMA SCURO (True = Scuro, False = Chiaro)
  bool get temaScuro => _prefs.getBool('chiave_tema_scuro') ?? false;

  set temaScuro(bool value) {
    _prefs.setBool('chiave_tema_scuro', value);
  }

  // C. ID LOCALE CORRENTE (L'ID del negozio su cui si sta lavorando)
  // Ritorna un int? (può essere null se non è stato ancora selezionato nulla)
  int? get idLocaleCorrente => _prefs.getInt('chiave_id_locale');

  set idLocaleCorrente(int? value) {
    if (value != null) {
      _prefs.setInt('chiave_id_locale', value);
    } else {
      // Se passiamo null, rimuoviamo la preferenza (reset selezione)
      _prefs.remove('chiave_id_locale');
    }
  }

  // Funzione per cancellare tutto (Reset totale app)
  Future<void> clear() async {
    await _prefs.clear();
  }

  int get divisioneTurni => _prefs.getInt('chiave_div_turni') ?? 0;
  set divisioneTurni(int value) => _prefs.setInt('chiave_div_turni', value);

  // 2. ORARIO INIZIO (Salvataggio "HH:mm", Default 09:00)
  TimeOfDay get orarioInizio {
    final s = _prefs.getString('chiave_ora_inizio');
    if (s == null) return const TimeOfDay(hour: 9, minute: 0);
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  set orarioInizio(TimeOfDay time) {
    final s = '${time.hour}:${time.minute}';
    _prefs.setString('chiave_ora_inizio', s);
  }

  // 3. ORARIO FINE (Salvataggio "HH:mm", Default 18:00)
  TimeOfDay get orarioFine {
    final s = _prefs.getString('chiave_ora_fine');
    if (s == null) return const TimeOfDay(hour: 18, minute: 0);
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  set orarioFine(TimeOfDay time) {
    final s = '${time.hour}:${time.minute}';
    _prefs.setString('chiave_ora_fine', s);
  }
}
