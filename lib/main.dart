import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// Questa riga sotto diventerà valida dopo il primo avvio dell'app:
import 'l10n/app_localizations.dart';

import 'rootPage.dart'; // Assicurati che il nome del file corrisponda (minuscole/maiuscole)
import 'Lingua/language_controller.dart'; // Assicurati di aver creato questo file

void main() {
  runApp(const MyApp());
}

// Creiamo l'istanza globale del controller per poterla chiamare dalle altre pagine
final languageController = LanguageController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder ascolta il controller: quando cambi lingua, ricostruisce l'app
    return ListenableBuilder(
      listenable: languageController,
      builder: (context, child) {
        return MaterialApp(
          // --- CONFIGURAZIONE LOCALIZZAZIONE ---
          title: 'Gestione Spese',
          
          // Imposta la lingua corrente in base al controller
          locale: languageController.locale, 
          
          // Elenco dei file di traduzione e dei widget standard
          localizationsDelegates: const [
            AppLocalizations.delegate, // Le tue traduzioni (app_it.arb, app_en.arb)
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Lingue supportate
          supportedLocales: const [
            Locale('it'), // Italiano
            Locale('en'), // Inglese
            Locale('es'), // Spagnolo
          ],
          // --------------------------------------

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          
          // Il main delega la navigazione iniziale alla RootPage
          home: const RootPage(),
        );
      },
    );
  }
}