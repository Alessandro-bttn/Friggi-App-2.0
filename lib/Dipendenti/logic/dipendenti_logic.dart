// File: lib/Dipendenti/logic/dipendenti_logic.dart
import '../../service/dipendente_service.dart';
import '../../DataBase/Dipendente/DipendenteModel.dart';
import '../../service/preferences_service.dart'; 

// Questa classe contiene tutta la logica legata ai dipendenti: recupero, salvataggio, eliminazione e filtraggio. 
// In questo modo, se in futuro dovessi cambiare il modo in cui gestisco i dipendenti (ad esempio, passando a un'API), 
// dovrò modificare solo questa classe senza toccare l'interfaccia utente o altre parti dell'app.

class DipendentiLogic {
  
  // 1. Recupera i dipendenti SOLO del locale selezionato
  static Future<List<DipendenteModel>> getDipendenti() async {
    final int? idLocaleCorrente = PreferencesService().idLocaleCorrente;
    
    if (idLocaleCorrente == null) {
      return [];
    }

    return await DipendenteService().getDipendentiByLocale(idLocaleCorrente);
  }

  // 2. Elimina
  static Future<void> eliminaDipendente(int id) async {
    await DipendenteService().deleteDipendente(id);
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

      colore: coloreValue,
    );

    if (id == null) {
      await DipendenteService().addDipendente(dipendente);
    } else {
      await DipendenteService().updateDipendente(dipendente);
    }
  }

  // 4. Filtra i dipendenti
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