import 'dart:io';

// IMPORTA I DATABASE, MODELLI E SERVIZI
import '../../Database/Locale/LocaleDB.dart';
import '../../Database/Locale/LocaleModel.dart';
import '../../service/preferences_service.dart';
import '../widgets/image_helper.dart';

class NewLocaleLogic {
  
  static Future<void> salvaLocale({
    required String nome,
    required String ruolo,
    File? imageFile,
  }) async {
    
    String? finalImagePath;

    // 1. Gestione Immagine
    if (imageFile != null) {
      finalImagePath = await ImageHelper.saveImageToAppDir(imageFile);
    }

    // 2. Creazione Modello
    final newItem = ItemModel(
      nome: nome,
      pd: ruolo,
      imagePath: finalImagePath,
    );

    // 3. Scrittura su DB e RECUPERO ID
    // La funzione insertItem restituisce l'ID della riga appena creata (es. 1, 2, 3...)
    int nuovoId = await DBHelper().insertItem(newItem);

    // 4. SALVATAGGIO NELLE PREFERENZE (ROOT PRINCIPALE)
    // Diciamo all'app: "Da ora in poi, lavora su questo locale qui"
    PreferencesService().idLocaleCorrente = nuovoId;
    
    print("Locale creato con ID: $nuovoId e impostato come corrente.");
  }
}