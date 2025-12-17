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
  late DateTime currentWeekStart; // Data di riferimento (Lunedì corrente)
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Impostiamo la data iniziale all'inizio della settimana cliccata
    currentWeekStart = WeekLogic.getStartOfWeek(widget.dataIniziale);
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
    Navigator.pop(context); // Chiude la WeekPage e torna al Mese
  }

  // --- AZIONE AL CLICK O ZOOM ---
  void _onGiornoSelezionato(DateTime dataSelezionata) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayPage(date: dataSelezionata),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // AppBar
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: currentWeekStart,
        // IMPORTANTE: showDay false perché qui mostriamo la settimana (es. "Dicembre 2025")
        showDay: false, 
      ),
      
      // Corpo con Gestione Gesture
      body: SafeArea(
        top: false,
        bottom: true,
        child: WeekGestureDetector(
          onSwipeNext: _vaiSettimanaSuccessiva,
          onSwipePrev: _vaiSettimanaPrecedente,
          onZoomOut: _tornaAlMese,
          
          // NUOVO: Zoom In apre il primo giorno della settimana (Lunedì)
          onZoomIn: () {
            _onGiornoSelezionato(currentWeekStart);
          },
          
          child: WeekView(
            currentStartOfWeek: currentWeekStart,
            onDaySelected: _onGiornoSelezionato, 
          ),
        ),
      ),
    );
  }
}