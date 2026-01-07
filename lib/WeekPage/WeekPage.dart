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

  // --- DATI DA PASSARE ALLA VISTA ---
  List<TurnoModel> _turniSettimana = [];
  List<DipendenteModel> _dipendenti = [];

  // --- VARIABILI PER I SETTAGGI ---
  late int _divisions;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    currentWeekStart = WeekLogic.getStartOfWeek(widget.dataIniziale);
    
    final prefs = PreferencesService();
    
    // --- CORREZIONE IMPORTANTE ---
    // Se prefs.divisioneTurni è 0 (default o errore), la griglia non viene disegnata.
    // Qui mettiamo un fallback: se è <= 0, usa 2 come default.
    int savedDivisions = prefs.divisioneTurni;
    _divisions = (savedDivisions > 0) ? savedDivisions : 2;

    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaDatiCompleti(); 
  }

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

      // 3. Carica Turni
      List<TurnoModel> tuttiITurni = await TurniDB().getTurni(); 
      print("DEBUG: Turni totali trovati nel DB: ${tuttiITurni.length}");
      
      DateTime weekEnd = currentWeekStart.add(const Duration(days: 7));

      // Filtra i turni della settimana corrente
      _turniSettimana = tuttiITurni.where((t) {
         // Logica: dataTurno >= inizioSettimana E dataTurno < fineSettimana
         // Usiamo subtract(1 day) per assicurarci di includere il lunedì anche se gli orari non coincidono perfettamente
         return t.data.isAfter(currentWeekStart.subtract(const Duration(days: 1))) && 
                t.data.isBefore(weekEnd);
      }).toList();

      print("DEBUG: Turni filtrati per questa settimana: ${_turniSettimana.length}");

    } catch (e) {
      debugPrint("Errore caricamento dati settimana: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

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

  void _tornaAlMese() {
    Navigator.pop(context); 
  }

  void _onGiornoSelezionato(DateTime dataSelezionata) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayPage(selectedDate: dataSelezionata),
      ),
    );
    // Al ritorno dalla pagina giorno, ricarichiamo i dati (magari hai aggiunto un turno)
    _caricaDatiCompleti(); 
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
          onZoomIn: () => _onGiornoSelezionato(currentWeekStart),
          
          child: WeekView(
            currentStartOfWeek: currentWeekStart,
            onDaySelected: _onGiornoSelezionato,
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