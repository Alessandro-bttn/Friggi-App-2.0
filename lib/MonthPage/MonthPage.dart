import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../l10n/app_localizations.dart'; // Assicurati che il percorso sia corretto

// IMPORTA I DATI
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../DataBase/Turni/TurnoModel.dart';
import '../DataBase/Turni/TurniDB.dart';
import '../DataBase/Dipendente/DipendenteModel.dart';
import '../DataBase/Dipendente/DipendenteDB.dart';

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

// IMPORTA IL SERVIZIO DI NAVIGAZIONE
import '../CalanderNavigator/calendar_navigation.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  // --- STATO ---
  ItemModel? localeCorrente;
  bool isLoading = true;
  DateTime dataOggi = DateTime.now(); 
  int _drawerSelectedIndex = 0;
  bool _isNavigating = false;
  
  // Inizializzato come null, verrà impostato nel didChangeDependencies o build
  String? _currentView;

  List<TurnoModel> _turni = [];
  List<DipendenteModel> _dipendenti = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it_IT', null).then((_) {
      _caricaDatiCompleti();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Impostiamo la vista corrente usando la localizzazione
    _currentView ??= AppLocalizations.of(context)!.calendar_month;
  }

  Future<void> _caricaDatiCompleti() async {
    try {
      if (mounted) setState(() => isLoading = true);

      final int? idLocale = PreferencesService().idLocaleCorrente;
      if (idLocale != null) {
        localeCorrente = await DBHelper().getItemById(idLocale);
      }

      _dipendenti = await DipendenteDB().getAllDipendenti();
      _turni = await TurniDB().getTurni();
    } catch (e) {
      debugPrint("Errore caricamento dati mese: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _vaiMeseSuccessivo() {
    setState(() {
      dataOggi = MonthLogic.getNextMonth(dataOggi);
    });
  }

  void _vaiMesePrecedente() {
    setState(() {
      dataOggi = MonthLogic.getPreviousMonth(dataOggi);
    });
  }

  // --- LOGICA DI CAMBIO VISTA (SERVIZIO CENTRALIZZATO) ---
  void _handleViewChange(String targetViewLabel) {
    final l10n = AppLocalizations.of(context)!;
    
    // Aggiorniamo lo stato interno per l'animazione del ViewSelector
    setState(() => _currentView = targetViewLabel);

    CalendarNavigationService.switchToView(
      context: context,
      targetView: targetViewLabel,
      currentView: l10n.calendar_month, // "Mese" localizzato
      referenceDate: dataOggi,
      onReturn: () {
        if (mounted) {
          setState(() => _currentView = l10n.calendar_month);
          _caricaDatiCompleti();
        }
      },
    );
  }

  // --- ZOOM IN (Pinch o Gesture per andare alla settimana) ---
  void _apriWeekPage() {
    if (_isNavigating) return;
    final l10n = AppLocalizations.of(context)!;
    
    // Usiamo il servizio centralizzato anche per le gesture di zoom
    _handleViewChange(l10n.calendar_week);
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

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
        // Fallback sul l10n se _currentView fosse nullo
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
        onZoomIn: _apriWeekPage, // Mese -> Settimana

        child: CalendarGrid(
          meseCorrente: dataOggi,
          turniDelMese: _turni,
          dipendenti: _dipendenti,
        ),
      ),
    );
  }
}