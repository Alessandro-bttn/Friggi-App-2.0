import 'package:flutter/material.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({super.key});

  @override
  Widget build(BuildContext context) {
    // CASO A: C'è una pagina precedente? (Es. DayPage)
    if (Navigator.canPop(context)) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    
    // CASO B: Siamo nella pagina principale (MonthPage)?
    // Mostriamo l'icona del Menu che apre il Drawer
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.black, size: 24), // Icona Hamburger
      onPressed: () {
        // Questo comando apre il Drawer definito nello Scaffold
        Scaffold.of(context).openDrawer();
      },
    );
  }
}