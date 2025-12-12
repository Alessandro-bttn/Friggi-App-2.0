// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expense Manager';

  @override
  String get btnSalva => 'SAVE AND CONTINUE';

  @override
  String get lingua_seleziona => 'Select Language';

  @override
  String get lingua_nome => 'English';

  @override
  String get newLocale_titolo => 'New Place';

  @override
  String get newLocale_nomeLabel => 'Place Name';

  @override
  String get newLocale_fotoHint => 'Tap to pick photo';

  @override
  String get newLocale_successo => 'Place created successfully!';

  @override
  String get ruolo_label => 'Manager/Employee';

  @override
  String get ruolo_dipendente => 'Employee';

  @override
  String get ruolo_responsabile => 'Manager';

  @override
  String get error_campiMancanti => 'Enter Name if Manager/Employee';

  @override
  String get error_erroreSalvataggio => 'Error saving the place';

  @override
  String get calendar_mon => 'Mon';

  @override
  String get calendar_tue => 'Tue';

  @override
  String get calendar_wed => 'Wed';

  @override
  String get calendar_thu => 'Thu';

  @override
  String get calendar_fri => 'Fri';

  @override
  String get calendar_sat => 'Sat';

  @override
  String get calendar_sun => 'Sun';
}
