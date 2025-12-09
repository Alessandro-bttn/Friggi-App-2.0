// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titoloApp => 'Expense Manager';

  @override
  String get nuovoLocale => 'New Place';

  @override
  String get nomeLocale => 'Place Name';

  @override
  String get scattaFoto => 'Tap to pick photo';

  @override
  String get salva => 'SAVE AND CONTINUE';

  @override
  String get cambiaLingua => 'Italiano';

  @override
  String get selezionaLingua => 'Select Language';

  @override
  String get responsabileDipendente => 'Manager/Employee';

  @override
  String get erroreCampi => 'Enter Name if Manager/Employee';
}
