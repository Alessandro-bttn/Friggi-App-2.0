// File: lib/Dipendenti/widgets/dipendente_card.dart
import 'package:flutter/material.dart';
import '../../DataBase/Dipendente/DipendenteModel.dart';

class DipendenteCard extends StatelessWidget {
  final DipendenteModel dipendente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DipendenteCard({
    super.key,
    required this.dipendente,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Gestione colori tema
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // 1. PALLINO COLORE
        leading: CircleAvatar(
          backgroundColor: Color(dipendente.colore),
          child: Text(
            dipendente.nome[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        
        // 2. NOME E COGNOME
        title: Text(
          "${dipendente.nome} ${dipendente.cognome ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        
        // 3. ORE LAVORO
        subtitle: Text("${dipendente.oreLavoro}h"),
        
        // 4. BOTTONI AZIONE
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}