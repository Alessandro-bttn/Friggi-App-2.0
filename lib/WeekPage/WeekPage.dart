import 'package:flutter/material.dart';

// --- IMPORT NECESSARI ---
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Turni/TurnoModel.dart'; 
import '../DataBase/Turni/TurniDB.dart';      
import '../DataBase/Dipendente/DipendenteModel.dart'; 
import '../DataBase/Dipendente/DipendenteDB.dart';     

import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

import '../DayPage/DayPage.dart'; 
import 'logic/week_logic.dart';
import 'widgets/week_view.dart';
import 'widgets/week_gesture_detector.dart';

// IMPORTA IL SERVIZIO DI NAVIGAZIONE
import '../CalanderNavigator/calendar_navigation.dart'; 

class WeekPage extends StatefulWidget {
  final DateTime dataIniziale;

  const WeekPage({super.key, required this.dataIniziale});

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  // --- STATO ---
  ItemModel? localeCorrente;
  late DateTime currentWeekStart;
  bool isLoading = true;
  String _currentView = 'Settimana';

  // --- DATI ---
  List<TurnoModel> _turniSettimana = [];
  List<DipendenteModel> _dipendenti = [];

  // --- IMPOSTAZIONI ---
  late int _divisions;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    // Inizializza la data all'inizio della settimana (es. Lunedì)
    currentWeekStart = WeekLogic.getStartOfWeek(widget.dataIniziale);
    
    final prefs = PreferencesService();
    
    // Fallback per le divisioni (minimo 1 per evitare crash)
    int savedDivisions = prefs.divisioneTurni;
    _divisions = (savedDivisions > 0) ? savedDivisions : 2;

    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaDatiCompleti(); 
  }

  // --- CARICAMENTO DATI ---
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

      // 3. Carica e Filtra Turni
      List<TurnoModel> tuttiITurni = await TurniDB().getTurni(); 
      DateTime weekEnd = currentWeekStart.add(const Duration(days: 7));

      _turniSettimana = tuttiITurni.where((t) {
        return t.data.isAfter(currentWeekStart.subtract(const Duration(seconds: 1))) && 
               t.data.isBefore(weekEnd);
      }).toList();

    } catch (e) {
      debugPrint("Errore caricamento dati settimana: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // --- NAVIGAZIONE INTERNA (SWIPE) ---
  void _vaiSettimanaSuccessiva() {
    setState(() {
      currentWeekStart = WeekLogic.getNextWeek(currentWeekStart);
      _caricaDatiCompleti();
    });
  }

  void _vaiSettimanaPrecedente() {
    setState(() {
      currentWeekStart = WeekLogic.getPreviousWeek(currentWeekStart);
      _caricaDatiCompleti();
    });
  }

  // --- LOGICA DI CAMBIO VISTA (BOTTONI TOP BAR) ---
  void _handleViewChange(String newView) {
    setState(() => _currentView = newView);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: newView,
      currentView: 'Settimana',
      referenceDate: currentWeekStart,
      onReturn: () {
        if (mounted) {
          setState(() => _currentView = 'Settimana');
          _caricaDatiCompleti();
        }
      },
    );
  }

  void _onGiornoSelezionato(DateTime dataSelezionata) {
    // Navighiamo al giorno specifico usando il servizio direttamente
    CalendarNavigationService.switchToView(
      context: context,
      targetView: 'Giorno',
      currentView: 'Settimana',
      referenceDate: dataSelezionata, // <--- Usiamo la data cliccata, non l'inizio settimana
      onReturn: () {
        if (mounted) {
          setState(() => _currentView = 'Settimana');
          _caricaDatiCompleti();
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: currentWeekStart,
        showDay: false, 
        currentView: _currentView,
        onViewChanged: _handleViewChange,
      ),
      
      body: SafeArea(
        top: false,
        bottom: true,
        child: WeekGestureDetector(
          onSwipeNext: _vaiSettimanaSuccessiva,
          onSwipePrev: _vaiSettimanaPrecedente,
          onZoomOut: () => _handleViewChange('Mese'), 
          onZoomIn: () => _handleViewChange('Giorno'), 
          
          child: WeekView(
            currentStartOfWeek: currentWeekStart,
            onDaySelected: (date) {
              // Quando selezioni un giorno specifico, navighiamo lì
              CalendarNavigationService.switchToView(
                context: context,
                targetView: 'Giorno',
                currentView: 'Settimana',
                referenceDate: date, // Passiamo la data esatta cliccata
                onReturn: () {
                  if (mounted) _caricaDatiCompleti();
                },
              );
            },
            divisions: _divisions,
            startTime: _startTime,
            endTime: _endTime,
            allShifts: _turniSettimana,
            dipendenti: _dipendenti,
          ),
        ),
      ),
    );
  }
}