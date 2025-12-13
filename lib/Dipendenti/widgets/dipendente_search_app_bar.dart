// File: lib/Dipendenti/widgets/dipendente_search_app_bar.dart
import 'package:flutter/material.dart';

class DipendenteSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titolo;
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onStartSearch; // Quando clicchi la lente
  final VoidCallback onStopSearch;  // Quando clicchi la X
  final Function(String) onSearchChanged; // Mentre scrivi
  final String hintText;

  const DipendenteSearchAppBar({
    super.key,
    required this.titolo,
    required this.isSearching,
    required this.searchController,
    required this.onStartSearch,
    required this.onStopSearch,
    required this.onSearchChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      // Se stiamo cercando mostra il TextField, altrimenti il Titolo normale
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: theme.hintColor),
              ),
              onChanged: onSearchChanged,
            )
          : Text(titolo),
      
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search),
          onPressed: isSearching ? onStopSearch : onStartSearch,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}