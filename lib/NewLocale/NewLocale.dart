// 1. DART CORE
import 'dart:io';

// 2. PACCHETTI FLUTTER
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart'; 

// 3. SERVIZI
import '../notifications/notification_service.dart';

// 4. LOGICA DI BUSINESS
import 'widgets/save.dart'; 

// 5. WIDGETS
import 'widgets/image_input.dart';
import 'widgets/role_selector.dart';

// 6. PAGINE
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
  
  // Variabile per evitare il doppio click sulla galleria (Crash "Already Active")
  bool _isPickingImage = false; 

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Errore immagine: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _onSavePressed() async {
    final testo = AppLocalizations.of(context)!;

    // 1. Validazione UI
    if (_nomeController.text.isEmpty || _selectedRole == null) {
      NotificationService().showError(testo.error_campiMancanti);
      return;
    }

    // 2. Chiamata alla Business Logic
    try {
      await NewLocaleLogic.salvaLocale(
        nome: _nomeController.text,
        ruolo: _selectedRole!,
        imageFile: _imageFile,
      );

      NotificationService().showSuccess(testo.newLocale_successo);

      // 3. Navigazione
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MonthPage()),
        );
      }
    } catch (e) {
      // CORREZIONE QUI: Uso l'interpolazione della stringa (segno del dollaro)
      // invece del segno +
      NotificationService().showError("${testo.error_erroreSalvataggio}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(testo.newLocale_titolo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            ImageInput(
              imageFile: _imageFile,
              labelText: testo.newLocale_fotoHint, 
              onTap: _pickImage,           
            ),
            
            const SizedBox(height: 20),

            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: testo.newLocale_nomeLabel, 
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
                child: Text(testo.btnSalva, style: const TextStyle(fontSize: 18)), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}