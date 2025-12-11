import 'package:flutter/material.dart';
import 'DataBase/Locale/LocaleDB.dart';
import 'NewLocale/NewLocale.dart';
import '../MonthPage/MonthPage.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  Future<bool> _checkDatabaseAndRows() async {
    // --- ZONA TEST: Scommenta QUI per CANCELLARE il DB ---
    // await DBHelper().deleteDB(); 
    // -----------------------------------------------------

    return await DBHelper().hasData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkDatabaseAndRows(), 
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
