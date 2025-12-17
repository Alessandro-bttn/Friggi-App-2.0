import 'package:flutter/material.dart';

// Import vari
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// Import dei widget separati
import 'widgets/day_view.dart';            // La grafica (Timeline + FAB)
import 'widgets/day_gesture_detector.dart'; //  Il nuovo file dei gesti

class DayPage extends StatefulWidget {
  final DateTime date; // Data iniziale passata dal calendario

  const DayPage({super.key, required this.date});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  ItemModel? localeCorrente;
  bool isLoading = true;
  
  // Questa variabile terrà traccia del giorno visualizzato
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = widget.date; // Inizializziamo con la data ricevuta
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
    // Chiude la pagina corrente (DayPage) tornando a quella sotto (WeekPage)
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // ... imports invariati ...

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

      // ... resto del body (DayGestureDetector, Timeline, FAB) invariato ...
      body: DayGestureDetector(
        onSwipeNext: _giornoSuccessivo,
        onSwipePrev: _giornoPrecedente,
        onZoomOut: _tornaAllaSettimana,
        child: const DayTimeline(), 
      ),

      floatingActionButton: DayPageFab(date: currentDate),
    );
  }
}