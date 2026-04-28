import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final String? titolo;
  final String? labelInizio;
  final String? labelFine;
  final Function(bool isStart) onPickTime;
  final bool isReadOnly;
  final bool use24hFormat; // Nuova prop per decidere il formato

  const TimeRangeSelector({
    super.key,
    required this.inizio,
    required this.fine,
    required this.onPickTime,
    this.titolo,
    this.labelInizio,
    this.labelFine,
    this.isReadOnly = false,
    this.use24hFormat = true, // Default a true per le 24h
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final String effectiveLabelInizio = labelInizio ?? l10n.turni_label_inizio;
    final String effectiveLabelFine = labelFine ?? l10n.turni_label_fine;
    final String effectiveTitolo = titolo ?? l10n.turni_orario_titolo;

    final Color backgroundColor = isReadOnly
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReadOnly ? Colors.transparent : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Text(
            effectiveTitolo.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTimeField(context, effectiveLabelInizio, inizio, true, l10n),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
              _buildTimeField(context, effectiveLabelFine, fine, false, l10n),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(BuildContext context, String label, TimeOfDay time, bool isStart, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // --- LOGICA FORMATTAZIONE 24H ---
    String displayTime;
    if (use24hFormat) {
      final String hour = time.hour.toString().padLeft(2, '0');
      final String minute = time.minute.toString().padLeft(2, '0');
      displayTime = "$hour:$minute";
    } else {
      displayTime = time.format(context); // Formato AM/PM basato sul sistema
    }

    return Expanded(
      child: InkWell(
        onTap: isReadOnly ? null : () => onPickTime(isStart),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displayTime, // Visualizza l'orario formattato
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isReadOnly ? colorScheme.onSurface : colorScheme.primary,
                ),
              ),
              if (!isReadOnly)
                Text(
                  l10n.tocca_per_cambiare, 
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: colorScheme.primary.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}