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

  @override
  String get settings_titolo => 'Impostazioni';

  @override
  String get settings_sez_aspetto => 'Aspetto';

  @override
  String get settings_temaScuro => 'Tema Scuro';

  @override
  String get settings_temaScuro_sub => 'Riduci l\'affaticamento degli occhi';

  @override
  String get settings_sez_generale => 'Generale';

  @override
  String get settings_notifiche => 'Notifiche Push';

  @override
  String get settings_notifiche_sub => 'Ricevi aggiornamenti sui turni';

  @override
  String get settings_lingua => 'Lingua';

  @override
  String get settings_lingua_dialog => 'Scegli la lingua';

  @override
  String get settings_lingua_it => 'Italiano';

  @override
  String get settings_lingua_en => 'Inglese';

  @override
  String get settings_lingua_es => 'Spagnolo';

  @override
  String get settings_sez_info => 'Informazioni';

  @override
  String get settings_versione => 'Versione App';

  @override
  String get settings_privacy => 'Privacy Policy';

  @override
  String get settings_logout => 'Esci dall\'account';

  @override
  String get settings_turni_label => 'Suddivisione Giornata';

  @override
  String get settings_turni_sub => 'Numero di turni giornalieri';

  @override
  String get settings_turni_valore_1 => 'Unico (1)';

  @override
  String get settings_turni_valore_2 => 'Due Turni (2)';

  @override
  String get settings_turni_valore_3 => 'Tre Turni (3)';

  @override
  String get settings_orari_label => 'Orari di Lavoro';

  @override
  String get settings_orario_inizio => 'Inizio';

  @override
  String get settings_orario_fine => 'Fine';
}
