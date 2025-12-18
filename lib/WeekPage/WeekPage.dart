import 'package:flutter/material.dart';

// --- IMPORT NECESSARI ---
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// Import della DayPage
import '../DayPage/DayPage.dart'; 

// Import della logica e widget della settimana
import 'logic/week_logic.dart';
import 'widgets/week_view.dart';
import 'widgets/week_gesture_detector.dart';

class WeekPage extends StatefulWidget {
  final DateTime dataIniziale;

  const WeekPage({super.key, required this.dataIniziale});

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  ItemModel? localeCorrente;
  late DateTime currentWeekStart;
  bool isLoading = true;

  // --- VARIABILI PER I SETTAGGI ---
  late int _divisions;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    currentWeekStart = WeekLogic.getStartOfWeek(widget.dataIniziale);
    
    // 1. CARICAMENTO DATI PREFERENZE (Sincrono per semplicità di UI)
    final prefs = PreferencesService();
    _divisions = prefs.divisioneTurni;
    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaDatiLocale();
  }

  Future<void> _caricaDatiLocale() async {
    try {
      final int? idLocale = PreferencesService().idLocaleCorrente;
      if (idLocale != null) {
        final locale = await DBHelper().getItemById(idLocale);
        if (mounted) {
          setState(() {
            localeCorrente = locale;
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- NAVIGAZIONE ---
  void _vaiSettimanaSuccessiva() {
    setState(() {
      currentWeekStart = WeekLogic.getNextWeek(currentWeekStart);
    });
  }

  void _vaiSettimanaPrecedente() {
    setState(() {
      currentWeekStart = WeekLogic.getPreviousWeek(currentWeekStart);
    });
  }

  void _tornaAlMese() {
    Navigator.pop(context); 
  }

  void _onGiornoSelezionato(DateTime dataSelezionata) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayPage(selectedDate: dataSelezionata),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: currentWeekStart,
        showDay: false, 
      ),
      
      body: SafeArea(
        top: false,
        bottom: true,
        child: WeekGestureDetector(
          onSwipeNext: _vaiSettimanaSuccessiva,
          onSwipePrev: _vaiSettimanaPrecedente,
          onZoomOut: _tornaAlMese,
          onZoomIn: () {
            _onGiornoSelezionato(currentWeekStart);
          },
          
          // 2. PASSIAMO I DATI AL WEEKVIEW
          child: WeekView(
            currentStartOfWeek: currentWeekStart,
            onDaySelected: _onGiornoSelezionato,
            divisions: _divisions, // Passiamo divisioni
            startTime: _startTime, // Passiamo inizio
            endTime: _endTime,     // Passiamo fine
          ),
        ),
      ),
    );
  }
}