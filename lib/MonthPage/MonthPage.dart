import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

// IMPORTA I DATI E MODELLI
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Locale/LocaleDB.dart';
import '../service/preferences_service.dart';

// IMPORTA I WIDGET
import 'TopBar/month_app_bar.dart';
import 'calander/calendar_grid.dart';
import 'widgets/app_drawer.dart';
import '../widgets/calendar_gesture_detector.dart';

// IMPORTA LA LOGICA E ALTRE PAGINE
import 'logic/month_logic.dart';
import '../Dipendenti/DipendentiPage.dart';
import '../SettingsPage/SettingsPage.dart';

// IMPORTA IL SERVIZIO DI NAVIGAZIONE E IL CONTROLLER GLOBALE
import '../CalanderNavigator/calendar_navigation.dart';
import '../../main.dart'; 

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  // --- STATO LOCALE (Solo UI e Navigazione) ---
  ItemModel? localeCorrente;
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

  // Carichiamo solo il locale, i turni sono gestiti dal turniController
  Future<void> _caricaLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale != null) {
      final locale = await DBHelper().getItemById(idLocale);
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
          // Non serve ricaricare i dati qui, il ListenableBuilder lo farà da solo
          // se i dati nel controller sono cambiati.
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
        // Se il controller sta caricando e non abbiamo ancora dati in RAM
        if (turniController.isLoading && turniController.turni.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Filtraggio istantaneo in memoria
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