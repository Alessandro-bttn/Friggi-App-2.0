import 'package:flutter/material.dart';
import '../../../DataBase/Locale/LocaleModel.dart';

import 'widgets/app_bar_leading.dart';
import 'widgets/app_bar_title.dart';
import 'widgets/app_bar_avatar.dart';
import 'widgets/view_selector.dart'; // Importa il nuovo file

class MonthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ItemModel? localeCorrente;
  final DateTime dataOggi;
  final bool showDay;
  final String currentView;
  final Function(String) onViewChanged;

  const MonthAppBar({
    super.key,
    required this.localeCorrente,
    required this.dataOggi,
    required this.onViewChanged, // Callback per cambiare vista
    this.showDay = false,
    this.currentView = 'Mese',
  });

  // Aumentiamo l'altezza per ospitare il selettore
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: const AppBarLeading(),
      title: AppBarTitle(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
        showDay: showDay,
      ),
      actions: [
        AppBarAvatar(localeCorrente: localeCorrente),
      ],
      // Richiamiamo il widget esterno
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: ViewSelector(
          currentView: currentView,
          onViewChanged: onViewChanged,
        ),
      ),
    );
  }
}