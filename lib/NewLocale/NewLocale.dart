import 'dart:io'; // Per gestire i File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Per la fotocamera
import 'package:path_provider/path_provider.dart'; // Per le cartelle
import 'package:path/path.dart' as path; // Per manipolare i percorsi

import '../Database/Locale/LocaleDB.dart';
import '../Database/Locale/LocaleModel.dart';
import '../MonthPage/MonthPage.dart'; // Importa la tua pagina principale

class NewLocale extends StatefulWidget {
  const NewLocale({super.key});

  @override
  State<NewLocale> createState() => _NewLocaleState();
}

class _NewLocaleState extends State<NewLocale> {
  // Controller per leggere il testo dai campi
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _pdController = TextEditingController();

  // Variabile per mostrare l'anteprima della foto
  File? _imageFile;

  // Funzione per scegliere l'immagine
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    
    // CAMBIATO: Usa .gallery invece di .camera
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Funzione per salvare tutto
  Future<void> _saveData() async {
    if (_nomeController.text.isEmpty || _pdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inserisci Nome e P/D")),
      );
      return;
    }

    String? finalImagePath;

    // SE l'utente ha scattato una foto, dobbiamo salvarla in modo permanente
    if (_imageFile != null) {
      // 1. Troviamo la cartella sicura dell'app
      final appDir = await getApplicationDocumentsDirectory();
      // 2. Creiamo un nome file unico (es: timestamp.jpg)
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      // 3. Copiamo la foto dalla cache (tmp) alla cartella sicura
      final savedImage = await _imageFile!.copy('${appDir.path}/$fileName');
      
      finalImagePath = savedImage.path;
    }

    // Creiamo il modello
    final newItem = ItemModel(
      nome: _nomeController.text,
      pd: _pdController.text, // Qui salviamo P o D
      imagePath: finalImagePath, // Può essere null se non c'è foto
    );

    // Salviamo nel DB
    await DBHelper().insertItem(newItem);

    // Navighiamo alla pagina principale
    /*
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MonthPage()),
      );
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuovo Locale")),
      body: SingleChildScrollView( // Per evitare errori se la tastiera copre lo schermo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SEZIONE FOTO ---
            GestureDetector(
              onTap: _pickImage, // Cliccando si apre la fotocamera
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover) // Mostra la foto
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          Text("Tocca per scattare foto"),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // --- CAMPI DI TESTO ---
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome Locale",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _pdController,
              decoration: const InputDecoration(
                labelText: "P / D", // Pranzo o Cena?
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 30),

            // --- BOTTONE SALVA ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("SALVA E CONTINUA", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}