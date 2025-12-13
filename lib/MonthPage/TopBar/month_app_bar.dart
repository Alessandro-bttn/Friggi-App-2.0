import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../DataBase/Locale/LocaleModel.dart';

class MonthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ItemModel? localeCorrente;
  final DateTime dataOggi;
  // RIMOSSO: final VoidCallback onMenuPressed; <-- Non serve più

  const MonthAppBar({
    super.key,
    required this.localeCorrente,
    required this.dataOggi,
    // RIMOSSO: required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    String nomeMese = DateFormat('MMMM', 'it_IT').format(dataOggi);
    nomeMese = toBeginningOfSentenceCase(nomeMese) ?? nomeMese;
    String anno = DateFormat('yyyy').format(dataOggi);

    String titolo = localeCorrente != null 
        ? "${localeCorrente!.nome} • $nomeMese $anno" 
        : "Nessun Locale • $nomeMese $anno";

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      // RIMOSSO: leading: IconButton(...) <-- Flutter ora lo gestisce in automatico
      
      title: Text(
        titolo,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 18),
      ),
      actions: [
        // ... (Il resto del codice per l'avatar rimane uguale)
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
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