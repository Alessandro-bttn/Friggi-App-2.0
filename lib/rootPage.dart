import 'package:flutter/material.dart';
import '../NewLocale/new_locale_page.dart';
import '../MonthPage/MonthPage.dart';
// Assicurati che questo import punti al tuo file preferences_service.dart
import '../../service/preferences_service.dart'; 

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  /// Controlla se l'utente ha già selezionato un locale salvato
  Future<bool> _haLocaleConfigurato() async {
    // Inizializza le preferences se necessario
    await PreferencesService().init();
    
    // Se idLocaleCorrente non è nullo, abbiamo un locale valido
    return PreferencesService().idLocaleCorrente != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _haLocaleConfigurato(), 
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

        // 1. Attesa (Loading)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Gestione Errori
        if (snapshot.hasError) {
           return Scaffold(
             body: Center(
               child: Text('Errore nel caricamento: ${snapshot.error}')
             )
           );
        }

        // 3. Decisione: Ha un locale?
        final bool haLocale = snapshot.data ?? false;

        if (haLocale) {
          return const MonthPage(); 
        } else {
          return const NewLocalePage(); 
        }
      },
    );
  }
}