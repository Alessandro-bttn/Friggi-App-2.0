import 'package:flutter/material.dart';

// Import DB e Modelli
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Turni/TurniDB.dart';    
import '../DataBase/Turni/TurnoModel.dart'; 
// AGGIUNTO: Import per caricare i dipendenti
import '../DataBase/Dipendente/DipendenteDB.dart'; 
import '../DataBase/Dipendente/DipendenteModel.dart';

import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// AGGIUNTO: Import corretto verso la nuova cartella timeline
import 'widgets/timeline/day_timeline.dart'; 
import 'widgets/day_gesture_detector.dart';
import 'widgets/day_fab.dart';

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
  
  // Liste dati
  List<TurnoModel> _turniDelGiorno = []; 
  List<DipendenteModel> _dipendenti = []; // <--- NUOVO: Lista dipendenti per i nomi

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

  Future<void> _caricaDati() async {
    setState(() => isLoading = true);
    
    final int? idLocale = PreferencesService().idLocaleCorrente;

    // 1. Carica Locale
    try {
      if (idLocale != null) {
        localeCorrente = await DBHelper().getItemById(idLocale);
      }
    } catch (e) { print(e); }

    // 2. Carica Dipendenti (Serve per mostrare i nomi nelle barre)
    try {
      if (idLocale != null) {
        // Assicurati di avere questo metodo in DipendenteDB (come visto nei passaggi precedenti)
        _dipendenti = await DipendenteDB().getDipendentiByLocale(idLocale);
      }
    } catch (e) { print("Errore dipendenti: $e"); }

    // 3. Carica Turni del giorno corrente
    await _aggiornaTurni();

    if (mounted) setState(() => isLoading = false);
  }

  // Funzione specifica per ricaricare solo i turni (usata dopo il salvataggio)
  Future<void> _aggiornaTurni() async {
    final turni = await TurniDB().getTurniDelGiorno(currentDate);
    if (mounted) {
      setState(() {
        _turniDelGiorno = turni;
      });
    }
  }

  // LOGICA GESTI
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

  void _tornaAllaSettimana() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: currentDate, 
        showDay: true, 
      ),

      body: DayGestureDetector(
        onSwipeNext: _giornoSuccessivo,
        onSwipePrev: _giornoPrecedente,
        onZoomOut: _tornaAllaSettimana,
        
        child: DayTimeline(
          currentDate: currentDate,
          startTime: _startTime,
          endTime: _endTime,
          turni: _turniDelGiorno,
          dipendenti: _dipendenti, // <--- ORA PASSIAMO ANCHE I DIPENDENTI
        ), 
      ),

      floatingActionButton: DayPageFab(
        date: currentDate,
        onTurnoAdded: _aggiornaTurni, 
      ),
    );
  }
}