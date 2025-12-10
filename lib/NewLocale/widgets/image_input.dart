import 'dart:io';
import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final File? imageFile;      // L'immagine da mostrare (se c'è)
  final VoidCallback onTap;   // La funzione da chiamare quando si clicca
  final String labelText;     // Il testo "Scatta foto" (tradotto)

  const ImageInput({
    super.key,
    required this.imageFile,
    required this.onTap,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    labelText,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
      ),
    );
  }
}