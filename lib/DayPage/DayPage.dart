import 'package:flutter/material.dart';

// Import vari
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// --- IMPORT CORRETTI ---
import 'widgets/day_view.dart';            // Contiene SOLO DayTimeline
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

  // --- NUOVE VARIABILI PER GLI ORARI ---
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;
    
    // 1. CARICAMENTO ORARI DALLE PREFERENZE
    final prefs = PreferencesService();
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

  // --- LOGICA GESTI ---
  void _giornoSuccessivo() {
    setState(() {
      currentDate = currentDate.add(const Duration(days: 1));
    });
  }

  void _giornoPrecedente() {
    setState(() {
      currentDate = currentDate.subtract(const Duration(days: 1));
    });
  }

  void _tornaAllaSettimana() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
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
        
        // TIMELINE
        child: DayTimeline(
          currentDate: currentDate,
          startTime: _startTime,
          endTime: _endTime,
        ), 
      ),

      // IL FAB ORA VIENE DAL NUOVO FILE IMPORTATO
      floatingActionButton: DayPageFab(date: currentDate),
    );
  }
}