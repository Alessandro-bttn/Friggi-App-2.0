import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../Locale/LocaleModel.dart'; // Assicurati di importare il modello creato sopra

class DBHelper {
  // Singleton: per avere una sola istanza del DB aperta
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inizializza il DB
  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'gestione_spese.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Creazione della tabella
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            pd TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  // --- OPERAZIONI ---

  // 1. Inserisci nuovo elemento
  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return await db.insert('items', item.toMap());
  }

  // 2. Leggi tutti gli elementi
  Future<List<ItemModel>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
  }
  
  // 3. Cancella elemento
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
  
  // 4. Controllo esistenza (Per il tuo FutureBuilder iniziale!)
  Future<bool> checkDatabaseExists() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'gestione_spese.db');
    return File(path).exists();
  }
  // Funzione che controlla se c'è almeno una riga nella tabella
  Future<bool> hasData() async {
    final db = await database; // Questo apre (o crea vuoto) il DB se non è aperto
    
    // Esegue una query SQL per contare le righe
    // Sqflite.firstIntValue serve a prendere il numero intero dal risultato
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM items'));
    
    // Restituisce true se count è maggiore di 0, altrimenti false
    return (count ?? 0) > 0;
  }

  // Funzione per ELIMINARE il database
  Future<void> deleteDB() async {
    // 1. Ottieni il percorso
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'gestione_spese.db');

    // 2. Se il database è aperto in memoria, CHIUDILO prima di cancellarlo
    // Questo previene l'errore "database_closed"
    if (_database != null) {
      await _database!.close();
      _database = null; // Resetta la variabile
    }

    // 3. Cancella il file fisico
    await deleteDatabase(path);
    
    print("DATABASE CANCELLATO E CHIUSO CORRETTAMENTE");
  }
  
  // 5. Ottieni elemento per ID (se necessario)
  Future<ItemModel?> getItemById(int id) async {
    final db = await database;
    final maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromMap(maps.first);
    } else {
      return null;
    }
  }
}