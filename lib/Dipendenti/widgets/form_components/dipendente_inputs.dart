import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class DipendenteInputs extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController cognomeController;

  const DipendenteInputs({
    super.key,
    required this.nomeController,
    required this.cognomeController,
  });

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    return Column(
      children: [
        // NOME
        TextFormField(
          controller: nomeController,
          decoration: InputDecoration(
            labelText: testo.label_nome, 
            border: const OutlineInputBorder()
          ),
          validator: (value) => value!.isEmpty ? testo.error_campiMancanti : null,
        ),
        const SizedBox(height: 10),
        
        // COGNOME
        TextFormField(
          controller: cognomeController,
          decoration: InputDecoration(
            labelText: testo.label_cognome, 
            border: const OutlineInputBorder()
          ),
        ),
      ],
    );
  }
}