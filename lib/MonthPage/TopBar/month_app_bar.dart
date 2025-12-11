import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../DataBase/Locale/LocaleModel.dart';

class MonthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ItemModel? localeCorrente;
  final DateTime dataOggi;
  final VoidCallback onMenuPressed;

  const MonthAppBar({
    super.key,
    required this.localeCorrente,
    required this.dataOggi,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Recuperiamo lo schema colori attuale (Light o Dark)
    final colorScheme = Theme.of(context).colorScheme;

    // Logica formattazione data
    String nomeMese = DateFormat('MMMM', 'it_IT').format(dataOggi);
    nomeMese = toBeginningOfSentenceCase(nomeMese) ?? nomeMese;

    String titolo = localeCorrente != null 
        ? "${localeCorrente!.nome} • $nomeMese" 
        : "Nessun Locale • $nomeMese";

    return AppBar(
      // COLORE SFONDO: surface (Bianco su Light, Scuro su Dark)
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      
      // 1. MENU
      leading: IconButton(
        // COLORE ICONA: onSurface (Nero su Light, Bianco su Dark)
        icon: Icon(Icons.menu, color: colorScheme.onSurface),
        onPressed: onMenuPressed,
      ),

      // 2. TITOLO
      title: Text(
        titolo,
        // COLORE TESTO: onSurface (Nero su Light, Bianco su Dark)
        style: TextStyle(color: colorScheme.onSurface, fontSize: 18),
      ),

      // 3. AVATAR UTENTE
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            // Sfondo avatar: usa un colore primario del tema o grigio neutro
            backgroundColor: Colors.blueGrey, 
            radius: 18,
            backgroundImage: (localeCorrente?.imagePath != null && 
                              File(localeCorrente!.imagePath!).existsSync())
                ? FileImage(File(localeCorrente!.imagePath!))
                : null,
            child: (localeCorrente?.imagePath == null)
                ? Text(
                    localeCorrente?.nome.isNotEmpty == true 
                      ? localeCorrente!.nome[0].toUpperCase() 
                      : "U",
                    // Il testo dentro il pallino lo lasciamo bianco per contrasto col blueGrey
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}