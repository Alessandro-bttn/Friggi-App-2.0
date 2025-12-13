import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; 

// IMPORTA I DATI
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../Dipendenti/DipendentiPage.dart';

// IMPORTA I WIDGET
import 'TopBar/month_app_bar.dart';
import 'calander/calendar_grid.dart';
import 'widgets/app_drawer.dart';

// IMPORTA LA LOGICA
import 'logic/month_logic.dart'; 

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  // ... (variabili di stato: localeCorrente, isLoading, dataOggi... RIMANGONO UGUALI)
  ItemModel? localeCorrente;
  bool isLoading = true;
  DateTime dataOggi = DateTime.now();
  // Aggiungiamo un indice per sapere in che pagina siamo nel menu (0 = Calendario)
  int _drawerSelectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it_IT', null).then((_) {
      _caricaDatiLocale();
    });
  }

  // ... (funzioni _caricaDatiLocale, _vaiMeseSuccessivo... RIMANGONO UGUALI)
  Future<void> _caricaDatiLocale() async {
      // ... (codice esistente) ...
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


  // --- NUOVA FUNZIONE PER GESTIRE I CLICK NEL MENU ---
void _onDrawerItemTapped(int index) {
    // Chiudi il menu grafico se vuoi, ma Navigator.pop nel drawer lo ha già fatto
    setState(() {
      _drawerSelectedIndex = index;
    });

    switch (index) {
      case 0:
        // Siamo già nella Home, non facciamo nulla
        break;
        
      case 1:
        // NAVIGAZIONE STACK (Supporta Swipe Back)
        Navigator.push(
          context,
          // MaterialPageRoute include già le animazioni native di iOS/Android
          MaterialPageRoute(builder: (context) => const DipendentiPage()),
        );
        break;
        
      case 2:
        // Esempio per Statistiche
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const StatistichePage()));
        break;
        
      case 3:
        // Esempio per Impostazioni
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ImpostazioniPage()));
        break;
    }
  }
  // --------------------------------------------------


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // 1. APP BAR (Aggiornata senza onMenuPressed)
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
        // onMenuPressed è stato rimosso
      ),

      // 2. AGGIUNGI IL DRAWER QUI
      drawer: AppDrawer(
        selectedIndex: _drawerSelectedIndex,
        onDestinationSelected: _onDrawerItemTapped,
      ),

      // 3. CORPO GESTURE DETECTOR (Rimane uguale)
      body: GestureDetector(
         onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            _vaiMesePrecedente();
          } else if (details.primaryVelocity! < 0) {
            _vaiMeseSuccessivo();
          }
        },
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