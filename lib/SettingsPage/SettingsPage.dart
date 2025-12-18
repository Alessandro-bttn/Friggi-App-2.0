import 'package:flutter/material.dart';
// IMPORT GENERATO PER LE TRADUZIONI
import '../l10n/app_localizations.dart'; 

// IMPORT DEI SERVIZI E DEL MAIN
import '../service/preferences_service.dart';
import '../../main.dart'; // Fondamentale per accedere a languageController e themeNotifier

// WIDGETS
import 'widgets/appearance_section.dart';
import 'widgets/general_section.dart';
import 'widgets/info_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // --- STATO DELLA PAGINA ---
  late bool _isDarkMode;
  late bool _notificationsEnabled;
  late String _selectedLanguageCode;
  
  // NUOVI STATI PER I SETTAGGI AGGIUNTI
  late int _shiftDivisions;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    // 1. CARICAMENTO DATI ALL'AVVIO
    final prefs = PreferencesService();

    _isDarkMode = prefs.temaScuro;
    _selectedLanguageCode = prefs.lingua ?? 'it'; // Default Italiano
    _notificationsEnabled = true; // TODO: Salvare nelle prefs se necessario

    // Carichiamo i nuovi valori salvati
    _shiftDivisions = prefs.divisioneTurni;
    _startTime = prefs.orarioInizio;
    _endTime = prefs.orarioFine;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings_titolo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // Nota: withValues è disponibile dalle versioni recenti di Flutter, 
      // altrimenti usa .withOpacity(0.05)
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          
          // 1. SEZIONE ASPETTO
          AppearanceSection(
            isDarkMode: _isDarkMode,
            onThemeChanged: (val) {
              setState(() => _isDarkMode = val);
              
              // 1. Salva nel database locale
              PreferencesService().temaScuro = val;
              
              // 2. Aggiorna l'app in tempo reale usando il Notifier globale
              themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
            },
          ),

          // 2. SEZIONE GENERALE (Aggiornata con i nuovi parametri)
          GeneralSection(
            notificationsEnabled: _notificationsEnabled,
            selectedLanguageCode: _selectedLanguageCode,
            
            // Passiamo i valori correnti per i nuovi settaggi
            shiftDivisions: _shiftDivisions,
            startTime: _startTime,
            endTime: _endTime,

            // Callback Notifiche
            onNotificationChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
            
            // Callback Lingua
            onLanguageChanged: (langCode) {
              setState(() => _selectedLanguageCode = langCode);
              // Cambia lingua globalmente (aggiorna anche le prefs internamente al controller)
              languageController.changeLanguage(Locale(langCode));
            },

            // Callback Numero Turni
            onShiftsChanged: (val) {
              setState(() => _shiftDivisions = val);
              PreferencesService().divisioneTurni = val;
            },

            // Callback Orario Inizio
            onStartTimeChanged: (val) {
              setState(() => _startTime = val);
              PreferencesService().orarioInizio = val;
            },

            // Callback Orario Fine
            onEndTimeChanged: (val) {
              setState(() => _endTime = val);
              PreferencesService().orarioFine = val;
            },
          ),

          // 3. SEZIONE INFO
          const InfoSection(),

          const SizedBox(height: 30),

          // 4. LOGOUT
          TextButton(
            onPressed: () {
              // TODO: Logica Logout
              print("Logout eseguito");
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.settings_logout),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}