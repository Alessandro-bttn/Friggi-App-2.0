import 'package:flutter/material.dart';
import 'dart:io';
import '../../../DataBase/Locale/LocaleModel.dart';

class AppBarAvatar extends StatelessWidget {
  final ItemModel? localeCorrente;

  const AppBarAvatar({super.key, required this.localeCorrente});

  @override
  Widget build(BuildContext context) {
    if (localeCorrente == null) {
      return const SizedBox(width: 48); // Spazio vuoto per bilanciare
    }

    // Verifica se esiste l'immagine (usa 'imagePath' o 'immagine' a seconda del tuo Model)
    final String? imagePath = localeCorrente!.imagePath; 
    final bool hasImage = imagePath != null && imagePath.isNotEmpty;

    // Prende l'iniziale del nome
    final String initial = localeCorrente!.nome.isNotEmpty
        ? localeCorrente!.nome[0].toUpperCase()
        : "?";

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blueAccent,
        backgroundImage: hasImage ? FileImage(File(imagePath)) : null,
        child: !hasImage
            ? Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}