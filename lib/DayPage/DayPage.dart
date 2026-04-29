import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

// IMPORT DB E MODELLI
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Turni/TurnoModel.dart';
import '../DataBase/Dipendente/DipendenteModel.dart';

import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart';

// WIDGET
import 'widgets/timeline/day_timeline.dart';
import '../widgets/calendar_gesture_detector.dart';
import 'widgets/day_fab.dart';
import '../DayPage/widgets/timeline/logic/shift_detail_sheet.dart';

// NAVIGAZIONE E PROVIDER
import '../CalanderNavigator/calendar_navigation.dart';
import '../../main.dart'; 

class DayPage extends StatefulWidget {
  final DateTime selectedDate;

  const DayPage({super.key, required this.selectedDate});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  ItemModel? localeCorrente;
  late DateTime currentDate;
  String? _currentView;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;

    final prefs = PreferencesService();
    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;

    _caricaLocale();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentView ??= AppLocalizations.of(context)!.calendar_day;
  }

  // Carichiamo solo i dati del locale (il resto è nel provider)
  Future<void> _caricaLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      try {
        final locale = await DBHelper().getItemById(idLocale);
        if (mounted) setState(() => localeCorrente = locale);
      } catch (e) {
        debugPrint("Errore caricamento locale: $e");
      }
    }
  }

  void _giornoSuccessivo() {
    setState(() => currentDate = currentDate.add(const Duration(days: 1)));
  }

  void _giornoPrecedente() {
    setState(() => currentDate = currentDate.subtract(const Duration(days: 1)));
  }

  void _handleViewChange(String targetViewLabel) {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _currentView = targetViewLabel);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: targetViewLabel,
      currentView: l10n.calendar_day,
      referenceDate: currentDate,
      onReturn: () {
        if (mounted) setState(() => _currentView = l10n.calendar_day);
        // Non serve ricaricare i turni, il provider si aggiorna da solo
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Usiamo ListenableBuilder per rendere la pagina reattiva al provider
    return ListenableBuilder(
      listenable: turniController,
      builder: (context, child) {
        // Se il provider sta caricando e la RAM è vuota
        if (turniController.isLoading && turniController.turni.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Filtriamo i turni del giorno direttamente dalla memoria
        final turniGiorno = turniController.turniDelGiorno(currentDate);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: MonthAppBar(
            localeCorrente: localeCorrente,
            dataOggi: currentDate,
            showDay: true,
            currentView: _currentView ?? l10n.calendar_day,
            onViewChanged: _handleViewChange,
          ),
          body: CalendarGestureDetector(
            onSwipeNext: _giornoSuccessivo,
            onSwipePrev: _giornoPrecedente,
            onZoomOut: () => _handleViewChange(l10n.calendar_week),
            child: DayTimeline(
              currentDate: currentDate,
              startTime: _startTime,
              endTime: _endTime,
              turni: turniGiorno, // Dati dal provider
              dipendenti: turniController.dipendenti, // Dati dal provider
              onTurnoTap: showShiftDetails,
            ),
          ),
          floatingActionButton: DayPageFab(
            date: currentDate,
            // Passiamo l'azione al provider (non serve callback di refresh)
            onTurnoAdded: (nuovoTurno) => turniController.aggiungiTurno(nuovoTurno),
          ),
        );
      },
    );
  }

  Future<void> showShiftDetails(TurnoModel turno, DipendenteModel? dipendente) async {
    HapticFeedback.selectionClick();

    // Quando apriamo il foglio, le azioni interne (salva/elimina)
    // dovranno chiamare turniController.aggiornaTurno o eliminaTurno
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShiftDetailSheet(
        turno: turno,
        dipendente: dipendente,
      ),
    );
    
    // NOTA: Non serve più fare if(refreshNeeded) { _aggiornaTurni() }
    // perché il provider notifica il cambiamento e il build sopra si riesegue da solo.
  }
}