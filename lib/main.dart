import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'rootPage.dart';
import 'Lingua/language_controller.dart'; 
import 'service/preferences_service.dart'; // /// 1. IMPORTA IL SERVIZIO

// Creiamo l'istanza globale del controller
final languageController = LanguageController();

// /// 2. TRASFORMA IL MAIN IN ASYNC
void main() async {
  // /// 3. ASSICURA CHE I WIDGET SIANO PRONTI
  WidgetsFlutterBinding.ensureInitialized();

  // /// 4. SVEGLIA IL MAGGIORDOMO (Carica le preferenze)
  await PreferencesService().init();

  // /// 5. LEGGI LA LINGUA SALVATA
  // Ora che il servizio è pronto, diciamo al controller di aggiornarsi
  languageController.loadSavedLanguage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: languageController,
      builder: (context, child) {
        
        // /// 6. LEGGI IL TEMA SALVATO
        // Leggiamo se l'utente preferisce il tema scuro
        final bool isDark = PreferencesService().temaScuro;

        return MaterialApp(
          title: 'Gestione Spese',
          
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
          
          // --- GESTIONE TEMI (Chiaro / Scuro) ---
          // Impostiamo il ThemeMode in base alla preferenza salvata
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          // TEMA CHIARO
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, 
              brightness: Brightness.light
            ),
            useMaterial3: true,
          ),
          
          // TEMA SCURO (Definiamo come deve apparire)
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, 
              brightness: Brightness.dark // <--- Importante per la modalità scura
            ),
            useMaterial3: true,
          ),

          home: const RootPage(),
        );
      },
    );
  }
}