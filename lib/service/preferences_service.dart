// File: lib/Services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

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

  set lingua(String value) {
    _prefs.setString('chiave_lingua', value);
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
}