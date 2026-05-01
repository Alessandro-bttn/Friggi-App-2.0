import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

// MODELLI
import '../DataBase/Locale/LocaleModel.dart';

// SERVIZI (Aggiornati)
import '../service/locale_service.dart'; 
import '../service/preferences_service.dart';

// WIDGET
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
  LocaleModel? localeCorrente;
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

  // Carichiamo il locale tramite il nuovo servizio
  Future<void> _caricaLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      // UTILIZZO DEL SERVIZIO AL POSTO DEL VECCHIO DB
      final locale = await LocaleService().getLocaleById(idLocale);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: turniController,
      builder: (context, child) {
        if (turniController.isLoading && turniController.turni.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
                    onReturn: () {},
                  );
                },
                divisions: _divisions,
                startTime: _startTime,
                endTime: _endTime,
                allShifts: turniSettimana,
                dipendenti: turniController.dipendenti,
              ),
            ),
          ),
        );
      },
    );
  }
}