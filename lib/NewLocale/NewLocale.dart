import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; 
import '../notifications/notification_service.dart';
import 'widgets/save.dart'; 
import '../../MonthPage/MonthPage.dart';

class NewLocale extends StatefulWidget {
  const NewLocale({super.key});

  @override
  State<NewLocale> createState() => _NewLocaleState();
}

class _NewLocaleState extends State<NewLocale> {
  final TextEditingController _nomeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _onSavePressed() async {
    final testo = AppLocalizations.of(context)!;

    // 1. Validazione
    if (_nomeController.text.trim().isEmpty) {
      NotificationService().showError("Inserisci almeno il nome del locale");
      return;
    }

    setState(() => _isLoading = true);

    // 2. Chiamata alla logica
    try {
      await NewLocaleLogic.salvaLocale(
        nome: _nomeController.text.trim(),
      );

      NotificationService().showSuccess(testo.newLocale_successo);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MonthPage()),
        );
      }
    } catch (e) {
      NotificationService().showError("Errore salvataggio: $e");
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: testo.newLocale_nomeLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _onSavePressed,
                    child: Text(testo.btnSalva),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}