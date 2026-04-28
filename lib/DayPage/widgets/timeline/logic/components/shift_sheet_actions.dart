import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../DataBase/Turni/TurnoModel.dart';
import '../../../../../notifications/notification_service.dart';
import '../../../../widgets/add_turno_dialog/logic/turni_validator.dart';

class ShiftSheetActions extends StatelessWidget {
  final TurnoModel turno;
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final bool isEditing;
  final bool hasChanges;
  final Function(bool) onEditToggle;
  final VoidCallback onReset;

  const ShiftSheetActions({
    super.key,
    required this.turno,
    required this.inizio,
    required this.fine,
    required this.isEditing,
    required this.hasChanges,
    required this.onEditToggle,
    required this.onReset,
  });

  Future<void> _handleSave(BuildContext context) async {
    final bool valido = await TurniValidator.isTurnoValido(
      context: context,
      idDipendente: turno.idDipendente,
      data: turno.data,
      inizio: inizio,
      fine: fine,
    );

    if (valido) {
      // Inserire qui update DB
      NotificationService().showSuccess("Turno aggiornato");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (!isEditing) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text("Elimina"),
              style: OutlinedButton.styleFrom(foregroundColor: colorScheme.error),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => onEditToggle(true),
              icon: const Icon(Icons.edit_outlined),
              label: const Text("Modifica"),
            ),
          ),
        ] else ...[
          Expanded(
            child: TextButton(
              onPressed: () {
                onReset();
                onEditToggle(false);
              },
              child: const Text("Annulla"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: hasChanges ? () => _handleSave(context) : null,
              icon: const Icon(Icons.check),
              label: const Text("Salva"),
            ),
          ),
        ],
      ],
    );
  }
}