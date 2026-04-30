import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../l10n/app_localizations.dart';

class ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  // Palette ottimizzata: colori molto distinguibili tra loro
  static const List<Color> _coloriDisponibili = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.grey,
  ];

  void _apriSelettoreAvanzato(BuildContext context) {
    // Recuperiamo l10n qui perché il Dialog è un nuovo contesto
    final l10n = AppLocalizations.of(context)!;
    Color coloreTemp = selectedColor;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(l10n.titolo_selettore_colore), // KEY L10N
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) => coloreTemp = color,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.btn_annulla.toUpperCase()), // KEY L10N
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: Text(l10n.btn_seleziona.toUpperCase()), // KEY L10N
              onPressed: () {
                onColorChanged(coloreTemp);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.label_colore, style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor)
              ),
            )
          ],
        ),
        const SizedBox(height: 8),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._coloriDisponibili.map((colore) {
                return GestureDetector(
                  onTap: () => onColorChanged(colore),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: colore,
                      shape: BoxShape.circle,
                      border: selectedColor == colore 
                          ? Border.all(color: theme.colorScheme.onSurface, width: 3) 
                          : null,
                    ),
                    child: selectedColor == colore 
                        ? const Icon(Icons.check, color: Colors.white, size: 20) 
                        : null,
                  ),
                );
              }),

              // Bottone "Personalizzato"
              GestureDetector(
                onTap: () => _apriSelettoreAvanzato(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dividerColor, width: 1),
                  ),
                  child: Icon(Icons.add, color: theme.iconTheme.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}