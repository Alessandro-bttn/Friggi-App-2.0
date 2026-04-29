import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart'; // Assicurati che il percorso sia corretto

// --- IMPORT NECESSARI ---
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Turni/TurnoModel.dart'; 
import '../DataBase/Turni/TurniDB.dart';      
import '../DataBase/Dipendente/DipendenteModel.dart'; 
import '../DataBase/Dipendente/DipendenteDB.dart';     

import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

import 'logic/week_logic.dart';
import 'widgets/week_view.dart';
import '../widgets/calendar_gesture_detector.dart';

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
  
  // Inizializzato come null, verrà impostato correttamente con l10n
  String? _currentView;

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
    currentWeekStart = WeekLogic.getStartOfWeek(widget.dataIniziale);
    
    final prefs = PreferencesService();
    
    int savedDivisions = prefs.divisioneTurni;
    _divisions = (savedDivisions > 0) ? savedDivisions : 2;

    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaDatiCompleti(); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Impostiamo la vista corrente usando la localizzazione (Settimana)
    _currentView ??= AppLocalizations.of(context)!.calendar_week;
  }

  // --- CARICAMENTO DATI ---
  Future<void> _caricaDatiCompleti() async {
    try {
      if (mounted) setState(() => isLoading = true);

      final int? idLocale = PreferencesService().idLocaleCorrente;
      if (idLocale != null) {
        localeCorrente = await DBHelper().getItemById(idLocale);
      }

      _dipendenti = await DipendenteDB().getAllDipendenti(); 

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
  void _handleViewChange(String targetViewLabel) {
    final l10n = AppLocalizations.of(context)!;
    
    // Aggiornamento visivo immediato per l'animazione della barra
    setState(() => _currentView = targetViewLabel);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: targetViewLabel,
      currentView: l10n.calendar_week, // Passiamo la traduzione corretta
      referenceDate: currentWeekStart,
      onReturn: () {
        if (mounted) {
          setState(() => _currentView = l10n.calendar_week);
          _caricaDatiCompleti();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        currentView: _currentView ?? l10n.calendar_week,
        onViewChanged: _handleViewChange,
      ),
      
      body: SafeArea(
        top: false,
        bottom: true,
        child: CalendarGestureDetector(
          onSwipeNext: _vaiSettimanaSuccessiva,
          onSwipePrev: _vaiSettimanaPrecedente,
          // Allineamento con l10n per le gesture di zoom
          onZoomOut: () => _handleViewChange(l10n.calendar_month), 
          onZoomIn: () => _handleViewChange(l10n.calendar_day), 
          
          child: WeekView(
            currentStartOfWeek: currentWeekStart,
            onDaySelected: (date) {
              // Navigazione al giorno specifico
              CalendarNavigationService.switchToView(
                context: context,
                targetView: l10n.calendar_day, // Tradotto
                currentView: l10n.calendar_week, // Tradotto
                referenceDate: date, 
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