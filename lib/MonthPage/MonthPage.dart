// File: lib/MonthPage/MonthPage.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; 

// IMPORTA I DATI
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';

// IMPORTA I TUOI NUOVI WIDGET
import 'TopBar/month_app_bar.dart';
import 'calander/calendar_grid.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  ItemModel? localeCorrente;
  bool isLoading = true;
  DateTime dataOggi = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it_IT', null).then((_) {
      _caricaDatiLocale();
    });
  }

  Future<void> _caricaDatiLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;

    if (idLocale != null) {
      final locale = await DBHelper().getItemById(idLocale);
      setState(() {
        localeCorrente = locale;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // 1. APP BAR ESTERNALIZZATA
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
        onMenuPressed: () {
          // Logica per aprire il drawer
          print("Menu cliccato");
        },
      ),

      // 2. CORPO ESTERNALIZZATO
      body: const CalendarGrid(),
      
    );
  }
}