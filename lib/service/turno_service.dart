import 'package:supabase_flutter/supabase_flutter.dart';
import '../DataBase/Turni/TurnoModel.dart';

class TurnoService {
  static final TurnoService _instance = TurnoService._internal();
  factory TurnoService() => _instance;
  TurnoService._internal();

  final _supabase = Supabase.instance.client;

  /// Recupera tutti i turni di un locale specifico
  /// (L'RLS nel DB filtrerà automaticamente solo i tuoi dati)
  Future<List<TurnoModel>> getTurniByLocale(int idLocale) async {
    try {
      final List<dynamic> response = await _supabase
          .from('turni')
          .select()
          .eq('id_locale', idLocale);

      return response.map((json) => TurnoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Errore nel caricamento turni: $e');
    }
  }

  /// Aggiunge un nuovo turno (Iniettando il user_id)
  Future<TurnoModel> addTurno(TurnoModel turno) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      final json = turno.toJson();
      json['user_id'] = user.id; // <--- FONDAMENTALE

      final data = await _supabase
          .from('turni')
          .insert(json)
          .select()
          .single();
      
      return TurnoModel.fromJson(data);
    } catch (e) {
      throw Exception('Errore nell\'aggiunta del turno: $e');
    }
  }

  /// Aggiorna un turno (Con filtro di sicurezza per evitare hijacking)
  Future<void> updateTurno(TurnoModel turno) async {
    try {
      if (turno.id == null) throw Exception("ID turno mancante");
      
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      await _supabase
          .from('turni')
          .update(turno.toJson())
          .eq('id', turno.id!)
          .eq('user_id', user.id); // <--- Sicurezza extra: modifica solo se tuo
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento del turno: $e');
    }
  }

  /// Elimina un turno (Con filtro di sicurezza)
  Future<void> deleteTurno(int id) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      await _supabase
          .from('turni')
          .delete()
          .eq('id', id)
          .eq('user_id', user.id); // <--- Sicurezza extra: elimina solo se tuo
    } catch (e) {
      throw Exception('Errore nell\'eliminazione del turno: $e');
    }
  }

  /// Recupera i turni di un dipendente specifico per una data
  Future<List<TurnoModel>> getTurniByDipendenteEData(int idDipendente, DateTime data) async {
    try {
      final dataStr = data.toIso8601String().split('T')[0];

      final List<dynamic> response = await _supabase
          .from('turni')
          .select()
          .eq('id_dipendente', idDipendente)
          .eq('data', dataStr); 

      return response.map((json) => TurnoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Errore nel caricamento turni per dipendente: $e');
    }
  }
}