// File: lib/Dipendenti/logic/dipendenti_logic.dart
import '../../DataBase/Dipendente/DipendenteDB.dart';
import '../../DataBase/Dipendente/DipendenteModel.dart';
import '../../service/preferences_service.dart'; 

class DipendentiLogic {
  
  // 1. Recupera i dipendenti SOLO del locale selezionato
  static Future<List<DipendenteModel>> getDipendenti() async {
    final int? idLocaleCorrente = PreferencesService().idLocaleCorrente;
    
    if (idLocaleCorrente == null) {
      return [];
    }

    return await DipendenteDB().getDipendentiByLocale(idLocaleCorrente);
  }

  // 2. Elimina
  static Future<void> eliminaDipendente(int id) async {
    await DipendenteDB().deleteDipendente(id);
  }

  // 3. Salva (Aggiungi o Modifica)
  static Future<void> salvaDipendente({
    int? id,
    required String nome,
    String? cognome,
    required double ore,
    required int coloreValue,
  }) async {
    
    final int? idLocaleCorrente = PreferencesService().idLocaleCorrente;

    if (idLocaleCorrente == null) {
      throw Exception("Impossibile salvare: Nessun locale selezionato");
    }

    final dipendente = DipendenteModel(
      id: id,
      idLocale: idLocaleCorrente,
      nome: nome,
      cognome: cognome,
      oreLavoro: ore,
      colore: coloreValue,
    );

    if (id == null) {
      await DipendenteDB().addDipendente(dipendente);
    } else {
      await DipendenteDB().updateDipendente(dipendente); 
    }
  }

  // 4.
  // Prende la lista completa e la stringa cercata, restituisce la lista filtrata
  static List<DipendenteModel> filtraDipendenti(List<DipendenteModel> listaOriginale, String query) {
    // Se la ricerca è vuota, restituisci tutto
    if (query.isEmpty) {
      return listaOriginale;
    }
    
    final queryLower = query.toLowerCase();
    
    // Filtra controllando se nome o cognome contengono la stringa
    return listaOriginale.where((dip) {
      final nomeCompleto = "${dip.nome} ${dip.cognome ?? ''}".toLowerCase();
      return nomeCompleto.contains(queryLower);
    }).toList();
  }
}