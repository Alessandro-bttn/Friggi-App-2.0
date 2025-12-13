import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  // Potresti passare l'indice della pagina corrente per evidenziarla
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const AppDrawer({
    super.key,
    this.selectedIndex = 0, // Default sulla prima voce (es. Home/Calendario)
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Utilizziamo NavigationDrawer per Material Design 3
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        // Chiude il drawer prima di navigare
        Navigator.of(context).pop(); 
        // Chiama la funzione passata dal genitore per gestire la navigazione
        onDestinationSelected(index);
      },
      children: [
        // HEADER DEL DRAWER (Opzionale: logo, nome app, ecc.)
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            testo.menu_titolo,
            style: theme.textTheme.titleMedium,
          ),
        ),
        
        const Divider(indent: 28, endIndent: 28), // Separatore MD3

        // --- VOCI DEL MENU ---

        // VOCE 0: Home/Calendario (La pagina attuale)
        NavigationDrawerDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          label: Text(testo.newLocale_titolo), // Usiamo "Nuovo Locale" come placeholder per "Home"
        ),
        
        // VOCE 1: Gestione Dipendenti
        NavigationDrawerDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: Text(testo.menu_gestioneDipendenti),
        ),

        // VOCE 2: Statistiche
        NavigationDrawerDestination(
          icon: const Icon(Icons.bar_chart_outlined),
          selectedIcon: const Icon(Icons.bar_chart),
          label: Text(testo.menu_statistiche),
        ),

        const Divider(indent: 28, endIndent: 28), // Separatore per le impostazioni

        // VOCE 3: Impostazioni
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(testo.menu_impostazioni),
        ),
      ],
    );
  }
}