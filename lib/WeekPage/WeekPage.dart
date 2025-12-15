import 'package:flutter/material.dart';
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// IMPORTA LA LOGICA E I WIDGET NUOVI
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
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      final locale = await DBHelper().getItemById(idLocale);
      setState(() {
        localeCorrente = locale;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
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
    Navigator.pop(context); // Chiude la WeekPage e torna sotto (MonthPage)
  }

  // --- AZIONE AL CLICK DEL GIORNO ---
  void _onGiornoSelezionato(DateTime dataSelezionata) {
    print("Hai cliccato il giorno: $dataSelezionata");
    // In futuro qui aprirai il dialog per aggiungere turni o vedere i dettagli
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // Riutilizziamo l'AppBar che mostra Mese/Anno e Locale
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        // Mostriamo il mese del Lunedì corrente
        dataOggi: currentWeekStart, 
      ),
      
      body: SafeArea(
        top: false,
        bottom: true,
        child: WeekGestureDetector(
          onSwipeNext: _vaiSettimanaSuccessiva,
          onSwipePrev: _vaiSettimanaPrecedente,
          onZoomOut: _tornaAlMese, 
          
          // La vista grafica della settimana
          child: WeekView(
            currentStartOfWeek: currentWeekStart,
            onDaySelected: _onGiornoSelezionato, 
          ),
        ),
      ),
    );
  }
}  