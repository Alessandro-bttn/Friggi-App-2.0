import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // FONDAMENTALE per le date
import '../service/preferences_service.dart';

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('it'); 

  Locale get locale => _locale;

  // Carica lingua salvata E inizializza le date
  Future<void> loadSavedLanguage() async {
    // 1. Leggiamo dal tuo PreferencesService
    String? savedCode = PreferencesService().lingua;

    if (savedCode != null) {
      _locale = Locale(savedCode);
    } else {
      // Logica automatica se non c'è nulla salvato
      final systemCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      if (['it', 'en', 'es'].contains(systemCode)) {
        _locale = Locale(systemCode);
      } else {
        _locale = const Locale('en'); 
      }
    }

    // 2. Inizializziamo i formati data per evitare crash
    await initializeDateFormatting(_locale.languageCode, null);

    notifyListeners();
  }

  // --- METODO AGGIUNTO PER RISOLVERE L'ERRORE ---
  // Imposta una lingua specifica (usato dalle Impostazioni)
  Future<void> changeLanguage(Locale newLocale) async {
    // 1. Aggiorna la variabile locale
    _locale = newLocale;

    // 2. Salva nel Service
    PreferencesService().lingua = newLocale.languageCode;

    // 3. Aggiorna i dati delle date per la nuova lingua (Importante!)
    await initializeDateFormatting(newLocale.languageCode, null);

    // 4. Aggiorna la UI
    notifyListeners();
  }
}