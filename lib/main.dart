import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// IMPORT STANDARD PER L10N GENERATO (Se usi file .arb)
import 'l10n/app_localizations.dart';

import 'rootPage.dart';
import 'Lingua/language_controller.dart'; 
import 'service/preferences_service.dart'; 

// 1. Controller Globale Lingua
final languageController = LanguageController();

// 2. Controller Globale Tema (Aggiunto per aggiornamento real-time)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// 3. Chiave Globale Navigazione
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza Preferenze
  await PreferencesService().init();

  // Carica Lingua salvata
  languageController.loadSavedLanguage();

  // Carica Tema salvato
  bool isDarkSaved = PreferencesService().temaScuro;
  themeNotifier.value = isDarkSaved ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder ora ascolta SIA la lingua CHE il tema
    return ListenableBuilder(
      listenable: Listenable.merge([languageController, themeNotifier]),
      builder: (context, child) {
        
        return MaterialApp(
          navigatorKey: navigatorKey, 
          title: 'Gestione Spese',
          debugShowCheckedModeBanner: false,

          // --- LOCALIZZAZIONE ---
          locale: languageController.locale, 
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('it'), 
            Locale('en'), 
            Locale('es'), 
          ],
          
          // --- GESTIONE TEMI ---
          // Qui usiamo il valore del notifier, non direttamente le preferenze statiche
          themeMode: themeNotifier.value, 

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, 
              brightness: Brightness.light
            ),
            useMaterial3: true,
          ),
          
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, 
              brightness: Brightness.dark 
            ),
            useMaterial3: true,
          ),

          home: const RootPage(),
        );
      },
    );
  }
}