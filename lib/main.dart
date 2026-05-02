import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// IMPORT STANDARD PER L10N GENERATO (Se usi file .arb)
import 'l10n/app_localizations.dart';

import '../Provider/TurniProvider.dart';

import 'Lingua/language_controller.dart';
import 'service/preferences_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'register_login/auth_gate/AuthGate.dart';

// 1. Controller Globale Lingua
final languageController = LanguageController();

// 2. Controller Globale Tema (Aggiunto per aggiornamento real-time)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// 3. Chiave Globale Navigazione
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final turniController = TurniController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inizializza Supabase per primo, è la fondazione di tutto
  await Supabase.initialize(
    url: 'https://tsjohyuzicjyppvrzppq.supabase.co',
    anonKey: 'sb_publishable_R3ct8AaqaxOzBmDgxPZFAQ_F0L0R7qP',
  );

  // 2. Inizializza Preferenze
  await PreferencesService().init();

  // Dovrai passare l'ID del locale attivo
  final int? idLocale = PreferencesService().idLocaleCorrente;
  if (idLocale != null) {
    await turniController.inizializzaDati(idLocale);
  }
  turniController.ascoltaModificheTurni(); 

  // 4. Carica Lingua e Tema
  languageController.loadSavedLanguage();
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
      listenable: Listenable.merge(
          [languageController, themeNotifier, turniController]),
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
                seedColor: Colors.deepPurple, brightness: Brightness.light),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple, brightness: Brightness.dark),
            useMaterial3: true,
          ),

          home: const AuthGate(),
        );
      },
    );
  }
}
