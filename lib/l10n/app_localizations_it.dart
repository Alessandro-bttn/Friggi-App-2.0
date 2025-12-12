// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Gestione Spese';

  @override
  String get btnSalva => 'SALVA E CONTINUA';

  @override
  String get lingua_seleziona => 'Seleziona Lingua';

  @override
  String get lingua_nome => 'Italiano';

  @override
  String get newLocale_titolo => 'Nuovo Locale';

  @override
  String get newLocale_nomeLabel => 'Nome Locale';

  @override
  String get newLocale_fotoHint => 'Tocca per scegliere foto';

  @override
  String get newLocale_successo => 'Locale creato con successo!';

  @override
  String get ruolo_label => 'Responsabile/Dipendente';

  @override
  String get ruolo_dipendente => 'Dipendente';

  @override
  String get ruolo_responsabile => 'Responsabile';

  @override
  String get error_campiMancanti => 'Inserisci Nome se Responsabile/Dipendente';

  @override
  String get error_erroreSalvataggio =>
      'Errore durante il salvataggio del locale';

  @override
  String get calendar_mon => 'Lun';

  @override
  String get calendar_tue => 'Mar';

  @override
  String get calendar_wed => 'Mer';

  @override
  String get calendar_thu => 'Gio';

  @override
  String get calendar_fri => 'Ven';

  @override
  String get calendar_sat => 'Sab';

  @override
  String get calendar_sun => 'Dom';
}
