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

  @override
  String get menu_titolo => 'Menu';

  @override
  String get menu_gestioneDipendenti => 'Employee Management';

  @override
  String get menu_statistiche => 'Statistics';

  @override
  String get menu_impostazioni => 'Settings';

  @override
  String get dipendenti_titolo => 'Employees';

  @override
  String get dipendenti_nessuno => 'No employees found';

  @override
  String get dipendenti_nuovo => 'New Employee';

  @override
  String get dipendenti_modifica => 'Edit Employee';

  @override
  String get label_nome => 'First Name';

  @override
  String get label_cognome => 'Last Name';

  @override
  String get label_ore => 'Planned Hours';

  @override
  String get label_colore => 'Identifying Color';

  @override
  String get msg_elimina_conferma => 'Do you want to delete this employee?';

  @override
  String get btn_annulla => 'Cancel';

  @override
  String get btn_conferma => 'Confirm';

  @override
  String get settings_titolo => 'Settings';

  @override
  String get settings_sez_aspetto => 'Appearance';

  @override
  String get settings_temaScuro => 'Dark Theme';

  @override
  String get settings_temaScuro_sub => 'Reduces eye strain';

  @override
  String get settings_sez_generale => 'General';

  @override
  String get settings_notifiche => 'Push Notifications';

  @override
  String get settings_notifiche_sub => 'Get shift updates';

  @override
  String get settings_lingua => 'Language';

  @override
  String get settings_lingua_dialog => 'Choose Language';

  @override
  String get settings_lingua_it => 'Italian';

  @override
  String get settings_lingua_en => 'English';

  @override
  String get settings_lingua_es => 'Spanish';

  @override
  String get settings_sez_info => 'Information';

  @override
  String get settings_versione => 'App Version';

  @override
  String get settings_privacy => 'Privacy Policy';

  @override
  String get settings_logout => 'Log Out';

  @override
  String get settings_turni_label => 'Number of Shifts';

  @override
  String get settings_turni_sub => 'Select the number of shifts per day';

  @override
  String get settings_turni_valore_1 => 'Single Shift (1)';

  @override
  String get settings_turni_valore_2 => 'Two Shifts (2)';

  @override
  String get settings_turni_valore_3 => 'Three Shifts (3)';

  @override
  String get settings_orari_label => 'Working Hours';

  @override
  String get settings_orario_inizio => 'Start';

  @override
  String get settings_orario_fine => 'End';
}
