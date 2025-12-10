import 'package:flutter/material.dart';
import 'dart:ui'; // Necessario per leggere la lingua del sistema (PlatformDispatcher)
import '../service/preferences_service.dart';

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('it'); // Default temporaneo

  Locale get locale => _locale;

  void loadSavedLanguage() {
    // 1. Proviamo a leggere se c'è già una preferenza salvata
    String? savedCode = PreferencesService().lingua;

    if (savedCode != null) {
      _locale = Locale(savedCode);
    } else {
      // PlatformDispatcher ci dà la lista delle lingue preferite dall'utente
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final systemCode = systemLocale.languageCode;

      // Controlliamo se la lingua del telefono è tra quelle che supportiamo
      if (['it', 'en', 'es'].contains(systemCode)) {
        _locale = Locale(systemCode);
      } else {
        // Se il telefono è in Cinese o Tedesco, mettiamo Inglese come fallback
        _locale = const Locale('en'); 
      }
    }
    notifyListeners();
  }

  void toggleLanguage() {
    // ... (Il resto rimane uguale)
    if (_locale.languageCode == 'it') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('it');
    }
    PreferencesService().lingua = _locale.languageCode;
    notifyListeners();
  }
}