// File: lib/NewLocale/logic/new_locale_logic.dart
import 'dart:io';

// IMPORTA I TUOI HELPER E MODELLI
import '../../Database/Locale/LocaleDB.dart';
import '../../Database/Locale/LocaleModel.dart';
import '../widgets/image_helper.dart';

class NewLocaleLogic {
  
  /// Questa funzione si occupa di tutto il "lavoro sporco":
  /// 1. Salva la foto (se c'è)
  /// 2. Crea l'oggetto ItemModel
  /// 3. Lo scrive nel Database
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

    // 3. Scrittura su DB
    await DBHelper().insertItem(newItem);
  }
}