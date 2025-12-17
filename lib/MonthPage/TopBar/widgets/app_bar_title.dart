import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../DataBase/Locale/LocaleModel.dart';

class AppBarTitle extends StatelessWidget {
  final ItemModel? localeCorrente;
  final DateTime dataOggi;
  final bool showDay;

  const AppBarTitle({
    super.key,
    required this.localeCorrente,
    required this.dataOggi,
    required this.showDay,
  });

  String _getFormattedDate() {
    try {
      if (showDay) {
        return DateFormat('d MMMM', 'it_IT').format(dataOggi);
      } else {
        return DateFormat('MMMM yyyy', 'it_IT').format(dataOggi);
      }
    } catch (e) {
      return showDay
          ? "${dataOggi.day}/${dataOggi.month}"
          : "${dataOggi.month}/${dataOggi.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. NOME LOCALE (Testo fisso)
        if (localeCorrente != null)
          Text(
            localeCorrente!.nome.toUpperCase(),
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),

        // 2. DATA
        Text(
          _getFormattedDate().toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}