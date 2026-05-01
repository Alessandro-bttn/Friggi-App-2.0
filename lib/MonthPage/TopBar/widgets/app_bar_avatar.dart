import 'package:flutter/material.dart';
import '../../../DataBase/Locale/LocaleModel.dart';

class AppBarAvatar extends StatelessWidget {
  final LocaleModel? localeCorrente;

  const AppBarAvatar({super.key, required this.localeCorrente});

  @override
  Widget build(BuildContext context) {
    if (localeCorrente == null) {
      return const SizedBox(width: 48); // Spazio vuoto per bilanciare
    }

    // Prende l'iniziale del nome
    final String initial = localeCorrente!.nome.isNotEmpty
        ? localeCorrente!.nome[0].toUpperCase()
        : "?";

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blueAccent,
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}