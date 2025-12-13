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

  @override
  String get menu_titolo => 'Menu';

  @override
  String get menu_gestioneDipendenti => 'Gestione Dipendenti';

  @override
  String get menu_statistiche => 'Statistiche';

  @override
  String get menu_impostazioni => 'Impostazioni';

  @override
  String get dipendenti_titolo => 'Dipendenti';

  @override
  String get dipendenti_nessuno => 'Nessun dipendente trovato';

  @override
  String get dipendenti_nuovo => 'Nuovo Dipendente';

  @override
  String get dipendenti_modifica => 'Modifica Dipendente';

  @override
  String get label_nome => 'Nome';

  @override
  String get label_cognome => 'Cognome';

  @override
  String get label_ore => 'Ore Previste';

  @override
  String get label_colore => 'Colore Identificativo';

  @override
  String get msg_elimina_conferma => 'Vuoi eliminare questo dipendente?';

  @override
  String get btn_annulla => 'Annulla';

  @override
  String get btn_conferma => 'Conferma';
}
