// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get titoloApp => 'Gestione Spese';

  @override
  String get nuovoLocale => 'Nuovo Locale';

  @override
  String get nomeLocale => 'Nome Locale';

  @override
  String get scattaFoto => 'Tocca per scegliere foto';

  @override
  String get salva => 'SALVA E CONTINUA';

  @override
  String get cambiaLingua => 'English';

  @override
  String get selezionaLingua => 'Seleziona Lingua';

  @override
  String get responsabileDipendente => 'Responsabile/Dipendente';

  @override
  String get erroreCampi => 'Inserisci Nome se Responsabile/Dipendente';
}
