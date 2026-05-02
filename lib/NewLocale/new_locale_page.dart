import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../notifications/notification_service.dart';
import '../../MonthPage/MonthPage.dart';
import 'new_locale_logic.dart'; // Importa la logica separata

enum LocaleMode { create, join }

class NewLocalePage extends StatefulWidget {
  const NewLocalePage({super.key});

  @override
  State<NewLocalePage> createState() => _NewLocalePageState();
}

class _NewLocalePageState extends State<NewLocalePage> {
  // Controller per i campi di testo
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _codiceController = TextEditingController();

  LocaleMode _mode = LocaleMode.create;
  bool _isLoading = false;

  @override
  void dispose() {
    // Importante: pulire i controller per evitare memory leak
    _nomeController.dispose();
    _codiceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      if (_mode == LocaleMode.create) {
        // --- LOGICA CREAZIONE ---
        if (_nomeController.text.trim().isEmpty)
          throw "Inserisci un nome valido";

        // Chiamiamo la logica separata
        String codice =
            await NewLocaleLogic.salvaLocale(nome: _nomeController.text.trim());
        NotificationService().showSuccess("Locale creato! Codice: $codice");
      } else {
        // Qui devi chiamare ESATTAMENTE il nome definito sopra
        if (_codiceController.text.trim().isEmpty) throw "Inserisci il codice";

        // Assicurati che sia 'accediLocale' (senza underscore o nomi diversi)
        await NewLocaleLogic.accediLocale(
            codice: _codiceController.text.trim());

        NotificationService().showSuccess("Accesso effettuato!");
      }

      // Navigazione sicura
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MonthPage()),
        );
      }
    } catch (e) {
      NotificationService().showError("Errore: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(testo.newLocale_titolo)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Selettore Crea vs Accedi
            SegmentedButton<LocaleMode>(
              segments: const [
                ButtonSegment(
                    value: LocaleMode.create, label: Text("Crea Locale")),
                ButtonSegment(
                    value: LocaleMode.join, label: Text("Accedi Locale")),
              ],
              selected: {_mode},
              onSelectionChanged: (newSelection) =>
                  setState(() => _mode = newSelection.first),
            ),

            const SizedBox(height: 40),

            // TextField dinamico in base alla modalità
            if (_mode == LocaleMode.create)
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome del nuovo locale",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
              )
            else
              TextField(
                controller: _codiceController,
                decoration: const InputDecoration(
                  labelText: "Inserisci codice invito",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                ),
                textCapitalization: TextCapitalization.characters,
              ),

            const SizedBox(height: 30),

            // Pulsante Azione
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(_mode == LocaleMode.create
                          ? "Crea Locale"
                          : "Accedi"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
