import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../DataBase/Locale/LocaleModel.dart';

class MonthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LocaleModel? localeCorrente;
  final DateTime dataOggi;

  const MonthAppBar({
    super.key,
    required this.localeCorrente,
    required this.dataOggi,
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
      title: Text(
        titolo,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 18),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey, 
            radius: 18,
            // Visualizziamo solo le iniziali
            child: Text(
              localeCorrente?.nome.isNotEmpty == true 
                  ? localeCorrente!.nome[0].toUpperCase() 
                  : "U",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}