import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'rootPage.dart';
import 'Lingua/language_controller.dart'; 
import 'service/preferences_service.dart'; 

// Creiamo l'istanza globale del controller
final languageController = LanguageController();

// --- MODIFICA 1: CHIAVE GLOBALE PER LE NOTIFICHE ---
// Questa chiave permette al NotificationService di trovare lo schermo
// anche senza avere il "context" della pagina specifica.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesService().init();

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
        
        final bool isDark = PreferencesService().temaScuro;

        return MaterialApp(
          navigatorKey: navigatorKey, 

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
          
          // --- GESTIONE TEMI ---
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

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