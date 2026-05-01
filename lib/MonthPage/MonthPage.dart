import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

// MODELLI E SERVIZI
import '../DataBase/Locale/LocaleModel.dart';
import '../service/locale_service.dart'; // <--- ASSICURATI DI QUESTO IMPORT
import '../service/preferences_service.dart';

// WIDGET
import 'TopBar/month_app_bar.dart';
import 'calander/calendar_grid.dart';
import 'widgets/app_drawer.dart';
import '../widgets/calendar_gesture_detector.dart';

// LOGICA E NAVIGAZIONE
import 'logic/month_logic.dart';
import '../Dipendenti/DipendentiPage.dart';
import '../SettingsPage/SettingsPage.dart';
import '../CalanderNavigator/calendar_navigation.dart';
import '../../main.dart'; 

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  LocaleModel? localeCorrente;
  DateTime dataOggi = DateTime.now();
  int _drawerSelectedIndex = 0;
  String? _currentView;

  @override
  void initState() {
    super.initState();
    _caricaLocale();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentView ??= AppLocalizations.of(context)!.calendar_month;
  }

  // Carichiamo il locale tramite il nuovo servizio
  Future<void> _caricaLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      // UTILIZZO DEL NUOVO SERVIZIO
      final locale = await LocaleService().getLocaleById(idLocale);
      if (mounted) setState(() => localeCorrente = locale);
    }
  }

  void _vaiMeseSuccessivo() {
    setState(() => dataOggi = MonthLogic.getNextMonth(dataOggi));
  }

  void _vaiMesePrecedente() {
    setState(() => dataOggi = MonthLogic.getPreviousMonth(dataOggi));
  }

  void _handleViewChange(String targetViewLabel) {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _currentView = targetViewLabel);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: targetViewLabel,
      currentView: l10n.calendar_month,
      referenceDate: dataOggi,
      onReturn: () {
        if (mounted) {
          setState(() => _currentView = l10n.calendar_month);
        }
      },
    );
  }

  void _apriWeekPage() {
    _handleViewChange(AppLocalizations.of(context)!.calendar_week);
  }

  void _onDrawerItemTapped(int index) {
    setState(() => _drawerSelectedIndex = index);
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DipendentiPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: turniController,
      builder: (context, child) {
        if (turniController.isLoading && turniController.turni.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final turniMese = turniController.turniDelMese(dataOggi);

        return Scaffold(
          appBar: MonthAppBar(
            localeCorrente: localeCorrente,
            dataOggi: dataOggi,
            currentView: _currentView ?? l10n.calendar_month,
            onViewChanged: _handleViewChange,
          ),
          drawer: AppDrawer(
            selectedIndex: _drawerSelectedIndex,
            onDestinationSelected: _onDrawerItemTapped,
          ),
          body: CalendarGestureDetector(
            onSwipePrev: _vaiMesePrecedente,
            onSwipeNext: _vaiMeseSuccessivo,
            onZoomIn: _apriWeekPage,
            child: CalendarGrid(
              meseCorrente: dataOggi,
              turniDelMese: turniMese,
              dipendenti: turniController.dipendenti,
            ),
          ),
        );
      },
    );
  }
}