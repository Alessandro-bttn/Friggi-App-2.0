import 'package:flutter/material.dart';

class ShiftTimeEditor extends StatelessWidget {
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final bool isEditing;
  final Function(TimeOfDay, TimeOfDay) onChanged;

  const ShiftTimeEditor({
    super.key,
    required this.inizio,
    required this.fine,
    required this.isEditing,
    required this.onChanged,
  });

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? inizio : fine,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (picked != null) {
      if (isStart) {
        onChanged(picked, fine);
      } else {
        onChanged(inizio, picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEditing ? colorScheme.primaryContainer.withOpacity(0.3) : colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: isEditing ? Border.all(color: colorScheme.primary, width: 2) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTimeBox(context, "Inizio", inizio, Icons.login, true),
          Icon(Icons.arrow_forward, color: colorScheme.primary, size: 20),
          _buildTimeBox(context, "Fine", fine, Icons.logout, false),
        ],
      ),
    );
  }

  Widget _buildTimeBox(BuildContext context, String label, TimeOfDay time, IconData icon, bool isStart) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: isEditing ? () => _pickTime(context, isStart) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            ),
            Text(
              time.format(context),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isEditing ? theme.colorScheme.primary : null,
              ),
            ),
            if (isEditing)
              Text("Cambia", style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}