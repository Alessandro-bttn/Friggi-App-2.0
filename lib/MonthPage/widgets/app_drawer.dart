import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  // L'indice della pagina attualmente selezionata (0=Home, 1=Dipendenti, etc.)
  final int selectedIndex;
  // Funzione callback che comunica al genitore (MonthPage) quale voce è stata cliccata
  final Function(int) onDestinationSelected;

  const AppDrawer({
    super.key,
    this.selectedIndex = 0, 
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Recuperiamo le traduzioni
    final testo = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Se le traduzioni non sono ancora caricate, mostriamo un loader o un drawer vuoto per evitare crash
    if (testo == null) return const SizedBox();

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        // 1. Chiudiamo il drawer (comportamento standard)
        Navigator.of(context).pop(); 
        
        // 2. Notifichiamo la pagina principale del cambio
        onDestinationSelected(index);
      },
      children: [
        // --- HEADER DEL DRAWER ---
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 16), // Spaziatura standard M3
          child: Text(
            testo.menu_titolo, // Es: "Gestione Turni"
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        
        const Divider(indent: 28, endIndent: 28), 

        // --- VOCI DEL MENU ---

        // VOCE 0: Home / Calendario
        NavigationDrawerDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          // NOTA: Qui ho messo 'Calendario' come fallback se la chiave non è corretta.
          // Cambia 'testo.newLocale_titolo' con una chiave tipo 'testo.menu_home' se preferisci.
          label: Text("Calendario"), 
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

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Divider(),
        ),

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