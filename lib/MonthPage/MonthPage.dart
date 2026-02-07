import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

// IMPORTA I DATI
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
// IMPORTA I MODELLI E DB MANCANTI
import '../DataBase/Turni/TurnoModel.dart';
import '../DataBase/Turni/TurniDB.dart';
import '../DataBase/Dipendente/DipendenteModel.dart';
import '../DataBase/Dipendente/DipendenteDB.dart';

import '../service/preferences_service.dart';
import '../WeekPage/WeekPage.dart';

// IMPORTA I WIDGET
import 'TopBar/month_app_bar.dart';
import 'calander/calendar_grid.dart';
import 'widgets/app_drawer.dart';

//  IMPORTA IL NUOVO WIDGET GESTURE
import 'widgets/month_gesture_detector.dart';

// IMPORTA LA LOGICA
import 'logic/month_logic.dart';
import '../Dipendenti/DipendentiPage.dart';

// IMPORTA ALTRE PAGINE
import '../SettingsPage/SettingsPage.dart';

// PAGINA PRINCIPALE DEL MESE

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  // --- STATO ---
  ItemModel? localeCorrente;
  bool isLoading = true;
  DateTime dataOggi = DateTime.now(); // Questo funge da "_currentMonth"
  int _drawerSelectedIndex = 0;
  bool _isNavigating = false;

  // --- DATI PER IL CALENDARIO ---
  List<TurnoModel> _turni = [];
  List<DipendenteModel> _dipendenti = [];

  // --- INIZIALIZZAZIONE ---
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it_IT', null).then((_) {
      _caricaDatiCompleti(); // Carichiamo tutto insieme
    });
  }

  // Funzione unica per caricare Locale, Dipendenti e Turni
  Future<void> _caricaDatiCompleti() async {
    try {
      setState(() => isLoading = true);

      // 1. Carica Locale
      final int? idLocale = PreferencesService().idLocaleCorrente;
      if (idLocale != null) {
        localeCorrente = await DBHelper().getItemById(idLocale);
      }

      // 2. Carica Dipendenti
      _dipendenti = await DipendenteDB().getAllDipendenti();

      // 3. Carica Turni (Tutti, o ottimizza caricando solo quelli del mese se preferisci)
      // Per ora carichiamo tutto per semplicità, come nella WeekPage
      _turni = await TurniDB().getTurni();

    } catch (e) {
      debugPrint("Errore caricamento dati mese: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // --- LOGICA DI NAVIGAZIONE ---
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

  // --- FUNZIONE PER APRIRE LA SETTIMANA ---
  void _apriWeekPage() {
    if (_isNavigating) return;

    _isNavigating = true;

    // 1. Definiamo quale data passare alla pagina settimanale
    DateTime now = DateTime.now();
    DateTime targetDate;

    // Controlliamo se il mese che stiamo guardando (dataOggi) è lo stesso mese reale di oggi
    if (dataOggi.year == now.year && dataOggi.month == now.month) {
      // CASO A: Siamo nel mese corrente -> Apri la settimana di OGGI
      targetDate = now;
    } else {
      // CASO B: Siamo in un altro mese -> Apri la PRIMA settimana di quel mese
      // (Assicuriamoci di prendere il 1° del mese visualizzato)
      targetDate = DateTime(dataOggi.year, dataOggi.month, 1);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        // Passiamo la data calcolata
        builder: (context) => WeekPage(dataIniziale: targetDate),
      ),
    ).then((_) {
      _isNavigating = false;
      // Ricarichiamo i dati al ritorno, nel caso siano stati modificati nella WeekPage
      _caricaDatiCompleti();
    });
  }

  void _onDrawerItemTapped(int index) {
    setState(() {
      _drawerSelectedIndex = index;
    });

    switch (index) {
      case 0:
        // Sei già nella Home, non fare nulla o ricarica
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const DipendentiPage()));
        break;
      case 2:
        // StatistichePage (da fare)
        break;
      case 3:
        // APRE LA PAGINA IMPOSTAZIONI
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        break;
    }
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // AppBar
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
      ),

      // Menu Laterale
      drawer: AppDrawer(
        selectedIndex: _drawerSelectedIndex,
        onDestinationSelected: _onDrawerItemTapped,
      ),

      // Corpo con Gestione Gesture separata
      body: MonthGestureDetector(
        onSwipePrev: _vaiMesePrecedente,
        onSwipeNext: _vaiMeseSuccessivo,
        onZoomIn: _apriWeekPage,
        
        // Passiamo i dati caricati alla griglia
        child: CalendarGrid(
          meseCorrente: dataOggi, 
          turniDelMese: _turni, 
          dipendenti: _dipendenti, 
        ),
      ),
    );
  }
}