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

    final Color backgroundColor = isReadOnly
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);

    return Container(
      // Aumentiamo il padding verticale per riempire meglio lo spazio (da 16 a 24)
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), 
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20), // Angoli leggermente più curvi per M3
        border: Border.all(
          color: isReadOnly ? Colors.transparent : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          if (titolo != null && titolo!.isNotEmpty) ...[
            Text(
              titolo!.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuiamo meglio i campi
            children: [
              _buildTimeField(context, effectiveLabelInizio, inizio, true, l10n),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  size: 24, // Icona freccia leggermente più grande
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

    String displayTime;
    if (use24hFormat) {
      displayTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      displayTime = time.format(context);
    }

    return Expanded(
      child: InkWell(
        onTap: isReadOnly ? null : () => onPickTime(isStart),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Compattiamo la colonna
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith( // Testo label più grande (da labelMedium a titleMedium)
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8), // Più spazio tra label e orario
            Text(
              displayTime,
              style: theme.textTheme.headlineMedium?.copyWith( // Orario molto più grande (da headlineSmall a headlineMedium)
                fontWeight: FontWeight.bold,
                color: isReadOnly ? colorScheme.onSurface : colorScheme.primary,
                letterSpacing: -0.5,
              ),
            ),
            if (!isReadOnly)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.tocca_per_cambiare, 
                  style: theme.textTheme.bodySmall?.copyWith( // Testo aiuto leggermente più leggibile
                    color: colorScheme.primary.withValues(alpha: 0.7),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}