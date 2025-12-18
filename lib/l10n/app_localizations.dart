import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Gestione Spese'**
  String get appTitle;

  /// No description provided for @btnSalva.
  ///
  /// In it, this message translates to:
  /// **'SALVA E CONTINUA'**
  String get btnSalva;

  /// No description provided for @lingua_seleziona.
  ///
  /// In it, this message translates to:
  /// **'Seleziona Lingua'**
  String get lingua_seleziona;

  /// No description provided for @lingua_nome.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get lingua_nome;

  /// No description provided for @newLocale_titolo.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Locale'**
  String get newLocale_titolo;

  /// No description provided for @newLocale_nomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome Locale'**
  String get newLocale_nomeLabel;

  /// No description provided for @newLocale_fotoHint.
  ///
  /// In it, this message translates to:
  /// **'Tocca per scegliere foto'**
  String get newLocale_fotoHint;

  /// No description provided for @newLocale_successo.
  ///
  /// In it, this message translates to:
  /// **'Locale creato con successo!'**
  String get newLocale_successo;

  /// No description provided for @ruolo_label.
  ///
  /// In it, this message translates to:
  /// **'Responsabile/Dipendente'**
  String get ruolo_label;

  /// No description provided for @ruolo_dipendente.
  ///
  /// In it, this message translates to:
  /// **'Dipendente'**
  String get ruolo_dipendente;

  /// No description provided for @ruolo_responsabile.
  ///
  /// In it, this message translates to:
  /// **'Responsabile'**
  String get ruolo_responsabile;

  /// No description provided for @error_campiMancanti.
  ///
  /// In it, this message translates to:
  /// **'Inserisci Nome se Responsabile/Dipendente'**
  String get error_campiMancanti;

  /// No description provided for @error_erroreSalvataggio.
  ///
  /// In it, this message translates to:
  /// **'Errore durante il salvataggio del locale'**
  String get error_erroreSalvataggio;

  /// No description provided for @calendar_mon.
  ///
  /// In it, this message translates to:
  /// **'Lun'**
  String get calendar_mon;

  /// No description provided for @calendar_tue.
  ///
  /// In it, this message translates to:
  /// **'Mar'**
  String get calendar_tue;

  /// No description provided for @calendar_wed.
  ///
  /// In it, this message translates to:
  /// **'Mer'**
  String get calendar_wed;

  /// No description provided for @calendar_thu.
  ///
  /// In it, this message translates to:
  /// **'Gio'**
  String get calendar_thu;

  /// No description provided for @calendar_fri.
  ///
  /// In it, this message translates to:
  /// **'Ven'**
  String get calendar_fri;

  /// No description provided for @calendar_sat.
  ///
  /// In it, this message translates to:
  /// **'Sab'**
  String get calendar_sat;

  /// No description provided for @calendar_sun.
  ///
  /// In it, this message translates to:
  /// **'Dom'**
  String get calendar_sun;

  /// No description provided for @menu_titolo.
  ///
  /// In it, this message translates to:
  /// **'Menu'**
  String get menu_titolo;

  /// No description provided for @menu_gestioneDipendenti.
  ///
  /// In it, this message translates to:
  /// **'Gestione Dipendenti'**
  String get menu_gestioneDipendenti;

  /// No description provided for @menu_statistiche.
  ///
  /// In it, this message translates to:
  /// **'Statistiche'**
  String get menu_statistiche;

  /// No description provided for @menu_impostazioni.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get menu_impostazioni;

  /// No description provided for @dipendenti_titolo.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti'**
  String get dipendenti_titolo;

  /// No description provided for @dipendenti_nessuno.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente trovato'**
  String get dipendenti_nessuno;

  /// No description provided for @dipendenti_nuovo.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Dipendente'**
  String get dipendenti_nuovo;

  /// No description provided for @dipendenti_modifica.
  ///
  /// In it, this message translates to:
  /// **'Modifica Dipendente'**
  String get dipendenti_modifica;

  /// No description provided for @label_nome.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get label_nome;

  /// No description provided for @label_cognome.
  ///
  /// In it, this message translates to:
  /// **'Cognome'**
  String get label_cognome;

  /// No description provided for @label_ore.
  ///
  /// In it, this message translates to:
  /// **'Ore Previste'**
  String get label_ore;

  /// No description provided for @label_colore.
  ///
  /// In it, this message translates to:
  /// **'Colore Identificativo'**
  String get label_colore;

  /// No description provided for @msg_elimina_conferma.
  ///
  /// In it, this message translates to:
  /// **'Vuoi eliminare questo dipendente?'**
  String get msg_elimina_conferma;

  /// No description provided for @btn_annulla.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get btn_annulla;

  /// No description provided for @btn_conferma.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get btn_conferma;

  /// No description provided for @settings_titolo.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings_titolo;

  /// No description provided for @settings_sez_aspetto.
  ///
  /// In it, this message translates to:
  /// **'Aspetto'**
  String get settings_sez_aspetto;

  /// No description provided for @settings_temaScuro.
  ///
  /// In it, this message translates to:
  /// **'Tema Scuro'**
  String get settings_temaScuro;

  /// No description provided for @settings_temaScuro_sub.
  ///
  /// In it, this message translates to:
  /// **'Riduci l\'affaticamento degli occhi'**
  String get settings_temaScuro_sub;

  /// No description provided for @settings_sez_generale.
  ///
  /// In it, this message translates to:
  /// **'Generale'**
  String get settings_sez_generale;

  /// No description provided for @settings_notifiche.
  ///
  /// In it, this message translates to:
  /// **'Notifiche Push'**
  String get settings_notifiche;

  /// No description provided for @settings_notifiche_sub.
  ///
  /// In it, this message translates to:
  /// **'Ricevi aggiornamenti sui turni'**
  String get settings_notifiche_sub;

  /// No description provided for @settings_lingua.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get settings_lingua;

  /// No description provided for @settings_lingua_dialog.
  ///
  /// In it, this message translates to:
  /// **'Scegli la lingua'**
  String get settings_lingua_dialog;

  /// No description provided for @settings_lingua_it.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get settings_lingua_it;

  /// No description provided for @settings_lingua_en.
  ///
  /// In it, this message translates to:
  /// **'Inglese'**
  String get settings_lingua_en;

  /// No description provided for @settings_lingua_es.
  ///
  /// In it, this message translates to:
  /// **'Spagnolo'**
  String get settings_lingua_es;

  /// No description provided for @settings_sez_info.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get settings_sez_info;

  /// No description provided for @settings_versione.
  ///
  /// In it, this message translates to:
  /// **'Versione App'**
  String get settings_versione;

  /// No description provided for @settings_privacy.
  ///
  /// In it, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy;

  /// No description provided for @settings_logout.
  ///
  /// In it, this message translates to:
  /// **'Esci dall\'account'**
  String get settings_logout;

  /// No description provided for @settings_turni_label.
  ///
  /// In it, this message translates to:
  /// **'Suddivisione Giornata'**
  String get settings_turni_label;

  /// No description provided for @settings_turni_sub.
  ///
  /// In it, this message translates to:
  /// **'Numero di turni giornalieri'**
  String get settings_turni_sub;

  /// No description provided for @settings_turni_valore_1.
  ///
  /// In it, this message translates to:
  /// **'Unico (1)'**
  String get settings_turni_valore_1;

  /// No description provided for @settings_turni_valore_2.
  ///
  /// In it, this message translates to:
  /// **'Due Turni (2)'**
  String get settings_turni_valore_2;

  /// No description provided for @settings_turni_valore_3.
  ///
  /// In it, this message translates to:
  /// **'Tre Turni (3)'**
  String get settings_turni_valore_3;

  /// No description provided for @settings_orari_label.
  ///
  /// In it, this message translates to:
  /// **'Orari di Lavoro'**
  String get settings_orari_label;

  /// No description provided for @settings_orario_inizio.
  ///
  /// In it, this message translates to:
  /// **'Inizio'**
  String get settings_orario_inizio;

  /// No description provided for @settings_orario_fine.
  ///
  /// In it, this message translates to:
  /// **'Fine'**
  String get settings_orario_fine;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
