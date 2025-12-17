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

    // 2. QUESTO EVITA IL CRASH: Carichiamo i dati delle date per la lingua scelta
    await initializeDateFormatting(_locale.languageCode, null);

    notifyListeners();
  }

  // Cambia lingua e aggiorna le date
  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'it') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('it');
    }
    
    // 3. Salviamo nel tuo Service
    PreferencesService().lingua = _locale.languageCode;
    
    // 4. Aggiorniamo i dati delle date per la nuova lingua
    await initializeDateFormatting(_locale.languageCode, null);

    notifyListeners();
  }
}