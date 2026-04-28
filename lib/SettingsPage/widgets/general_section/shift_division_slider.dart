import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class ShiftDivisionSlider extends StatelessWidget {
  final int divisions;
  final ValueChanged<int> onChanged;

  const ShiftDivisionSlider({
    super.key,
    required this.divisions,
    required this.onChanged,
  });

  String _getShiftLabel(int value, AppLocalizations l10n) {
    if (value == 0) return l10n.settings_turni_valore_1;
    if (value == 1) return l10n.settings_turni_valore_2;
    return l10n.settings_turni_valore_3;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settings_turni_label, style: theme.textTheme.titleMedium),
          Text(l10n.settings_turni_sub, style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.layers_outlined),
              Expanded(
                child: Slider(
                  value: divisions.toDouble(),
                  min: 0, max: 2, divisions: 2,
                  onChanged: (val) => onChanged(val.toInt()),
                ),
              ),
              Badge(
                label: Text(_getShiftLabel(divisions, l10n)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: theme.colorScheme.primaryContainer,
                textColor: theme.colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}