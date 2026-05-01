import 'package:supabase_flutter/supabase_flutter.dart';
import '../DataBase/Dipendente/DipendenteModel.dart';

class DipendenteService {
  static final DipendenteService _instance = DipendenteService._internal();
  factory DipendenteService() => _instance;
  DipendenteService._internal();

  final _supabase = Supabase.instance.client;

  /// Recupera tutti i dipendenti di un locale specifico
  /// (Grazie all'RLS, verranno mostrati solo i dipendenti di cui l'utente è proprietario)
  Future<List<DipendenteModel>> getDipendentiByLocale(int idLocale) async {
    try {
      final response = await _supabase
          .from('dipendenti')
          .select()
          .eq('id_locale', idLocale); 
          // RLS filtrerà automaticamente le righe in base al user_id

      return (response as List<dynamic>)
          .map((json) => DipendenteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Errore nel caricamento dipendenti: $e');
    }
  }

  /// Aggiunge un nuovo dipendente INIETTANDO il user_id
  Future<void> addDipendente(DipendenteModel dipendente) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      final data = dipendente.toJson();
      data['user_id'] = user.id; // <--- FONDAMENTALE: collega il record all'utente!

      await _supabase.from('dipendenti').insert(data);
    } catch (e) {
      throw Exception('Errore nell\'aggiunta dipendente: $e');
    }
  }

  /// Aggiorna un dipendente con filtro di sicurezza aggiuntivo
  Future<void> updateDipendente(DipendenteModel dipendente) async {
    try {
      if (dipendente.id == null) throw Exception("ID dipendente mancante");
      
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      await _supabase
          .from('dipendenti')
          .update(dipendente.toJson())
          .eq('id', dipendente.id!)
          .eq('user_id', user.id); // <--- Sicurezza extra: modifica solo se tuo
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento dipendente: $e');
    }
  }

  /// Elimina un dipendente con filtro di sicurezza aggiuntivo
  Future<void> deleteDipendente(int id) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      await _supabase
          .from('dipendenti')
          .delete()
          .eq('id', id)
          .eq('user_id', user.id); // <--- Sicurezza extra: elimina solo se tuo
    } catch (e) {
      throw Exception('Errore nell\'eliminazione dipendente: $e');
    }
  }
}