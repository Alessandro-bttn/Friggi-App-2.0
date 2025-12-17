import 'package:flutter/material.dart';

// --- IMPORT NECESSARI ---
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';
import '../MonthPage/TopBar/month_app_bar.dart'; 

// Importiamo il nuovo file con i widget grafici
import 'widgets/day_view.dart'; 

class DayPage extends StatefulWidget {
  final DateTime date;

  const DayPage({super.key, required this.date});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  ItemModel? localeCorrente;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
      print("Errore caricamento locale: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // 1. AppBar
      appBar: MonthAppBar(
        localeCorrente: localeCorrente,
        dataOggi: widget.date, 
      ),

      // 2. Corpo: Usiamo il widget separato per la Timeline
      body: const DayTimeline(),

      // 3. FAB: Usiamo il widget separato per il bottone
      floatingActionButton: DayPageFab(date: widget.date),
    );
  }
}