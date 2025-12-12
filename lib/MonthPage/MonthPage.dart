// File: lib/MonthPage/MonthPage.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; 

// IMPORTA I DATI
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';

// IMPORTA I WIDGET
import 'TopBar/month_app_bar.dart';
import 'calander/calendar_grid.dart';

// IMPORTA LA LOGICA APPENA CREATA
import 'logic/month_logic.dart'; 

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

  // --- FUNZIONI DI CAMBIO MESE ---
  void _vaiMeseSuccessivo() {
    setState(() {
      dataOggi = MonthLogic.getNextMonth(dataOggi);
    });
  }

  void _vaiMesePrecedente() {
    setState(() {
      dataOggi = MonthLogic.getPreviousMonth(dataOggi);
    });
  }
  // ------------------------------

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
        onMenuPressed: () {
          print("Menu cliccato");
        },
      ),

      // 2. GESTIONE SWIPE (GESTURE DETECTOR)
      // Avvolgiamo il corpo in un GestureDetector per sentire il dito
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          // primaryVelocity ci dice la velocità e la direzione dello swipe.
          // > 0 : Swipe verso destra (Da Sinistra a Destra) -> Vado indietro nel tempo
          // < 0 : Swipe verso sinistra (Da Destra a Sinistra) -> Vado avanti nel tempo
          
          if (details.primaryVelocity! > 0) {
            // Swipe Destra -> Mese Precedente
            _vaiMesePrecedente();
          } else if (details.primaryVelocity! < 0) {
            // Swipe Sinistra -> Mese Successivo
            _vaiMeseSuccessivo();
          }
        },
        // Il Container trasparente serve a catturare il tocco anche negli spazi vuoti
        child: Container(
          color: Colors.transparent, 
          width: double.infinity,
          height: double.infinity,
          child: CalendarGrid(meseCorrente: dataOggi),
        ),
      ),
      
    );
  }
}