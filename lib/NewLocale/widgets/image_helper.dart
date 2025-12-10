import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  // Funzione statica: non serve istanziare la classe per usarla
  static Future<String> saveImageToAppDir(File imageFile) async {
    // 1. Trova la cartella documenti dell'app
    final appDir = await getApplicationDocumentsDirectory();
    
    // 2. Genera un nome unico usando il timestamp attuale
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // 3. Copia il file nella cartella sicura
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    
    // 4. Restituisce il percorso (Stringa) da salvare nel DB
    return savedImage.path;
  }
}