import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'TurnoModel.dart';

class TurniDB {
  static final TurniDB _instance = TurniDB._internal();
  factory TurniDB() => _instance;
  TurniDB._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'turni_database.db');
    return await openDatabase(
      path,
      version: 2, // Incrementa versione se hai già il DB, o disinstalla l'app
      onCreate: (db, version) async {
        // TABELLA AGGIORNATA
        await db.execute('''
          CREATE TABLE turni(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idDipendente INTEGER, 
            data TEXT,
            inizio TEXT,
            fine TEXT
          )
        ''');
      },
      // Se vuoi gestire l'aggiornamento senza disinstallare:
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Logica per cancellare la vecchia tabella e rifarla (per sviluppo)
          await db.execute("DROP TABLE IF EXISTS turni");
          await db.execute('''
            CREATE TABLE turni(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              idDipendente INTEGER, 
              data TEXT,
              inizio TEXT,
              fine TEXT
            )
          ''');
        }
      },
    );
  }

  Future<int> insertTurno(TurnoModel turno) async {
    final dbClient = await db;
    return await dbClient.insert('turni', turno.toMap());
  }

  Future<List<TurnoModel>> getTurniDelGiorno(DateTime data) async {
    final dbClient = await db;
    final dataStr = data.toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'turni',
      where: 'data = ?',
      whereArgs: [dataStr],
    );

    return List.generate(maps.length, (i) {
      return TurnoModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteTurno(int id) async {
    final dbClient = await db;
    await dbClient.delete('turni', where: 'id = ?', whereArgs: [id]);
  }
}