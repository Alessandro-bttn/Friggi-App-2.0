import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart'; // Assicurati che il percorso sia corretto

// Import DB e Modelli
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Turni/TurniDB.dart';    
import '../DataBase/Turni/TurnoModel.dart'; 
import '../DataBase/Dipendente/DipendenteDB.dart'; 
import '../DataBase/Dipendente/DipendenteModel.dart';

import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// Widget della pagina
import 'widgets/timeline/day_timeline.dart'; 
import 'widgets/day_gesture_detector.dart';
import 'widgets/day_fab.dart';

// IMPORTA IL SERVIZIO DI NAVIGAZIONE
import '../CalanderNavigator/calendar_navigation.dart';

class DayPage extends StatefulWidget {
  final DateTime selectedDate; 

  const DayPage({super.key, required this.selectedDate});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  ItemModel? localeCorrente;
  bool isLoading = true;
  late DateTime currentDate;
  
  // Rimosso l'inizializzazione fissa di _currentView qui
  String? _currentView; 
  
  List<TurnoModel> _turniDelGiorno = []; 
  List<DipendenteModel> _dipendenti = []; 

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;
    
    final prefs = PreferencesService();
    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaDati(); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inizializziamo la vista corrente con la traduzione corretta
    _currentView ??= AppLocalizations.of(context)!.calendar_day;
  }

  Future<void> _caricaDati() async {
    setState(() => isLoading = true);
    final int? idLocale = PreferencesService().idLocaleCorrente;

    try {
      if (idLocale != null) {
        localeCorrente = await DBHelper().getItemById(idLocale);
        _dipendenti = await DipendenteDB().getDipendentiByLocale(idLocale);
      }
    } catch (e) { 
      debugPrint("Errore caricamento dati DayPage: $e"); 
    }

    await _aggiornaTurni();
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _aggiornaTurni() async {
    final turni = await TurniDB().getTurniDelGiorno(currentDate);
    if (mounted) {
      setState(() => _turniDelGiorno = turni);
    }
  }

  void _giornoSuccessivo() {
    setState(() {
      currentDate = currentDate.add(const Duration(days: 1));
      _aggiornaTurni(); 
    });
  }

  void _giornoPrecedente() {
    setState(() {
      currentDate = currentDate.subtract(const Duration(days: 1));
      _aggiornaTurni(); 
    });
  }

  void _handleViewChange(String targetViewLabel) {
    final l10n = AppLocalizations.of(context)!;
    
    // Aggiorniamo lo stato interno per far partire l'animazione nel ViewSelector
    setState(() => _currentView = targetViewLabel);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: targetViewLabel,
      currentView: l10n.calendar_day, // Usiamo la traduzione per il confronto
      referenceDate: currentDate,
      onReturn: () {
        if (mounted) {
          setState(() => _currentView = l10n.calendar_day); 
          _caricaDati(); 
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
        dataOggi: currentDate, 
        showDay: true, 
        currentView: _currentView ?? l10n.calendar_day,
        onViewChanged: _handleViewChange,
      ),

      body: DayGestureDetector(
        onSwipeNext: _giornoSuccessivo,
        onSwipePrev: _giornoPrecedente,
        // Traduzione anche qui per lo zoom out
        onZoomOut: () => _handleViewChange(l10n.calendar_week),
        
        child: DayTimeline(
          currentDate: currentDate,
          startTime: _startTime,
          endTime: _endTime,
          turni: _turniDelGiorno,
          dipendenti: _dipendenti,
        ), 
      ),

      floatingActionButton: DayPageFab(
        date: currentDate,
        onTurnoAdded: _aggiornaTurni, 
      ),
    );
  }
}