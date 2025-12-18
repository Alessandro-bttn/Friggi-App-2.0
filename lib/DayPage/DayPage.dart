import 'package:flutter/material.dart';

// Import vari
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// Import dei widget separati
import 'widgets/day_view.dart';            // La grafica (Timeline + FAB)
import 'widgets/day_gesture_detector.dart'; // Il file dei gesti

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
    // ... (Logica caricamento locale invariata) ...
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

  // --- LOGICA GESTI (Invariata) ---
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
        
        // 2. PASSIAMO DATA E ORARI ALLA TIMELINE
        child: DayTimeline(
          currentDate: currentDate,
          startTime: _startTime, // Passiamo l'inizio (es. 09:00)
          endTime: _endTime,     // Passiamo la fine (es. 18:00)
        ), 
      ),

      floatingActionButton: DayPageFab(date: currentDate),
    );
  }
}