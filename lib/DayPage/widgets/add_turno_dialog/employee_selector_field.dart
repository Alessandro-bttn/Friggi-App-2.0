import 'package:flutter/material.dart';
import '../../../DataBase/Dipendente/DipendenteDB.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../service/preferences_service.dart';
import '../../../l10n/app_localizations.dart';

class EmployeeSelectorField extends StatefulWidget {
  final DipendenteModel? selectedDipendente;
  final Function(DipendenteModel?) onSelected;

  const EmployeeSelectorField({
    super.key,
    required this.selectedDipendente,
    required this.onSelected,
  });

  @override
  State<EmployeeSelectorField> createState() => _EmployeeSelectorFieldState();
}

class _EmployeeSelectorFieldState extends State<EmployeeSelectorField> {
  List<DipendenteModel> _allDipendenti = [];
  bool _isLoading = true;
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _loadDipendenti();
  }

  Future<void> _loadDipendenti() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    if (idLocale == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final lista = await DipendenteDB().getDipendentiByLocale(idLocale);
      if (mounted) {
        setState(() {
          _allDipendenti = lista;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SearchAnchor(
      searchController: _searchController,
      // Configurazione dell'aspetto della vista di ricerca espansa
      viewHintText: l10n.dipendenti_seleziona + "...",
      viewLeading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _searchController.closeView(null),
      ),
      viewTrailing: [
        IconButton(
          icon: const Icon(Icons.person_add_alt_1, color: Colors.blue),
          onPressed: () {
             // Logica per aggiungere dipendente
             debugPrint("Navigazione a Nuovo Dipendente");
          },
        ),
      ],
      // Il widget che appare "a riposo" (la barra di ricerca chiusa)
      builder: (BuildContext context, SearchController controller) {
        return InkWell(
          onTap: _isLoading ? null : () => controller.openView(),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.turni_label_dipendente,
              prefixIcon: const Icon(Icons.person_search_outlined),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            child: Row(
              children: [
                if (widget.selectedDipendente != null) ...[
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Color(widget.selectedDipendente!.colore),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.selectedDipendente!.nome} ${widget.selectedDipendente!.cognome ?? ''}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ] else
                  Text(
                    _isLoading ? "..." : l10n.dipendenti_seleziona,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        );
      },
      // Logica di generazione dei suggerimenti/risultati durante la digitazione
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final String keyword = controller.text.toLowerCase();
        
        final filteredList = _allDipendenti.where((d) {
          return d.nome.toLowerCase().contains(keyword) ||
                 (d.cognome?.toLowerCase().contains(keyword) ?? false);
        }).toList();

        if (filteredList.isEmpty) {
          return [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Text(l10n.dipendenti_nessuno)),
            )
          ];
        }

        return filteredList.map((dip) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: Color(dip.colore)),
            title: Text("${dip.nome} ${dip.cognome ?? ''}"),
            onTap: () {
              widget.onSelected(dip);
              // Chiude la vista di ricerca e pulisce il controller
              controller.closeView(null);
            },
          );
        }).toList();
      },
    );
  }
}