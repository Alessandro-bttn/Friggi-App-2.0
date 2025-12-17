import 'package:flutter/material.dart';
import '../../../DataBase/Locale/LocaleModel.dart';

import 'widgets/app_bar_leading.dart';
import 'widgets/app_bar_title.dart';
import 'widgets/app_bar_avatar.dart';

class MonthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ItemModel? localeCorrente;
  final DateTime dataOggi;
  final bool showDay;

  const MonthAppBar({
    super.key,
    required this.localeCorrente,
    required this.dataOggi,
    this.showDay = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,

      // 1. Bottone: Ora gestisce automaticamente Freccia o Menu (Hamburger)
      leading: const AppBarLeading(),

      // 2. Titolo: Pulito, solo testo
      title: AppBarTitle(
        localeCorrente: localeCorrente,
        dataOggi: dataOggi,
        showDay: showDay,
      ),

      // 3. Avatar a destra (rimane uguale)
      actions: [
        AppBarAvatar(localeCorrente: localeCorrente),
      ],
    );
  }
}