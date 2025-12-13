// File: lib/Dipendenti/DipendentiPage.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../../DataBase/Dipendente/DipendenteModel.dart';
import '../notifications/notification_service.dart';
import 'logic/dipendenti_logic.dart';
import 'widgets/dipendente_card.dart';
import 'widgets/dipendente_form.dart';
// IMPORTA IL NUOVO WIDGET
import 'widgets/dipendente_search_app_bar.dart';

class DipendentiPage extends StatefulWidget {
  const DipendentiPage({super.key});

  @override
  State<DipendentiPage> createState() => _DipendentiPageState();
}

class _DipendentiPageState extends State<DipendentiPage> {
  List<DipendenteModel> _listaDipendenti = []; // Lista Originale
  List<DipendenteModel> _listaFiltrata = [];   // Lista Visualizzata
  bool _isLoading = true;
  
  // Gestione stato ricerca
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _aggiornaLista();
  }

  Future<void> _aggiornaLista() async {
    final dati = await DipendentiLogic.getDipendenti();
    setState(() {
      _listaDipendenti = dati;
      // Se stiamo cercando, ri-applichiamo il filtro, altrimenti mostriamo tutto
      _listaFiltrata = _isSearching 
          ? DipendentiLogic.filtraDipendenti(dati, _searchController.text)
          : dati;
      _isLoading = false;
    });
  }

  // Funzione chiamata quando l'utente scrive
  void _onSearchChanged(String query) {
    setState(() {
      _listaFiltrata = DipendentiLogic.filtraDipendenti(_listaDipendenti, query);
    });
  }

  // Funzioni gestione UI Ricerca
  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _listaFiltrata = _listaDipendenti; // Reset della lista
    });
  }

  // ... (Metodi _mostraForm e _confermaEliminazione rimangono identici a prima) ...
  void _mostraForm({DipendenteModel? dipendente}) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (ctx) => DipendenteForm(dipendenteEsistente: dipendente),
    );
    if (result == true) {
      _aggiornaLista();
      NotificationService().showSuccess("Operazione completata!");
    }
  }

  void _confermaEliminazione(int id) {
    // ... (copia il codice della conferma eliminazione che avevamo prima)
     final testo = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(testo.dipendenti_titolo),
        content: Text(testo.msg_elimina_conferma),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(testo.btn_annulla),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); 
              await DipendentiLogic.eliminaDipendente(id);
              _aggiornaLista();
              NotificationService().showSuccess("Dipendente eliminato");
            },
            child: Text(testo.btn_conferma, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testo = AppLocalizations.of(context)!;

    return Scaffold(
      // --- USIAMO LA NUOVA APP BAR ---
      appBar: DipendenteSearchAppBar(
        titolo: testo.dipendenti_titolo,
        isSearching: _isSearching,
        searchController: _searchController,
        hintText: "${testo.label_nome}...",
        onStartSearch: _startSearch,
        onStopSearch: _stopSearch,
        onSearchChanged: _onSearchChanged,
      ),

      // LISTA
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listaFiltrata.isEmpty
              ? Center(
                  child: Text(
                    _isSearching ? "Nessun risultato" : testo.dipendenti_nessuno
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100, top: 8),
                  itemCount: _listaFiltrata.length,
                  itemBuilder: (context, index) {
                    final dip = _listaFiltrata[index];
                    return DipendenteCard(
                      dipendente: dip,
                      onEdit: () => _mostraForm(dipendente: dip),
                      onDelete: () => _confermaEliminazione(dip.id!),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostraForm(), 
        child: const Icon(Icons.add),
      ),
    );
  }
}