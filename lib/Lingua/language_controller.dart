import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  // Lingua iniziale: Inglese
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void toggleLanguage() {
    if (_locale.languageCode == 'it') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('it');
    }
    // Avvisa tutta l'app che la lingua è cambiata
    notifyListeners();
  }
}