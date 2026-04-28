import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../settings_components.dart';
import 'language_selector_tile.dart';
import 'shift_division_slider.dart';
import 'work_hours_selector.dart';

class GeneralSection extends StatelessWidget {
  final bool notificationsEnabled;
  final String selectedLanguageCode;
  final int shiftDivisions;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final ValueChanged<bool> onNotificationChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<int> onShiftsChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;
  final bool use24hFormat;

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
    required this.use24hFormat,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settings_sez_generale),
        SettingsCard(children: [
          // 1. NOTIFICHE
          SwitchListTile(
            title: Text(l10n.settings_notifiche),
            subtitle: Text(l10n.settings_notifiche_sub),
            secondary: const Icon(Icons.notifications_outlined),
            value: notificationsEnabled,
            onChanged: onNotificationChanged,
          ),
          const SettingsDivider(),

          // 2. LINGUA
          LanguageSelectorTile(
            selectedCode: selectedLanguageCode,
            onLanguageChanged: onLanguageChanged,
          ),
          const SettingsDivider(),

          // 3. DIVISIONE TURNI
          ShiftDivisionSlider(
            divisions: shiftDivisions,
            onChanged: onShiftsChanged,
          ),
          const SettingsDivider(),

          // 4. ORARI DI LAVORO
          WorkHoursSelector(
            startTime: startTime,
            endTime: endTime,
            onStartChanged: onStartTimeChanged,
            onEndChanged: onEndTimeChanged,
            use24hFormat: use24hFormat,
          ),
        ]),
      ],
    );
  }
}