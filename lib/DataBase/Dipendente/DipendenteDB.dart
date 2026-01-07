import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DipendenteModel.dart';

class DipendenteDB {
  // Singleton pattern
  static final DipendenteDB _instance = DipendenteDB._internal();
  factory DipendenteDB() => _instance;
  DipendenteDB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inizializzazione DB
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'dipendenti.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Creazione Tabella con il nuovo campo idLocale
        await db.execute('''
          CREATE TABLE dipendenti(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idLocale INTEGER NOT NULL,  -- <--- NUOVA COLONNA IMPORTANTE
            nome TEXT NOT NULL,
            cognome TEXT,
            colore INTEGER NOT NULL,
            oreLavoro REAL NOT NULL
          )
        ''');
      },
    );
  }

  // --- METODI CRUD ---

  // 1. ADD (Aggiungi Dipendente)
  Future<int> addDipendente(DipendenteModel dipendente) async {
    final db = await database;
    return await db.insert('dipendenti', dipendente.toMap());
  }

  // 2. ELIMINA (Tramite ID)
  Future<int> deleteDipendente(int id) async {
    final db = await database;
    return await db.delete(
      'dipendenti',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 3. GET DIPENDENTI BY LOCALE (Sostituisce il vecchio GetAll generico)
  // Recupera solo i dipendenti che appartengono a uno specifico negozio
  Future<List<DipendenteModel>> getDipendentiByLocale(int idLocale) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dipendenti',
      where: 'idLocale = ?', // Filtro SQL
      whereArgs: [idLocale],
    );

    return List.generate(maps.length, (i) {
      return DipendenteModel.fromMap(maps[i]);
    });
  }

  // 4. RICERCA PER ID
  Future<DipendenteModel?> getDipendenteById(int id) async {
    final db = await database;
    final maps = await db.query(
      'dipendenti',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DipendenteModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // 5. UPDATE (Modifica Dipendente)
  Future<int> updateDipendente(DipendenteModel dipendente) async {
    final db = await database;

    return await db.update(
      'dipendenti', // Nome Tabella
      dipendente.toMap(), // Nuovi dati (incluso idLocale, nome, colore, ecc.)
      where: 'id = ?', // Condizione
      whereArgs: [dipendente.id],
    );
  }

  Future<List<DipendenteModel>> getAllDipendenti() async {
    // Assicurati che 'database' sia il getter del tuo DB e 'Dipendenti' il nome della tabella corretto
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Dipendenti'); // O il nome della tua tabella

    return List.generate(maps.length, (i) {
      return DipendenteModel.fromMap(maps[i]);
    });
  }
}
