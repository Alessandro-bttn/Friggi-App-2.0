import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 

// IMPORTA LE LINGUE
import '../l10n/app_localizations.dart'; 

// IMPORTA IL SERVIZIO NOTIFICHE
import '../notifications/notification_service.dart'; 

// IMPORTA I NUOVI WIDGET E LA LOGICA
import 'widgets/role_selector.dart'; 
import 'widgets/image_input.dart';
import 'widgets/save.dart'; // Assumo che NewLocaleLogic sia qui dentro

// IMPORTA LA PAGINA DI DESTINAZIONE
import '../../MonthPage/MonthPage.dart';

class NewLocale extends StatefulWidget {
  const NewLocale({super.key});

  @override
  State<NewLocale> createState() => _NewLocaleState();
}

class _NewLocaleState extends State<NewLocale> {
  final TextEditingController _nomeController = TextEditingController();
  String? _selectedRole; 
  File? _imageFile;

  // Funzione UI: Scelta immagine
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Funzione UI: Gestione del click su Salva
  Future<void> _onSavePressed() async {
    final testo = AppLocalizations.of(context)!;

    // 1. Validazione UI (Visuale)
    if (_nomeController.text.isEmpty || _selectedRole == null) {
      // --- MODIFICA: USA IL NUOVO SISTEMA DI NOTIFICHE ---
      NotificationService().showError(testo.erroreCampi);
      return;
    }

    // 2. Chiamata alla Business Logic (Esterna)
    // Avvolgiamo tutto in un try-catch per gestire eventuali errori del DB
    try {
      await NewLocaleLogic.salvaLocale(
        nome: _nomeController.text,
        ruolo: _selectedRole!,
        imageFile: _imageFile,
      );

      // (Opzionale) Mostra notifica di successo verde
      // NotificationService().showSuccess("Locale creato con successo!");

      // 3. Navigazione
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MonthPage()),
        );
      }
    } catch (e) {
      // Se c'è un errore nel salvataggio, lo mostriamo col pop-up rosso
      NotificationService().showError("Errore durante il salvataggio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(testo.nuovoLocale),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            ImageInput(
              imageFile: _imageFile,       
              labelText: testo.scattaFoto, 
              onTap: _pickImage,           
            ),
            
            const SizedBox(height: 20),

            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: testo.nomeLocale, 
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.store),
              ),
            ),
            
            const SizedBox(height: 15),
            
            RoleSelector(
              selectedValue: _selectedRole,
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
            ),
            
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSavePressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(testo.salva, style: const TextStyle(fontSize: 18)), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}