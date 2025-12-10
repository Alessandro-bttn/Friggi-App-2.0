import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 

// IMPORTA LE LINGUE
import '../l10n/app_localizations.dart'; 

// IMPORTA IL DB E IL MODELLO
import '../../Database/Locale/LocaleDB.dart';
import '../../Database/Locale/LocaleModel.dart';

// IMPORTA I NUOVI FILE (WIDGET E HELPER)
import 'widgets/role_selector.dart'; 
import 'widgets/image_helper.dart';

// IMPORTA LA PAGINA DI DESTINAZIONE
import '../../MonthPage/MonthPage.dart';

class NewLocale extends StatefulWidget {
  const NewLocale({super.key});

  @override
  State<NewLocale> createState() => _NewLocaleState();
}

class _NewLocaleState extends State<NewLocale> {
  final TextEditingController _nomeController = TextEditingController();
  
  // Variabile per il ruolo selezionato
  String? _selectedRole; 
  
  File? _imageFile;

  // Funzione per scegliere immagine (UI Logic)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Funzione di salvataggio principale
  Future<void> _saveData() async {
    final testo = AppLocalizations.of(context)!;

    // 1. Validazione
    if (_nomeController.text.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(testo.erroreCampi)),
      );
      return;
    }

    String? finalImagePath;

    // 2. Salvataggio Immagine (Delegato all'helper esterno)
    if (_imageFile != null) {
      // Usiamo la funzione creata nel file esterno: molto più pulito!
      finalImagePath = await ImageHelper.saveImageToAppDir(_imageFile!);
    }

    // 3. Creazione Modello
    final newItem = ItemModel(
      nome: _nomeController.text,
      pd: _selectedRole!, 
      imagePath: finalImagePath,
    );

    // 4. Salvataggio DB
    // L'await qui è fondamentale: aspetta che il DB risponda prima di proseguire
    await DBHelper().insertItem(newItem);
    
    print("Dati salvati correttamente nel DB: ${newItem.toMap()}");

    // 5. Navigazione verso MonthPage
    if (mounted) {
      // pushReplacement serve a NON far tornare indietro l'utente a questa schermata
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MonthPage()),
      );
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
            // --- BOX FOTO ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          Text(testo.scattaFoto), 
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // --- NOME ---
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: testo.nomeLocale, 
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.store),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // --- MENU A TENDINA (Widget Esterno) ---
            RoleSelector(
              selectedValue: _selectedRole,
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
            ),
            
            const SizedBox(height: 30),

            // --- BOTTONE SALVA ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveData, // Chiama la funzione sopra
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