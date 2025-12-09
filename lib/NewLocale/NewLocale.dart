import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart' as path; 

import '../l10n/app_localizations.dart'; 

import '../../Database/Locale/LocaleDB.dart';
import '../../Database/Locale/LocaleModel.dart';

class NewLocale extends StatefulWidget {
  const NewLocale({super.key});

  @override
  State<NewLocale> createState() => _NewLocaleState();
}

class _NewLocaleState extends State<NewLocale> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _pdController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    final testo = AppLocalizations.of(context)!;

    if (_nomeController.text.isEmpty || _pdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        // CORRETTO: Usa la nuova chiave 'erroreCampi'
        SnackBar(content: Text(testo.erroreCampi)),
      );
      return;
    }

    String? finalImagePath;

    if (_imageFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await _imageFile!.copy('${appDir.path}/$fileName');
      finalImagePath = savedImage.path;
    }

    final newItem = ItemModel(
      nome: _nomeController.text,
      pd: _pdController.text,
      imagePath: finalImagePath,
    );

    await DBHelper().insertItem(newItem);

    // Navigazione disabilitata per ora
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
    final testo = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(testo.nuovoLocale),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
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

            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: testo.nomeLocale, 
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _pdController,
              decoration: InputDecoration(
                // CORRETTO: Usa la nuova chiave 'responsabileDipendente'
                labelText: testo.responsabileDipendente, 
                border: const OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveData,
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