import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

// IMPORTA I MODELLI E DB
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Locale/LocaleDB.dart';
import '../service/preferences_service.dart';

// IMPORTA I WIDGET
import '../MonthPage/TopBar/month_app_bar.dart';
import 'widgets/week_view.dart';
import '../widgets/calendar_gesture_detector.dart';

// LOGICA E NAVIGAZIONE
import 'logic/week_logic.dart';
import '../CalanderNavigator/calendar_navigation.dart';
import '../../main.dart';

class WeekPage extends StatefulWidget {
  final DateTime dataIniziale;

  const WeekPage({super.key, required this.dataIniziale});

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  ItemModel? localeCorrente;
  late DateTime currentWeekStart;
  String? _currentView;

  late int _divisions;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    currentWeekStart = WeekLogic.getStartOfWeek(widget.dataIniziale);
    
    final prefs = PreferencesService();
    _divisions = (prefs.divisioneTurni > 0) ? prefs.divisioneTurni : 2;
    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaLocale();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentView ??= AppLocalizations.of(context)!.calendar_week;
  }

  // Carichiamo solo il locale, i turni arrivano dal controller
  Future<void> _caricaLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      final locale = await DBHelper().getItemById(idLocale);
      if (mounted) setState(() => localeCorrente = locale);
    }
  }

  void _vaiSettimanaSuccessiva() {
    setState(() => currentWeekStart = WeekLogic.getNextWeek(currentWeekStart));
  }

  void _vaiSettimanaPrecedente() {
    setState(() => currentWeekStart = WeekLogic.getPreviousWeek(currentWeekStart));
  }

  void _handleViewChange(String targetViewLabel) {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _currentView = targetViewLabel);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: targetViewLabel,
      currentView: l10n.calendar_week,
      referenceDate: currentWeekStart,
      onReturn: () {
        if (mounted) setState(() => _currentView = l10n.calendar_week);
        // I dati si aggiornano da soli grazie al ListenableBuilder
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: turniController,
      builder: (context, child) {
        // Se il controller sta ancora caricando i dati iniziali
        if (turniController.isLoading && turniController.turni.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Filtriamo i turni della settimana corrente in memoria (istantaneo)
        final turniSettimana = turniController.turniDellaSettimana(currentWeekStart);

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
              onZoomOut: () => _handleViewChange(l10n.calendar_month), 
              onZoomIn: () => _handleViewChange(l10n.calendar_day), 
              child: WeekView(
                currentStartOfWeek: currentWeekStart,
                onDaySelected: (date) {
                  CalendarNavigationService.switchToView(
                    context: context,
                    targetView: l10n.calendar_day,
                    currentView: l10n.calendar_week,
                    referenceDate: date, 
                    onReturn: () {
                      // Il refresh è automatico
                    },
                  );
                },
                divisions: _divisions,
                startTime: _startTime,
                endTime: _endTime,
                allShifts: turniSettimana, // Dati filtrati in RAM
                dipendenti: turniController.dipendenti,
              ),
            ),
          ),
        );
      },
    );
  }
}