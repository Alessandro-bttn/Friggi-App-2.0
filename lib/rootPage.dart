import 'package:flutter/material.dart';
import 'DataBase/Locale/LocaleDB.dart'; // Assicurati di importare il DBHelper
import 'NewLocale/NewLocale.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  Future<bool> _checkDatabaseAndRows() async {
    // Chiamiamo il metodo che abbiamo appena creato nel DBHelper
    return await DBHelper().hasData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkDatabaseAndRows(), // Usiamo la nuova funzione
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // --- ZONA TEST: Scommenta la riga sotto per CANCELLARE il DB ---
        DBHelper().deleteDB(); 
        // ---------------------------------------------------------------
        
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
               child: Text('Errore nel caricamento DB: ${snapshot.error}')
             )
           );
        }
        // 3. Dati caricati
        final bool haDati = snapshot.data ?? false;

        if (haDati) {
          return const MonthPage(); 
        } else {
          return const NewLocale(); 
        }
      },
    );
  }
}
class MonthPage extends StatelessWidget {
  const MonthPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Mese")));
}

