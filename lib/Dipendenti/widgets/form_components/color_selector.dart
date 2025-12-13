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

  // Lista colori (spostata qui)
  static const List<Color> _coloriDisponibili = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
    Colors.brown, Colors.grey, Colors.blueGrey, Colors.black
  ];

  // Funzione per aprire il selettore avanzato
  void _apriSelettoreAvanzato(BuildContext context) {
    Color coloreTemp = selectedColor;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Seleziona un colore'),
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
              child: const Text('Annulla'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: const Text('Seleziona'),
              onPressed: () {
                onColorChanged(coloreTemp); // Notifica il cambio
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
    final testo = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Intestazione Sezione Colore
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(testo.label_colore, style: const TextStyle(fontWeight: FontWeight.bold)),
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

        // Lista Orizzontale
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // A. Colori Predefiniti
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

              // B. Bottone "Altro..."
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