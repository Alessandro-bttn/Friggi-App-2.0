import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'settings_components.dart';

class GeneralSection extends StatelessWidget {
  final bool notificationsEnabled;
  final String selectedLanguageCode;
  
  // NUOVI PARAMETRI
  final int shiftDivisions; // 0, 1, o 2
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final ValueChanged<bool> onNotificationChanged;
  final ValueChanged<String> onLanguageChanged;
  
  // NUOVE CALLBACK
  final ValueChanged<int> onShiftsChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;

  const GeneralSection({
    super.key,
    required this.notificationsEnabled,
    required this.selectedLanguageCode,
    required this.shiftDivisions,
    required this.startTime,
    required this.endTime,
    required this.onNotificationChanged,
    required this.onLanguageChanged,
    required this.onShiftsChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  // ... (Tieni i metodi _getLanguageLabel e _showLanguageDialog come prima) ...
  String _getLanguageLabel(String code, AppLocalizations l10n) { /* ... */ return ""; } 
  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) { /* ... */ }

  // Helper per mostrare il TimePicker
  Future<void> _pickTime(BuildContext context, TimeOfDay initial, ValueChanged<TimeOfDay> onSelected) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        // Opzionale: Forza il tema 24h se vuoi
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  // Helper per le label dello slider
  String _getShiftLabel(int value, AppLocalizations l10n) {
    switch (value) {
      case 0: return l10n.settings_turni_valore_1; // "Unico"
      case 1: return l10n.settings_turni_valore_2; // "Due Turni"
      case 2: return l10n.settings_turni_valore_3; // "Tre Turni"
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settings_sez_generale),
        SettingsCard(children: [
          
          // --- 1. NOTIFICHE ---
          SwitchListTile(
            title: Text(l10n.settings_notifiche),
            subtitle: Text(l10n.settings_notifiche_sub),
            secondary: const Icon(Icons.notifications_outlined),
            value: notificationsEnabled,
            onChanged: onNotificationChanged,
          ),
          const SettingsDivider(),

          // --- 2. LINGUA ---
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settings_lingua),
            subtitle: Text(_getLanguageLabel(selectedLanguageCode, l10n)), // Usa la tua funzione helper
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => _showLanguageDialog(context, l10n), // Usa la tua funzione helper
          ),
          const SettingsDivider(),

          // --- 3. DIVISIONE TURNI (Slider 0-2) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settings_turni_label, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  l10n.settings_turni_sub, 
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.layers_outlined, color: Colors.grey),
                    Expanded(
                      child: Slider(
                        value: shiftDivisions.toDouble(),
                        min: 0,
                        max: 2,
                        divisions: 2,
                        label: _getShiftLabel(shiftDivisions, l10n),
                        onChanged: (val) => onShiftsChanged(val.toInt()),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        _getShiftLabel(shiftDivisions, l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SettingsDivider(),

          // --- 4. ORARI DI LAVORO ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settings_orari_label, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Start Time
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.wb_sunny_outlined, size: 18),
                        label: Text("${l10n.settings_orario_inizio}: ${startTime.format(context)}"),
                        onPressed: () => _pickTime(context, startTime, onStartTimeChanged),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // End Time
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.nightlight_round, size: 18),
                        label: Text("${l10n.settings_orario_fine}: ${endTime.format(context)}"),
                        onPressed: () => _pickTime(context, endTime, onEndTimeChanged),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ]),
      ],
    );
  }
}