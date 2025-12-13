import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../logic/dipendenti_logic.dart';

// IMPORTA I NUOVI WIDGET
import 'form_components/dipendente_inputs.dart';
import 'form_components/color_selector.dart';

class DipendenteForm extends StatefulWidget {
  final DipendenteModel? dipendenteEsistente; 

  const DipendenteForm({super.key, this.dipendenteEsistente});

  @override
  State<DipendenteForm> createState() => _DipendenteFormState();
}

class _DipendenteFormState extends State<DipendenteForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers per gli input
  final _nomeController = TextEditingController();
  final _cognomeController = TextEditingController();
  
  // Stato del colore
  late Color _coloreSelezionato;

  @override
  void initState() {
    super.initState();
    if (widget.dipendenteEsistente != null) {
      _nomeController.text = widget.dipendenteEsistente!.nome;
      _cognomeController.text = widget.dipendenteEsistente!.cognome ?? '';
      _coloreSelezionato = Color(widget.dipendenteEsistente!.colore);
    } else {
      _coloreSelezionato = Colors.red; // Default semplice, la lista è nel widget figlio
    }
  }

  void _salva() async {
    if (_formKey.currentState!.validate()) {
      await DipendentiLogic.salvaDipendente(
        id: widget.dipendenteEsistente?.id,
        nome: _nomeController.text,
        cognome: _cognomeController.text.isEmpty ? null : _cognomeController.text,
        ore: 0.0, 
        coloreValue: _coloreSelezionato.value,
      );
      if (mounted) Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            // TITOLO
            Text(
              widget.dipendenteEsistente == null ? testo.dipendenti_nuovo : testo.dipendenti_modifica,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            
            // 1. COMPONENTE INPUT (Nome, Cognome)
            DipendenteInputs(
              nomeController: _nomeController,
              cognomeController: _cognomeController,
            ),
            
            const SizedBox(height: 15),

            // 2. COMPONENTE SELETTORE COLORE
            ColorSelector(
              selectedColor: _coloreSelezionato,
              onColorChanged: (newColor) {
                // Aggiorniamo lo stato qui nel genitore
                setState(() {
                  _coloreSelezionato = newColor;
                });
              },
            ),
            
            const SizedBox(height: 20),

            // BOTTONE SALVA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salva,
                child: Text(testo.btnSalva),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}